import 'package:flutter/material.dart';

class FormModel {
  bool autovalidate = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String token = "";
  String password = "";

  bool validate() {
    if (formKey.currentState == null)
      return false;
    else
      return formKey.currentState.validate();
  }

  Map<String, dynamic> toJson() {
    return {
      "token": token,
      "password": password,
    };
  }
}
