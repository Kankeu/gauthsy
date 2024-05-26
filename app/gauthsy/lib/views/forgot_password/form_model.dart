import 'package:flutter/material.dart';

class FormModel {
  bool autovalidate = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String email = "";

  bool validate() {
    if (formKey.currentState == null)
      return false;
    else
      return formKey.currentState.validate();
  }

  Map<String, dynamic> toJson() {
    return {
      "email": email,
    };
  }
}
