import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/fields/fields.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/images/images.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/kernel/validations/validator.dart';
import 'package:gauthsy/localization/app_localization.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/views/reset_password/reset_password.dart';

import 'form_model.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final formModel = new FormModel();
  bool pressed = false;

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
                    SizedBox(height: 50),
                    Neumorphic(
                        margin:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.roundRect(
                              BorderRadius.circular(12)),
                        ),
                        child: MMutation(UserSchema.forgotPassword,
                            onSuccess: (_, QueryResult result) {
                          if (result.data['forgotPassword']) {
                            MToast.success("Email sent");
                            Navigator.of(context).push(PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: ResetPassword(),
                                duration: Duration(milliseconds: 300)));
                            MFlushBar.flushBarSuccess(
                                duration: Duration(seconds: 10),
                                title: "Recovery Email",
                                message: "We have sent you an account recovery email, please check your mailbox to reset your password"
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
                                      size: 120,
                                      color: Colors.black.withOpacity(0.2),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                MTextField(
                                  value: formModel.email,
                                  validator:
                                      Validator().required().email().make(),
                                  label: trans("form.email").toCapitalize(),
                                  hint: trans("form.email").toCapitalize(),
                                  onChanged: (email) {
                                    setState(() {
                                      formModel.email = email;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                MButton(
                                    loading: result.isLoading,
                                    outline: true,
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    color: NeumorphicTheme.accentColor(context),
                                    hint: trans("form.send_verification_code")
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

}
