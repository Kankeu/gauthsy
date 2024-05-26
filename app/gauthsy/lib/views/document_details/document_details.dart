import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/bars/bars.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/images/images.dart';
import 'package:gauthsy/components/time/times.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/models/document.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:gauthsy/views/home/home_body.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class DocumentDetails extends StatefulWidget {
  final Document document;

  DocumentDetails({@required this.document});

  @override
  _DocumentDetailsState createState() => _DocumentDetailsState();
}

class _DocumentDetailsState extends State<DocumentDetails> {
  double get height => MediaQuery.of(context).size.height;

  double get width => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                  height: double.infinity,
                  padding: EdgeInsets.all(20),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 70),
                          if(!widget.document.valid)
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Neumorphic(
                              padding: EdgeInsets.all(10),
                              style: NeumorphicStyle(
                                depth: 0,
                                border: NeumorphicBorder(
                                  width: 1,
                                  color: widget.document.verifiedAt==null?UIData.colors.info:UIData.colors.error,
                                )
                              ),
                              child:   Center(
                                child: Text(
                                  widget.document.verifiedAt==null? "Waiting for verification" : "This document is invalid. \nReason: \"${widget.document.message}\"",
                                  style: TextStyle(fontSize: 17,color: widget.document.verifiedAt==null?UIData.colors.info:UIData.colors.error),
                                ),
                              ),
                            ),
                          )
                          else Container(
                            margin: EdgeInsets.only(bottom: 10),
                            child: Neumorphic(
                              padding: EdgeInsets.all(10),
                              style: NeumorphicStyle(
                                  depth: 0,
                                  border: NeumorphicBorder(
                                    width: 1,
                                    color: UIData.colors.success,
                                  )
                              ),
                              child:   Center(
                                child: Text( "This document is valid",
                                  style: TextStyle(fontSize: 17,color:UIData.colors.success),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Avatar(
                                path: widget.document.frontFace.fullPath,
                                tile: true,
                                height: 100,
                                width: 100,
                              ),
                              SizedBox(width: 10),
                              Container(
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(widget.document.payload.forename,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text(widget.document.payload.surname,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        widget.document.payload.countryCode +
                                            ", " +
                                            widget
                                                .document.payload.documentType,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold)),
                                    TimeAgo(date: widget.document.createdAt),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 40),
                          Text("Forename", style: TextStyle(fontSize: 15)),
                          Text(widget.document.payload.forename,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("Name", style: TextStyle(fontSize: 15)),
                          Text(widget.document.payload.surname,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("Birth date", style: TextStyle(fontSize: 15)),
                          Text(widget.document.payload.birthDate,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("Expiry date", style: TextStyle(fontSize: 15)),
                          Text(widget.document.payload.expiryDate,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("Document number",
                              style: TextStyle(fontSize: 15)),
                          Text(widget.document.payload.documentNumber,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("Sex", style: TextStyle(fontSize: 15)),
                          Text(widget.document.payload.sex,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("Nationality country code",
                              style: TextStyle(fontSize: 15)),
                          if (widget.document.payload.nationalityCountryCode !=
                              null)
                            Text(widget.document.payload.nationalityCountryCode,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("Personal number",
                              style: TextStyle(fontSize: 15)),
                          if (widget.document.payload.personalNumber != null)
                            Text(widget.document.payload.personalNumber,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          Divider(),
                          Text("Personal number 2",
                              style: TextStyle(fontSize: 15)),
                          if (widget.document.payload.personalNumber2 != null)
                            Text(widget.document.payload.personalNumber2,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Avatar(
                            path: widget.document.front.fullPath,
                            tile: true,
                            fit: BoxFit.contain,
                            width: width * .9,
                          ),
                          SizedBox(height: 10),
                          Avatar(
                            path: widget.document.back.fullPath,
                            tile: true,
                            fit: BoxFit.contain,
                            width: width * .9,
                          ),
                          SizedBox(height: 10),
                          Avatar(
                            path: widget.document.face.fullPath,
                            tile: true,
                            fit: BoxFit.contain,
                            width: width * .9,
                          ),
                          SizedBox(height: 10),
                          Container(
                              width: width * .9,
                              child: MMutation(DocumentSchema.deleteDocument,
                                  update: (_, QueryResult data) {
                                print(data.data);
                                print(data.exception);
                                if (!data.hasException) {
                                  MToast.success("Document deleted");
                                  HomeBody.refetch();
                                  Navigator.of(context).pop(true);
                                } else
                                  MToast.error("Oops an error occurred");
                              }, builder: (
                                RunMutation runMutation,
                                QueryResult result,
                              ) {
                                return MIconButton(
                                  undo: true,
                                  inline: true,
                                  loading: result.isLoading,
                                  onPressed: () {
                                    runMutation({
                                      'data': {'id': widget.document.id}
                                    });
                                  },
                                  style: NeumorphicStyle(
                                      color: UIData.colors.error),
                                  icon: Icon(Icons.delete, color: Colors.white),
                                );
                              })),
                        ],
                      ),
                    ),
                  )),
              Container(
                alignment: Alignment.topLeft,
                height: 110,
                child: TopBar(),
              ),
              if (widget.document.valid)
                Container(
                  alignment: Alignment.topRight,
                  height: 110,
                  padding: EdgeInsets.only(top: 15, right: 15),
                  child: Icon(
                    Icons.verified_user,
                    color: UIData.colors.success,
                    size: 50,
                  ),
                ),
            ],
          ),
        ));
  }
}
