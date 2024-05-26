import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:gauthsy/views/home/home_body.dart';

class DocumentSubmitted extends StatefulWidget {
  @override
  _DocumentSubmittedState createState() => _DocumentSubmittedState();
}

class _DocumentSubmittedState extends State<DocumentSubmitted> {
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
              SizedBox(height: height * .1),
              Image.asset(UIData.images.boarding2, height: 200, width: 200),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    Text("Identification submitted successfully",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    SizedBox(height: height * .1),
                    Text(
                        "Thank you for using our online identification service! You can now close the app and will be informed about the next steps.",
                        style: TextStyle(fontSize: 17,color: Colors.grey),
                        textAlign: TextAlign.center),
                    SizedBox(height: height * .1),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: NeumorphicButton(
                  onPressed: (){
                    HomeBody.refetch();
                    Navigator.of(context).pop(true);
                  },
                  padding: EdgeInsets.symmetric(vertical: 15),
                  style: NeumorphicStyle(
                      color: Colors.orange,
                      boxShape: NeumorphicBoxShape.stadium()),
                  child: Center(
                      child: Text("Finish",
                          style: TextStyle(fontSize: 17, color: Colors.white))),
                ),
              )
            ],
          ),
        )));
  }
}
