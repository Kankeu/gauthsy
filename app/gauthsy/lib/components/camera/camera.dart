library camera;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/camera/camera_ml_vision.dart';
import 'package:gauthsy/components/camera/camera_overlay.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/loaders/loaders.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:gauthsy/views/scanner/controller_scanner.dart';
import 'package:gauthsy/views/scanner/document_submitted.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:page_transition/page_transition.dart';

class CameraWithFocus<T> extends StatefulWidget {
  final Future Function(File, T) onResult;
  final ControllerScanner controllerScanner;
  final Future<bool> Function() onPressing;
  final HandleDetection<T> detector;
  final Function prev;
  final String title;

  CameraWithFocus(
      {@required this.detector,
      @required this.controllerScanner,
      @required this.onPressing,
      @required this.onResult,
      @required this.title,
      @required this.prev});

  @override
  _CameraWithFocusState<T> createState() => _CameraWithFocusState<T>();
}

class _CameraWithFocusState<T> extends State<CameraWithFocus<T>> {
  double get height => MediaQuery.of(context).size.height;

  double get width => MediaQuery.of(context).size.width;
  CameraMLController cameraMLController;
  ValueNotifier<bool> pressing = ValueNotifier(false);
  int lastStep;

  @override
  Widget build(BuildContext context) {
    if (widget.controllerScanner.retry||widget.controllerScanner.step != lastStep) pressing.value = false;
    lastStep = widget.controllerScanner.step;
    return Stack(
      children: <Widget>[
        CameraMlVision<T>(
          scan: pressing,
          controllerScanner: widget.controllerScanner,
          onInitialized: (CameraMLController cameraMLController) {
            setState(() {
              this.cameraMLController = cameraMLController;
            });
          },
          builder: (BuildContext context, Widget child) {
            return CameraOverlay(
                controllerScanner: widget.controllerScanner,
                scanning: pressing.value,
                title: widget.title,
                child: Container(height: height, width: width, child: child));
          },
          resolution: ResolutionPreset.ultraHigh,
          detector: widget.detector,
          onResult: widget.onResult,
        ),
        Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.all(10),
            child: SafeArea(
              child: NeumorphicButton(
                  onPressed: widget.prev,
                  style: NeumorphicStyle(boxShape: NeumorphicBoxShape.circle()),
                  child: Icon(Icons.navigate_before, size: 30)),
            )),
        Container(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.all(20),
          child: Neumorphic(
            style: NeumorphicStyle(border: NeumorphicBorder()),
            child: Container(
              height: height * .3,
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 1; i <= 3; i++)
                          if (i == widget.controllerScanner.step)
                            Container(
                              decoration: BoxDecoration(
                                  color: UIData.colors.primary,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30))),
                              child: Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle),
                                    padding: EdgeInsets.all(20),
                                    child: Text("$i",
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                      i == 1
                                          ? "Front side"
                                          : (i == 2 ? "Back side" : "Face"),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 17)),
                                  SizedBox(width: 10),
                                ],
                              ),
                            )
                          else
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white, shape: BoxShape.circle),
                              padding: EdgeInsets.all(
                                  i > widget.controllerScanner.step ? 20 : 15),
                              child: i > widget.controllerScanner.step
                                  ? Text("$i",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 17))
                                  : Icon(Icons.check, color: Colors.green),
                            ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    child: Text(
                        widget.controllerScanner.step == 1
                            ? "Scan the front of your ID"
                            : (widget.controllerScanner.step == 2
                                ? "Scan the back of your ID"
                                : (widget.controllerScanner.step == 3
                                    ? "Scan your face"
                                    : "Send the result of the scan")),
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    // height: height * .25,
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        NeumorphicButton(
                            onPressed: () {
                              if (cameraMLController != null) {
                                cameraMLController.flip();
                              }
                            },
                            style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.circle()),
                            child: Icon(Icons.flip_camera_android, size: 30)),
                        MMutation(DocumentSchema.createDocument,
                            errorMessages: {"payload.expiry_date": "The document has expired"},
                            update: (GraphQLDataProxy cache, QueryResult data) {
                          print(data.data);
                          print(data.exception);
                          if (!data.hasException) {
                            MToast.success("Document sent");
                            Navigator.of(context).pushReplacement(
                                PageTransition(
                                    type:
                                        PageTransitionType.rightToLeftWithFade,
                                    child: DocumentSubmitted()));
                          } else
                            MToast.error("Oops an error occurred");
                        }, builder: (
                          RunMutation runMutation,
                          QueryResult result,
                        ) {
                          if (widget.controllerScanner.step == 4)
                            return NeumorphicButton(
                              onPressed: () async {
                                if (!widget.controllerScanner.validate()) {
                                  return MToast.error("Invalid document");
                                }
                                runMutation(
                                   {'data': await widget.controllerScanner.toJson()});
                              },
                              style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.circle(),
                              ),
                              padding: EdgeInsets.all(20),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (pressing.value || result.isLoading)
                                    Container(
                                      width: 80,
                                      height: 80,
                                      child: DoubleBounce(),
                                    )
                                  else
                                  Container(
                                    decoration: BoxDecoration(
                                        color: UIData.colors.primary,
                                        shape: BoxShape.circle),
                                    padding: const EdgeInsets.all(10.0),
                                    child: Icon(
                                      Icons.send,
                                      size: 60,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          else
                            return GestureDetector(
                              onLongPressUp: () {
                                print("UP");
                                setState(() {
                                  pressing.value = false;
                                });
                              },
                              onLongPress: () {
                                print("DOWN");
                                setState(() {
                                  pressing.value = true;
                                });
                                Future.doWhile(() async {
                                  while (pressing.value) {
                                    await widget.onPressing();
                                    await Future.delayed(
                                        Duration(milliseconds: 500));
                                  }
                                  return pressing.value;
                                });
                              },
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  if (pressing.value)
                                    Container(
                                      width: 110,
                                      height: 110,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 10,
                                          value:
                                              widget.controllerScanner.progress,
                                          backgroundColor:
                                              UIData.colors.background),
                                    ),
                                  Neumorphic(
                                    style: NeumorphicStyle(
                                        boxShape: NeumorphicBoxShape.circle(),
                                        depth: pressing.value ? 0 : 6),
                                    padding: const EdgeInsets.all(24.0),
                                    child: Icon(Icons.camera, size: 60),
                                  ),
                                ],
                              ),
                            );
                        }),
                        NeumorphicButton(
                            onPressed: () {
                              print("--------------------------");
                              if (cameraMLController != null) {
                                setState(() {
                                  cameraMLController.triggerFlash();
                                });
                              }
                            },
                            style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.circle()),
                            child: Icon(
                                cameraMLController?.flash == true
                                    ? Icons.flash_on
                                    : Icons.flash_off,
                                size: 30))
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    pressing.value = false;
    super.dispose();
  }
}
