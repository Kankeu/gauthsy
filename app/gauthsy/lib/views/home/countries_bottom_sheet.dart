import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/views/scanner/scanner_boarding.dart';
import 'package:page_transition/page_transition.dart';

class CountriesBottomSheet extends StatefulWidget {
  final String documentType;

  CountriesBottomSheet({@required this.documentType});

  @override
  _CountriesBottomSheetState createState() => _CountriesBottomSheetState();
}

class _CountriesBottomSheetState extends State<CountriesBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeumorphicTheme.baseColor(context),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Container(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Countries",
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.close),
                    )
                  ],
                )),
            Divider(),
            if (widget.documentType == "ID")
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: ScannerBoarding(documentType: widget.documentType, documentIssuedBy: "CMR")));
                },
                title: Text("Cameroon"),
                trailing: Icon(Icons.navigate_next),
              ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: ScannerBoarding(documentType: widget.documentType,documentIssuedBy: "D")));
              },
              title: Text("Germany"),
              trailing: Icon(Icons.navigate_next),
            ),
            if (widget.documentType == "ID")
              ListTile(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.of(context).push(PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: ScannerBoarding(documentType: widget.documentType,documentIssuedBy: "RWA",)));
                },
                title: Text("Rwanda"),
                trailing: Icon(Icons.navigate_next),
              ),
          ],
        ),
      )),
    );
  }
}
