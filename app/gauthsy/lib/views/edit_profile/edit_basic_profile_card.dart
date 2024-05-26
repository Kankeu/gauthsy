import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/cards/m_title.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/fields/fields.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/images/images.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/kernel/validations/validator.dart';
import 'package:gauthsy/localization/app_localization.dart';

class EditBasicProfileCard extends StatefulWidget {
  final Auth user;
  final int fieldId;

  EditBasicProfileCard({@required this.user, @required this.fieldId});

  @override
  _EditBasicProfileCardState createState() => _EditBasicProfileCardState();
}

class _EditBasicProfileCardState extends State<EditBasicProfileCard> {
  Auth get user => widget.user;
  final formModel = new FormModel();

  @override
  Widget build(BuildContext context) {
    return MMutation(UserSchema.updateBasicProfile,
        onSuccess: (_, QueryResult result) {
      if (result.data['updateUser'] != null) {
        MToast.success("Profile saved");
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
                        MTitle(text: "Profile"),
                        MTextField(
                          label: trans("form.forename").toCapitalize(),
                          hint: trans("form.forename").toCapitalize(),
                          maxLength: 30,
                          value: formModel.forename,
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
                          label: trans("form.surname").toCapitalize(),
                          hint: trans("form.surname").toCapitalize(),
                          maxLength: 30,
                          value: formModel.surname,
                          validator:
                              Validator().required().maxLength(30).make(),
                          onChanged: (surname) {
                            setState(() {
                              formModel.surname = surname;
                            });
                          },
                        ),
                        MButton(
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          hint: "Save profile",
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

  @override
  void initState() {
    formModel.surname = user.surname;
    formModel.forename = user.forename;
    formModel.surname = user.surname;
    super.initState();
  }
}

class FormModel {
  bool autovalidate = false;
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  String forename = "";
  String surname = "";

  bool validate() {
    if (formKey.currentState == null)
      return false;
    else
      return formKey.currentState.validate();
  }

  Map<String, dynamic> toJson() {
    var data = {
      "forename": forename,
      "surname": surname,
    };
    return data;
  }
}
