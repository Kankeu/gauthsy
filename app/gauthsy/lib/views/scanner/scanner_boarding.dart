import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:gauthsy/views/scanner/front_back_face_scanner.dart';
import 'package:page_transition/page_transition.dart';

class ScannerBoarding extends StatefulWidget {
  final String documentIssuedBy;
  final String documentType;

  ScannerBoarding(
      {@required this.documentType, @required this.documentIssuedBy});

  @override
  _ScannerBoardingState createState() => _ScannerBoardingState();
}

class _ScannerBoardingState extends State<ScannerBoarding> {
  double get height => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  NeumorphicButton(
                    padding: EdgeInsets.all(15),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.circle()
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Icon(Icons.navigate_before),
                  ),
                ],
              ),
              SizedBox(height: height * .05),
              Image.asset(UIData.images.boarding2, height: 100, width: 100),
              Text("Photograph your ID",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              SizedBox(height: height * .1),
              Image.asset(UIData.images.boarding3, height: 100, width: 100),
              Text("Take a selfie",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              SizedBox(height: height * .1),
              Image.asset(UIData.images.boarding1, height: 100, width: 100),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child:  Text("An agent will verify your ID and notify you",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center)),
              SizedBox(height: height * .1),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: NeumorphicButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.of(context).push(PageTransition(
                        type: PageTransitionType.rightToLeftWithFade,
                        child: FrontBackFaceScanner(documentType: widget.documentType,documentIssuedBy: widget.documentIssuedBy)));
                  },
                  padding: EdgeInsets.symmetric(vertical: 15),
                  style: NeumorphicStyle(
                      color: Colors.orange,
                      boxShape: NeumorphicBoxShape.stadium()),
                  child: Center(
                      child: Text("Ok, I am ready",
                          style: TextStyle(fontSize: 17, color: Colors.white))),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        )));
  }
}
