import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/cards/m_title.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/fields/fields.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/kernel/validations/validator.dart';

class EditPasswordCard extends StatefulWidget {
  final Auth user;
  final int fieldId;

  EditPasswordCard({@required this.user, @required this.fieldId});

  @override
  _EditPasswordCardState createState() => _EditPasswordCardState();
}

class _EditPasswordCardState extends State<EditPasswordCard> {
  Auth get user => widget.user;
  final formModel = new FormModel();

  @override
  Widget build(BuildContext context) {
    return MMutation(UserSchema.updatePassword,
        onSuccess: (_, QueryResult result) {
      if (result.data['updateUser'] != null) {
        MToast.success("Password saved");
      }
    },ignoreErrors: ["auth:5"],onError: (result){
      if(result.graphqlErrors.isNotEmpty&&result.graphqlErrors[0].extensions["category"]=="auth:5")
        MFlushBar.flushBarError(
          title:"Password change failed",
          message:"The last password is invalid");
        }, builder: (RunMutation runMutation, QueryResult result) {
      return Neumorphic(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          style: NeumorphicStyle(
            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(12)),
          ),
          child: Container(
              width: double.infinity,
              child: Form(
                  key: formModel.formKey,
                  autovalidate: formModel.autovalidate,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MTitle(text: "Password"),
                        SizedBox(height: 8),
                        MTextField(
                          autofocus: widget.fieldId == 3,
                          label: "Last password",
                          hint: "Last password",
                          isPassword: true,
                          value: formModel.lastPassword,
                          validator: Validator().minLength(6).required().make(),
                          onChanged: (lastPassword) {
                            formModel.lastPassword = lastPassword;
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        MTextField(
                          label: "New password",
                          hint: "New password",
                          maxLength: 30,
                          isPassword: true,
                          value: formModel.password,
                          validator: Validator()
                              .required()
                              .minLength(6)
                              .maxLength(30)
                              .make(),
                          onChanged: (password) {
                            formModel.password = password;
                            if (formModel.confirmPassword?.isNotEmpty != false)
                              Future.delayed(Duration(milliseconds: 100),
                                  () => setState(() {}));
                          },
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        MTextField(
                          label: "Confirm new password",
                          hint: "Confirm new password",
                          maxLength: 30,
                          isPassword: true,
                          value: formModel.confirmPassword,
                          validator: Validator()
                              .required()
                              .minLength(6)
                              .maxLength(30)
                              .same(formModel.password, "password")
                              .make(),
                          onChanged: (confirmPassword) {
                            formModel.confirmPassword = confirmPassword;
                          },
                        ),
                        SizedBox(height: 8),
                        MButton(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          hint: "Save Password",
                          loading: result.isLoading,
                          onPressed: () {
                            if (!formModel.validate())
                              return formModel.autovalidate = true;
                            runMutation({"data": formModel.toJson()});
                          },
                        ),
                        SizedBox(height: 20),
                      ]))));
    });
  }
}

class FormModel {
  bool autovalidate = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String password = "";
  String confirmPassword = "";
  String lastPassword = "";

  bool validate() {
    if (formKey.currentState == null)
      return false;
    else
      return formKey.currentState.validate();
  }

  Map<String, dynamic> toJson() {
    return {
      "last_password": lastPassword,
      "password": password,
    };
  }
}
