import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gauthsy/helpers/helpers.dart';


class FormModel{
  bool autovalidate = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String forename = "";
  String surname = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  double age = 18;
  String gender;
  bool ppAccepted=false;

  bool validate(){
      if(formKey.currentState==null)
        return false;
      else return formKey.currentState.validate();
  }

  Map<String, dynamic> toJson(){
    return {
      "forename":forename,
      "surname": surname,
      "email":email,
      "password": password,
    };
  }
}