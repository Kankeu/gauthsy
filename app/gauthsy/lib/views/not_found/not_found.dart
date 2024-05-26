import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/cards/m_title.dart';
import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/ui_data/ui_data.dart';

class NotFound extends StatefulWidget {
  @override
  _NotFoundState createState() => _NotFoundState();
}

class _NotFoundState extends State<NotFound> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
            child: Stack(children: <Widget>[
          new SvgPicture.asset(UIData.images.notFound,
              fit: BoxFit.fill, semanticsLabel: 'Acme Logo'),
          Container(
              alignment: Alignment.center,
              child: Container(
                  height: 200,
                  width: 350,
                  child: Neumorphic(
                    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    style: NeumorphicStyle(
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(12)),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.sentiment_very_dissatisfied,
                          size: 50,
                          color: UIData.colors.error,
                        ),
                        MTitle(
                          text: "Resource not found",
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          overflow: TextOverflow.clip,
                          hint:
                              "May be this resource has been removed by the owner",
                        ),
                      ],
                    ),
                  ))),
          Container(
            alignment: Alignment.topLeft,
            height: 110,
            child: TopBar(),
          )
        ])));
  }
}
