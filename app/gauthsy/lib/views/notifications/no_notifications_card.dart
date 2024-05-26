import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/cards/m_title.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NoNotificationsCard extends StatefulWidget {
  final Refetch refetch;

  NoNotificationsCard({@required this.refetch});
  @override
  _NoNotificationsCardState createState() => _NoNotificationsCardState();
}

class _NoNotificationsCardState extends State<NoNotificationsCard> {
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: 350,
      height: 250,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 1
        ),
        child: Container(
            padding: EdgeInsets.all(10),
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.sentiment_very_dissatisfied,
                  size: 50,
                  color: UIData.colors.error,
                ),
                MTitle(
                  text: "No notifications found",
                  fontSize: 20,
                  overflow: TextOverflow.clip,
                  fontWeight: FontWeight.w800,
                  hint:
                  "When you receive notifications you can see it here",
                ),
                SizedBox(height: 25),
                MButtonText(
                    inline: false,
                    onPressed: widget.refetch,
                    hint: "Retry",
                    textStyle:
                    TextStyle(decoration: TextDecoration.none, fontSize: 17)),
              ],
            )
        ),
      ),
    );
  }
}
