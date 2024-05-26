import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'dart:ui';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/views/scanner/controller_scanner.dart';
import 'package:mrz_parser/mrz_parser.dart';

class ResultDialog extends StatefulWidget {
  final ControllerScanner controllerScanner;
  final String title, descriptions, text;

  const ResultDialog(
      {Key key,
      this.title,
      this.descriptions,
      this.text,
      this.controllerScanner})
      : super(key: key);

  @override
  _ResultDialogState createState() => _ResultDialogState();
}

class _ResultDialogState extends State<ResultDialog> {
  MRZResult get result => widget.controllerScanner.result;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: 20, top: (45 + 20).toDouble(), right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 70),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: NeumorphicTheme.baseColor(context),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10),
              Text(
                "Are the information correct?",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 5),
              Text(
                'If not click on "Retry" to scan again',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Divider(),
              SizedBox(height: 10),
              Row(
                children: [
                  Text('Document type: ', style: TextStyle(color: Colors.grey)),
                  Text(result.documentType),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Country code: ', style: TextStyle(color: Colors.grey)),
                  Text(result.countryCode),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Surnames: ', style: TextStyle(color: Colors.grey)),
                  Text(result.surnames),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Given names: ', style: TextStyle(color: Colors.grey)),
                  Text(result.givenNames),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Document number: ',
                      style: TextStyle(color: Colors.grey)),
                  Text(result.documentNumber),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Nationality code: ',
                      style: TextStyle(color: Colors.grey)),
                  Text(result.nationalityCountryCode),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Birthdate: ', style: TextStyle(color: Colors.grey)),
                  Text(result.birthDate.toString().split(" ")[0]),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Sex: ', style: TextStyle(color: Colors.grey)),
                  Text(result.sex == Sex.female ? "F" : "M"),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Expiry date: ', style: TextStyle(color: Colors.grey)),
                  Text(result.expiryDate.toString().split(" ")[0]),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Personal number: ',
                      style: TextStyle(color: Colors.grey)),
                  Text(result.personalNumber.toString()),
                ],
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Text('Personal number 2: ',
                      style: TextStyle(color: Colors.grey)),
                  Text(result.personalNumber2.toString()),
                ],
              ),
              SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  children: [
                    Spacer(),
                    TextButton(
                      child: const Text('Retry'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: Text(
                          "Confirm",
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 70,
            key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(70)),
                child: Image.memory(
                  Uint8List.fromList(
                      widget.controllerScanner.frontFace.readAsBytesSync()),
                  fit: BoxFit.cover,
                )),
          ),
        ),
      ],
    );
  }
}
