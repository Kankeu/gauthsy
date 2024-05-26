import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import 'package:camera_image_converter/camera_image_converter.dart';
import 'package:gauthsy/components/camera/camera_ml_vision.dart';
import 'package:gauthsy/components/camera/camera_overlay.dart';
import 'package:gauthsy/components/camera/camera.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/file_manager/file_manager.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/views/scanner/result_dialog.dart';
import 'package:image/image.dart' as IMG;
import 'package:image_size_getter/file_input.dart';
import 'package:image_size_getter/image_size_getter.dart';
import 'package:mrz_parser/mrz_parser.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import "package:http/http.dart" show MultipartFile;

class ControllerScanner {
  final BuildContext context;
  final void Function(void Function()) setState;

  ControllerScanner(this.context, this.setState,
      {@required this.documentType, @required this.documentIssuedBy});

  int step = 1;
  File front;
  File back;
  File frontFace;
  File face;
  final String documentIssuedBy;
  final String documentType;
  dynamic detector = FirebaseVision.instance.faceDetector();

  bool get retry {
    _retry = false;
    return _retry;
  }

  void set retry(v) {
    _retry = v;
  }

  bool _retry;

  Future onResult(File image, dynamic result) async {
    print("---------***************$step***************--------");

    if (step == 1) {
      var faces = result as List<Face>;
      if (faces.length == 1) {
        final face = faces.first;
        if (await analyseFront(image, face)) next();
      }
    } else if (step == 2) {
      var visionText = result as VisionText;
      if (visionText == null || visionText.blocks.isEmpty) {
        return;
      }
      if (await analyseBack(image, visionText)) next();
    } else if (step == 3) {
      var faces = result as List<Face>;
      if (faces.length == 1) {
        final face = faces.first;
       /* print("******************"+face.smilingProbability.toString()+"*****************");
        if (face.smilingProbability > .75) {
          MToast.error("Don't smile");
          return;
        }
        if (face.leftEyeOpenProbability > .75) {
          MToast.error("Keep your eyes open");
          return;
        }
        if (face.rightEyeOpenProbability > .75) {
          MToast.error("Keep your eyes open");
          return;
        }*/
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");
        next();
      }
    }
  }

  Future<dynamic> processImage(FirebaseVisionImage image) {
    return detector.processImage(image);
  }

  String get title => step == 1
      ? "Center the front side of document inside the box and press the button to scan"
      : "Center the back side of document inside the box and press the button to scan";

  next() {
    detector.close();
    setState(() {
      if (step == 1) {
        detector = FirebaseVision.instance.textRecognizer();
        step = 2;
        progress = 0;
        MToast.success("Flip the document");
      } else if (step == 2) {
        detector = FirebaseVision.instance.faceDetector();
        step = 3;
        progress = 0;
        MToast.success("Scan your face");
      } else if (step == 3) {
        detector = FirebaseVision.instance.faceDetector();
        step = 4;
        progress = 0;
        MToast.success("Scan finished");
      }
    });
  }

  Future<Map<String, dynamic>> toJson() async {
    final payload = {
      'surname': result.surnames.toUpperCase(),
      'forename': result.givenNames.toUpperCase(),
      'country_code': result.countryCode.toUpperCase(),
      'document_type': result.documentType.toUpperCase(),
      'sex': result.sex == Sex.female ? "F" : "M",
      'document_number': result.documentNumber.toUpperCase(),
      'birth_date': result.birthDate.toDateString(),
      'expiry_date': result.expiryDate.toDateString(),
    };
    if (result.nationalityCountryCode != null &&
        result.nationalityCountryCode.isNotEmpty)
      payload['nationality_country_code'] =
          result.nationalityCountryCode.toUpperCase();
    if (result.personalNumber != null && result.personalNumber.isNotEmpty)
      payload['personal_number'] = result.personalNumber.toUpperCase();
    if (result.personalNumber2 != null && result.personalNumber2.isNotEmpty)
      payload['personal_number2'] = result.personalNumber2.toUpperCase();
    return {
      'type': result.documentType.toUpperCase(),
      'number': result.documentNumber,
      'issued_by': ({
        'D': 'DE',
        'CMR': 'CM',
        'RWA': 'RW'
      })[result.countryCode.toUpperCase()],
      'payload': payload,
      'images': [
        {
          'type': 'FRONT',
          'file': await MultipartFile.fromPath("file", front.path)
        },
        {
          'type': 'FRONT_FACE',
          'file': await MultipartFile.fromPath("file", frontFace.path)
        },
        {
          'type': 'BACK',
          'file': await MultipartFile.fromPath("file", back.path)
        },
        {
          'type': 'FACE',
          'file': await MultipartFile.fromPath("file", face.path)
        }
      ]
    };
  }

