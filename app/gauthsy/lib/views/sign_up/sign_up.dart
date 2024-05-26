import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/fields/fields.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/images/images.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/kernel/validations/validator.dart';
import 'package:gauthsy/localization/app_localization.dart';
import 'package:gauthsy/views/email_verification/email_verification.dart';
import 'package:gauthsy/views/sign_up/form_model.dart';
import 'package:gauthsy/helpers/helpers.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool pressed = false;

  final FormModel formModel = new FormModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Container(
            height: double.infinity,
            child: SafeArea(
              child: SingleChildScrollView(
                child: MMutation(UserSchema.signUp,
                    onSuccess: (_, QueryResult result) {
                  if (result.data['signUp'] != null) {
                    MToast.success("Email sent");
                    AuthManager.signUp(result.data['signUp']);
                  }
                }, builder: (RunMutation runMutation, QueryResult result) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TopBar(),
                      Neumorphic(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12)),
                        ),
                        child: Form(
                          key: formModel.formKey,
                          autovalidate: formModel.autovalidate,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 8,
                              ),
                              NeumorphicButton(
                                style: NeumorphicStyle(
                                  boxShape: NeumorphicBoxShape.circle(),
                                ),
                                onPressed: () {
                                  setState(() {
                                    pressed = !pressed;
                                  });
                                },
                                child: Avatar(
                                  child: Icon(
                                    pressed
                                        ? Icons.sentiment_very_satisfied
                                        : Icons.insert_emoticon,
                                    size: 120,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              MTextField(
                                value: formModel.forename,
                                label: trans("form.forename").toCapitalize(),
                                hint: trans("form.forename").toCapitalize(),
                                maxLength: 30,
                                validator:
                                    Validator().required().maxLength(30).make(),
                                onChanged: (forename) {
                                  setState(() {
                                    formModel.forename = forename;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              MTextField(
                                value: formModel.surname,
                                label: trans("form.surname").toCapitalize(),
                                hint: trans("form.surname").toCapitalize(),
                                maxLength: 30,
                                validator:
                                    Validator().required().maxLength(30).make(),
                                onChanged: (surname) {
                                  setState(() {
                                    formModel.surname = surname;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              MTextField(
                                value: formModel.email,
                                label: trans("form.email").toCapitalize(),
                                hint: trans("form.email").toCapitalize(),
                                validator:
                                    Validator().required().email().make(),
                                onChanged: (email) {
                                  setState(() {
                                    formModel.email = email;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              MTextField(
                                label: trans("form.pwd").toCapitalize(),
                                hint: trans("form.pwd").toCapitalize(),
                                maxLength: 30,
                                isPassword: true,
                                value: formModel.password,
                                validator: Validator()
                                    .required()
                                    .minLength(6)
                                    .maxLength(30)
                                    .make(),
                                onChanged: (password) {
                                  setState(() {
                                    formModel.password = password;
                                  });
                                  if (formModel.confirmPassword?.isNotEmpty !=
                                      false)
                                    Future.delayed(Duration(milliseconds: 100),
                                        () => setState(() {}));
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              MTextField(
                                label: trans("form.confirm_pwd").toTitleCase(),
                                hint: trans("form.confirm_pwd").toTitleCase(),
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
                                  setState(() {
                                    formModel.confirmPassword = confirmPassword;
                                  });
                                },
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              PpCheckbox(
                                  validator:
                                      Validator().required().accepted().make(),
                                  value: formModel.ppAccepted,
                                  onChanged: (value) {
                                    setState(() {
                                      formModel.ppAccepted =
                                          !formModel.ppAccepted;
                                    });
                                  }),
                              SizedBox(
                                height: 38,
                              ),
                              MButton(
                                  loading: result.isLoading,
                                  outline: true,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  color: NeumorphicTheme.accentColor(context),
                                  hint: trans("form.sign_up").toTitleCase(),
                                  onPressed: () async {
                                    if (!formModel.validate()) {
                                      setState(() {
                                        formModel.autovalidate = true;
                                      });
                                      return;
                                    }
                                    runMutation({'data': formModel.toJson()});
                                  }),
                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  );
                }),
              ),
            )));
  }
}
