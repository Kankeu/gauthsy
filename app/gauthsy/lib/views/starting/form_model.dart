import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class FormModel{
  bool autovalidate = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = "";
  String password = "";

  bool validate(){
    if(formKey.currentState==null)
      return false;
    else return formKey.currentState.validate();
  }

  Map<String, dynamic> toJson(){
    return {
      "email":email,
      "password": password,
    };
  }
}