import 'dart:io';
import 'package:flutter/material.dart';

import 'package:camera_image_converter/camera_image_converter.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/camera/camera_ml_vision.dart';
import 'package:gauthsy/components/camera/camera_overlay.dart';
import 'package:gauthsy/components/camera/camera.dart';
import 'package:gauthsy/components/loaders/loaders.dart';
import 'package:gauthsy/file_manager/file_manager.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/views/scanner/controller_scanner.dart';
import 'package:image/image.dart' as IMG;
import 'package:permission_handler/permission_handler.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

class FrontBackFaceScanner extends StatefulWidget {
  final String documentIssuedBy;
  final String documentType;

  FrontBackFaceScanner(
      {@required this.documentType, @required this.documentIssuedBy});

  @override
  _FrontBackFaceScannerState createState() => _FrontBackFaceScannerState();
}

class _FrontBackFaceScannerState extends State<FrontBackFaceScanner> {
  FaceDetector detector = FirebaseVision.instance.faceDetector();

  double get width => MediaQuery.of(context).size.width;

  double get height => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: Permissions.camera(true),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data) {
          return Scaffold(
              backgroundColor: NeumorphicTheme.baseColor(context),
              body: CameraWithFocus<dynamic>(
                  controllerScanner: controllerScanner,
                  title: controllerScanner.title,
                  prev: () {
                    Navigator.pop(context);
                  },
                  onResult: controllerScanner.onResult,
                  detector: controllerScanner.processImage,
                  onPressing: () async {
                    return true;
                  }));
        }
        return Scaffold(
          backgroundColor: NeumorphicTheme.baseColor(context),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DoubleBounce(),
                    SizedBox(height: 10),
                    Text('Awaiting for permissions', style: TextStyle(fontSize: 17))
                  ],
                ),
                Container(
                  alignment: Alignment.topLeft,
                  height: 110,
                  child: TopBar(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ControllerScanner controllerScanner;

  @override
  void initState() {
    controllerScanner = ControllerScanner(context, setState,
        documentIssuedBy: widget.documentIssuedBy,
        documentType: widget.documentType);
    super.initState();
  }

  @override
  void dispose() {
    controllerScanner.detector.close();
    super.dispose();
  }
}
