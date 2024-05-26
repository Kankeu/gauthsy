import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:page_transition/page_transition.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/fields/fields.dart';
import 'package:gauthsy/components/images/images.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/kernel/validations/validator.dart';
import 'package:gauthsy/localization/app_localization.dart';
import 'package:gauthsy/views/home/home.dart';
import 'package:gauthsy/views/starting/form_model.dart';
import 'package:gauthsy/views/forgot_password/forgot_password.dart';
import 'package:gauthsy/views/sign_up/sign_up.dart';
import 'package:gauthsy/helpers/helpers.dart';

class Starting extends StatefulWidget {
  @override
  _StartingState createState() => _StartingState();
}

class _StartingState extends State<Starting> {
  String email = "";
  String password = "";
  bool pressed = false;
  final formModel = new FormModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                  height: double.infinity,
                  child: NeumorphicBackground(
                      child: SafeArea(
                    child: SingleChildScrollView(
                        child: MMutation(UserSchema.login,
                            onSuccess: (_, QueryResult result) {
                      if (result.data['login'] != null) {
                        AuthManager.login(result.data['login']);
                      }
                    }, builder: (RunMutation runMutation, QueryResult result) {
                      return Form(
                        key: formModel.formKey,
                        autovalidateMode: formModel.autovalidate ? AutovalidateMode.always:AutovalidateMode.disabled,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 92,
                            ),
                            Neumorphic(
                              margin:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(12)),
                              ),
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
                                    validator: Validator().required().email().make(),
                                    label: trans("form.email").toCapitalize(),
                                    hint: trans("form.email").toCapitalize(),
                                    value: formModel.email,
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
                                    validator: Validator().minLength(6).required().make(),
                                    label: trans("form.pwd").toCapitalize(),
                                    hint: trans("form.pwd").toCapitalize(),
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
                                    height: 30,
                                  ),
                                  MButton(
                                      loading: result.isLoading,
                                      outline: true,
                                      margin: EdgeInsets.symmetric(horizontal: 10),
                                      color: NeumorphicTheme.accentColor(context),
                                      hint: trans("form.sign_in").toTitleCase(),
                                      onPressed: () async {
                                        if (!formModel.validate()) {
                                          setState(() {
                                            formModel.autovalidate = true;
                                          });
                                          return;
                                        }
                                        runMutation({'data': formModel.toJson()});
                                      }),
                                  SizedBox(height: 40),
                                  MButtonText(
                                    hint: trans("form.forgot_pwd").toTitleCase(),
                                    onPressed: () {
                                      Navigator.of(context).push(PageTransition(
                                          type: PageTransitionType.rightToLeftWithFade,
                                          child: ForgotPassword(),
                                          duration: Duration(milliseconds: 300)));
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 40),
                            MButton(
                              margin: EdgeInsets.symmetric(horizontal: 40),
                              color: NeumorphicTheme.accentColor(context),
                              onPressed: () {
                                Navigator.of(context).push(PageTransition(
                                    type: PageTransitionType.rightToLeftWithFade,
                                    child: SignUp(),
                                    duration: Duration(milliseconds: 300)));
                              },
                              hint: trans("form.create_account").toTitleCase(),
                            ),
                            SizedBox(height: 40),
                          ],
                        ),
                      );
                    })),
                  ))),
            ],
          ),
        ));
  }

}
