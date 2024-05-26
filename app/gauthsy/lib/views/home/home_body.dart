import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:gauthsy/components/buttons/buttons.dart';
import 'package:gauthsy/components/documents/documents.dart';
import 'package:gauthsy/components/loaders/loaders.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/models/document.dart';
import 'package:gauthsy/ui_data/ui_data.dart';
import 'package:gauthsy/views/home/no_documents_card.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class HomeBody extends StatefulWidget {
  final Function(Future Function()) onReady;
  static Future Function() refetch=()async{};

  HomeBody({@required this.onReady});

  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  List<Document> documents = [];
  bool loading = false;

  double get height => MediaQuery.of(context).size.height;
  bool shouldRefresh=false;

  @override
  Widget build(BuildContext context) {
    return MQuery(DocumentSchema.documents,
        keysForMerge: "me.documents",
        fetchPolicy: shouldRefresh
            ? FetchPolicy.networkOnly
            : FetchPolicy.cacheAndNetwork,
        builder: (QueryResult result,
            {Future Function() refetch,
            Future<QueryResult> Function() fetchMore}) {
      widget.onReady(refetch);
      HomeBody.refetch = ()async{shouldRefresh=true;var d = await refetch();shouldRefresh=false;return d; };

      if (result.isLoading && result.data == null && documents.isEmpty)
        return Center(
            child: Container(
                margin: EdgeInsets.only(top: height * .25),
                child: NeumorphicProgressIndeterminate(
                  style: ProgressStyle(depth: 0),
                )));
      documents = result.data == null
          ? documents
          : result.data["me"]["documents"]
              .map<Document>((json) => Document.fromJson(json))
              .toList();
      if (documents.isEmpty)
        return Container(
            padding: EdgeInsets.only(bottom: 10,left: 10,right: 10),
            child: NoDocumentsCard(refetch: refetch))
        ;
      return Column(
        children: [
          for (var document in documents) DocumentCard(document: document),
          if (result.data != null &&
              result.data["me"]["documentsPaginatorInfo"]["hasMorePages"])
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, right: 10, left: 10),
              child: MButtonText(
                  inline: false,
                  loading: loading,
                  onPressed: () async {
                    setState(() {
                      loading = true;
                    });
                    print(await fetchMore());
                    setState(() {
                      loading = false;
                    });
                  },
                  hint: "Load more",
                  textStyle:
                      TextStyle(decoration: TextDecoration.none, fontSize: 17)),
            ),
          if (documents.isNotEmpty)
            Container(
                margin: EdgeInsets.only(top: 15, right: 10, left: 10),
                child: Divider()),
        ],
      );
    });
  }
}
