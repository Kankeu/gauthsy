import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/cards/m_title.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class NoDocumentsCard extends StatefulWidget {
  final Refetch refetch;

  NoDocumentsCard({@required this.refetch});

  @override
  _NoDocumentsCardState createState() => _NoDocumentsCardState();
}

class _NoDocumentsCardState extends State<NoDocumentsCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 250,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 1,
        ),
        child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.sentiment_very_dissatisfied,
                  size: 50,
                  color: UIData.colors.error,
                ),
                MTitle(
                  text: "No documents found",
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  overflow: TextOverflow.clip,
                  hint: "When you scan a document you can see it here",
                ),
                SizedBox(height: 25),
                MButtonText(
                    inline: false,
                    onPressed: widget.refetch,
                    hint: "Retry",
                    textStyle:
                    TextStyle(decoration: TextDecoration.none, fontSize: 17)),
              ],
            )),
      ),
    );
  }
}
