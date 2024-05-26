import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/cards/m_title.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/fields/fields.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/kernel/validations/validator.dart';
import 'package:gauthsy/localization/app_localization.dart';

class EditAddressesCard extends StatefulWidget {
  final Auth user;
  final int fieldId;

  EditAddressesCard({@required this.user, this.fieldId});

  @override
  _EditAddressesCardState createState() => _EditAddressesCardState();
}

class _EditAddressesCardState extends State<EditAddressesCard> {
  Auth get user => widget.user;
  final formModel = new FormModel();

  @override
  Widget build(BuildContext context) {
    return MMutation(UserSchema.updateAddresses,
        onSuccess: (_, QueryResult result) {
      if (result.data['updateUser'] != null) {
        if(formModel.email!=user.email){
          MFlushBar.flushBarSuccess(
              title: "Email sent",
              message: "We have sent you a verification email to check that the new email is correct.\nPlease consult your mailbox to click on the confirmation link",
              duration: Duration(seconds: 15));
        }
        MToast.success("Addresses saved");
        AuthManager.updateUser(result.data['updateUser']);
      }
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
                        MTitle(text: "Addresses"),
                        SizedBox(height: 8),
                        MTextField(
                          autofocus:widget.fieldId==2,
                          label: trans("form.email").toCapitalize(),
                          hint: trans("form.email").toCapitalize(),
                          value: formModel.email,
                          validator: Validator().required().email().make(),
                          onChanged: (email) {
                            setState(() {
                              formModel.email = email;
                            });
                          },
                        ),
                        SizedBox(height: 8),
                        MButton(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          hint: "Save Addresses",
                          loading: result.isLoading,
                          onPressed: () {
                            if (!formModel.validate())
                              return formModel.autovalidate = true;
                            runMutation({"data":formModel.toJson()});
                          },
                        ),
                        SizedBox(height: 20),
                      ]))));
    });
  }

  @override
  void initState() {
    formModel.email = user.email;
    super.initState();
  }
}

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
    var data = {
      "email": email,
    };
    return data;
  }
}