  bool validate() {
    return documentType == result.documentType.toUpperCase() &&
        documentIssuedBy == result.countryCode.toUpperCase() &&
        result.expiryDate.isAfter(DateTime.now());
  }

  Future<File> toFile(CameraImage image, int rotate) async {
    await Permissions.storage(true);
    double scaleX = image.width / CameraOverlay.getPos()[4];
    double scaleY = image.height / CameraOverlay.getPos()[5];

    final topOffset =
        CameraOverlay.getPos()[1] * scaleY * (image.width / image.height);
    final leftOffset =
        CameraOverlay.getPos()[0] * scaleX * (image.height / image.width);

    double width =
        CameraOverlay.getPos()[2] * scaleX * (image.height / image.width);
    double height =
        CameraOverlay.getPos()[3] * scaleY * (image.width / image.height);

    print(
        "--- rotate:$rotate top:$topOffset left: $leftOffset width: ${image.width} height: ${image.height}---");

    final path = FileManager.tmpDir +
        (step == 1 ? "/front.png" : (step == 2 ? "/back.png" : "/face.png"));
    final jpeg = await CameraImageConverter.convertCameraImageTo(image);
    if (step == 1 || step == 3)
      setState(() {
        progress = .25;
      });
    var file = File(path);
    if (!file.existsSync()) file.createSync(recursive: true);

    file.writeAsBytesSync(IMG.encodePng(IMG.copyCrop(
        IMG.copyRotate(IMG.decodeImage(jpeg), rotate - 90),
        leftOffset.toInt(),
        topOffset.toInt(),
        width.toInt(),
        height.toInt())));

    if (step == 1)
      front = file;
    else if (step == 2)
      back = file;
    else
      face = file;

    return file;
  }

  Future<bool> analyseFront(File file, Face face) async {
    setState(() {
      progress = .50;
    });
    await Permissions.storage(true);
    final jpeg = file.readAsBytesSync();

    setState(() {
      progress = .75;
    });
    // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
    IMG.Image thumbnail = IMG.copyCrop(
        IMG.decodeImage(jpeg),
        face.boundingBox.left.toInt() - 18,
        face.boundingBox.top.toInt() - 20,
        face.boundingBox.width.toInt() + 34,
        face.boundingBox.height.toInt() + 40);

    // Save the thumbnail as a PNG.
    this.frontFace = File(FileManager.tmpDir + "/front_face.png");
    this.frontFace.writeAsBytesSync(IMG.encodePng(thumbnail));
    setState(() {
      progress = 1;
    });
    return true;
  }

  double progress = 0;
  List<Map<String, int>> samples = [
    Map<String, int>(),
    Map<String, int>(),
    Map<String, int>()
  ];

  MRZResult result;

  Future<bool> analyseBack(File image, VisionText visionText) async {
    var mrz;
    bool confirmed = false;
    var lines = visionText.blocks.expand<TextLine>((e) => e.lines).toList();
    for (int i = lines.length - 1; i > 1; i--) {
      var mrzLines = [lines[i - 2], lines[i - 1], lines[i]];
      mrz = mrzLines
          .map<String>((e) => e.text.replaceAll(" ", "").toUpperCase())
          .toList();
      print(mrz);
      result = MRZParser.tryParse(mrz);
      print(result?.documentNumber);
      if (result != null) {
        for (int s = 0; s < 3; s++) {
          if (samples[s].containsKey(mrz[s]))
            samples[s][mrz[s]] += 1;
          else
            samples[s][mrz[s]] = 1;
        }
        print(samples);
        print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        int counter = samples[0].values.fold(0, (acc, x) => acc + x);
        setState(() {
          progress = counter / 5;
        });
        if (counter >= 5) {
          var resmrz = samples
              .map<String>(
                  (e) => e.keys.reduce((acc, x) => e[acc] > e[x] ? acc : x))
              .toList();
          result = MRZParser.tryParse(resmrz);
          samples = [
            Map<String, int>(),
            Map<String, int>(),
            Map<String, int>()
          ];

          confirmed = await showResultDialog(result);
          retry = !confirmed;
        } else
          result = null;
        break;
      }
      if (lines.length - i > 11) break;
    }
    return confirmed;
  }

  Future<bool> showResultDialog(MRZResult result) async {
    setState(() {
      progress = 0;
    });
    return await showDialog<bool>(
        context: context,
        builder: (context) => ResultDialog(controllerScanner: this));
  }
}
