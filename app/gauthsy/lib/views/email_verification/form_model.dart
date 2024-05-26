import 'package:flutter/material.dart';

class FormModel{
  bool autovalidate = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String confirmationLink ="";

  bool validate(){
    if(formKey.currentState==null)
      return false;
    else return formKey.currentState.validate();

  }

  Map<String, dynamic> toJson(){
    return {
      "token": confirmationLink.split("/").last
    };
  }
}