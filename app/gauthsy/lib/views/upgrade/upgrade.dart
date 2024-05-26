import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/cards/m_title.dart';
import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

class Upgrade extends StatelessWidget {
  final String version;
  final String message;
  final bool mustUpgrade;
  final String publishedAt;

  Upgrade(
      {@required this.version,
      @required this.message,
      @required this.mustUpgrade,
      @required this.publishedAt});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
          child: Stack(children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, size: 100, color: Colors.lightBlue),
              SizedBox(height: 30),
              MTitle(
                overflow: TextOverflow.clip,
                padding: EdgeInsets.zero,
                text:
                    "New version $version available (${timeago.format(DateTime.parse(publishedAt))})",
                hint: message,
              ),
              SizedBox(height: 30),
              TextButton(
                style: ElevatedButton.styleFrom(
                    primary: UIData.colors.success,
                    padding: EdgeInsets.only(left: 10, bottom: 0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Download new app",
                        style: TextStyle(color: Colors.white)),
                    Icon(Icons.get_app, color: Colors.white)
                  ],
                ),
                onPressed: () {
                  launch(Config.downloadApp);
                },
              ),
            ],
          ),
        ),
        if (!mustUpgrade)
          Container(
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(20),
            child: MButton(
                padding: EdgeInsets.all(15),
                onPressed: () {
                  Navigator.pop(context);
                },
                hint: "Skip"),
          )
      ])),
    );
  }
}
