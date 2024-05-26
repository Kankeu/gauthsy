import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/fields/fields.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/images/images.dart';
import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/kernel/validations/validator.dart';
import 'package:gauthsy/localization/app_localization.dart';
import 'package:gauthsy/views/email_verification/form_model.dart';

class EmailVerification extends StatefulWidget {
  final String id;
  final String token;

  EmailVerification({@required this.id, this.token});

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  bool pressed = false;
  final formModel = new FormModel();
  MButton button;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: Container(
        height: double.infinity,
        child: SafeArea(
          child: SingleChildScrollView(
              child: MMutation(UserSchema.verifyEmail,
                  onSuccess: (_, QueryResult result) {
            if (result.data['verifyEmail']) {
              MToast.success("Email verified");
              AuthManager.verify();
            }
          }, builder: (RunMutation runMutation, QueryResult result) {
            return Column(
              children: [
                TopBar(),
                Neumorphic(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                    ),
                    child: Form(
                      key: formModel.formKey,
                      autovalidateMode: formModel.autovalidate ? AutovalidateMode.always:AutovalidateMode.disabled,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(height: 28),
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
                                pressed ? Icons.send : Icons.mail,
                                size: 60,
                                color: Colors.black.withOpacity(0.2),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            Config.appName +
                                " " +
                                trans("form.email_verification_sent_msg"),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 20),
                          MTextField(
                            clearable: true,
                            label: trans("form.confirmation_link")
                                .toTitleCase()
                                .toCapitalize(),
                            hint: trans("form.confirmation_link")
                                .toTitleCase()
                                .toCapitalize(),
                            validator: Validator().required().make(),
                            value: formModel.confirmationLink,
                            onChanged: (value) {
                              setState(() {
                                formModel.confirmationLink = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          button = MButton(
                              loading: result.isLoading,
                              outline: true,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              color: NeumorphicTheme.accentColor(context),
                              hint: trans("form.verify").toTitleCase(),
                              onPressed: () async {
                                if (!formModel.validate()) {
                                  setState(() {
                                    formModel.autovalidate = true;
                                  });
                                  return;
                                }
                                runMutation({'data': formModel.toJson()});
                              }),
                          Container(
                              padding: EdgeInsets.only(
                                  bottom: 36.0,
                                  left: 10.0,
                                  top: 50,
                                  right: 10.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    trans("form.resent_email_verification_msg")
                                        .toCapitalize(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  MMutation(UserSchema.resentEmailVerified,
                                      onSuccess: (_, QueryResult result) {
                                    if (result.data['resentEmailVerified'])
                                      MToast.success("Email resent");
                                  }, builder: (RunMutation runMutation,
                                          QueryResult result) {
                                    return MButtonText(
                                      loading: result.isLoading,
                                      hint: trans("form.resend_email")
                                          .toTitleCase(),
                                      onPressed: () {
                                        runMutation({
                                          "data": {"id": widget.id}
                                        });
                                      },
                                    );
                                  })
                                ],
                              )),
                        ],
                      ),
                    )),
              ],
            );
          })),
        ),
      ),
    );
  }

  @override
  void initState() {
    if (widget.token != null) {
      formModel.confirmationLink = widget.token;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        button.onPressed();
      });
    }
    super.initState();
  }
}
