import 'package:flutter/material.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/fields/fields.dart';
import 'package:gauthsy/components/images/images.dart';
import 'package:gauthsy/kernel/validations/validator.dart';
import 'package:gauthsy/localization/app_localization.dart';
import 'form_model.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:page_transition/page_transition.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/views/starting/starting.dart';

class ResetPassword extends StatefulWidget {
  final String token;
  ResetPassword({this.token});
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  bool pressed = false;

  final FormModel formModel = new FormModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Container(
            height: double.infinity,
            child: NeumorphicBackground(
                child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
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
                        child: MMutation(UserSchema.resetPassword,
                            onSuccess: (_, QueryResult result) {
                          if (result.data['resetPassword']) {
                            MToast.success("Password updated");
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: Starting(),
                                duration: Duration(milliseconds: 300)));
                            MFlushBar.flushBarSuccess(
                                duration: Duration(seconds: 10),
                                title: "Password changed",
                                message: "Your password has been successfully changed"
                            );
                          }
                        }, builder:
                                (RunMutation runMutation, QueryResult result) {
                          return Form(
                            key: formModel.formKey,
                            autovalidateMode: formModel.autovalidate ? AutovalidateMode.always:AutovalidateMode.disabled,
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
                                      pressed ? Icons.send : Icons.email,
                                      size: 100,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                MTextField(
                                  validator: Validator()
                                      .required()
                                      .minLength(6)
                                      .make(),
                                  label: trans("form.new_pwd").toCapitalize(),
                                  hint: trans("form.new_pwd").toCapitalize(),
                                  maxLength: 30,
                                  isPassword: true,
                                  value: formModel.password,
                                  onChanged: (password) {
                                    setState(() {
                                      formModel.password = password;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                MTextField(
                                  clearable: true,
                                  label: trans("form.confirmation_link")
                                      .toTitleCase()
                                      .toCapitalize(),
                                  hint: trans("form.confirmation_link")
                                      .toTitleCase()
                                      .toCapitalize(),
                                  validator: Validator().required().make(),
                                  value: formModel.token,
                                  onChanged: (value) {
                                    setState(() {
                                      formModel.token = value;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                MButton(
                                    loading: result.isLoading,
                                    outline: true,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    color: NeumorphicTheme.accentColor(context),
                                    hint: trans("form.reset_password")
                                        .toTitleCase(),
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
                                  height: 20,
                                ),
                              ],
                            ),
                          );
                        }))
                  ],
                ),
              ),
            ))));
  }


  @override
  void initState() {
    if (widget.token != null) {
      formModel.token = widget.token;
    }
    super.initState();
  }
}
