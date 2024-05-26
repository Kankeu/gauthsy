import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/views/edit_profile/edit_addresses_card.dart';
import 'package:gauthsy/views/edit_profile/edit_basic_profile_card.dart';
import 'package:gauthsy/views/edit_profile/edit_password_card.dart';

class EditProfile extends StatefulWidget {
  final Auth user;
  final int fieldId;

  EditProfile({@required this.user, this.fieldId});

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  double get height => MediaQuery.of(context).size.height;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Stack(children: <Widget>[
          Container(
              height: double.infinity,
              child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: MMutation(UserSchema.me,
                      builder: (RunMutation runMutation, QueryResult result) {
                    return Column(children: [
                      SizedBox(height: 90),
                      EditBasicProfileCard(user: widget.user, fieldId: widget.fieldId),
                      EditAddressesCard(user: widget.user, fieldId: widget.fieldId),
                      EditPasswordCard(user: widget.user,fieldId: widget.fieldId)
                    ]);
                  }))),
          Container(alignment: Alignment.topLeft, height: 110, child: TopBar())
        ])));
  }
}
