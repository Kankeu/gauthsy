part of documents;

class DocumentCard extends StatefulWidget {
  final Document document;

  DocumentCard({@required this.document});

  @override
  _DocumentCardState createState() => _DocumentCardState();
}

class _DocumentCardState extends State<DocumentCard> {
  double get height => MediaQuery.of(context).size.height;

  double get width => MediaQuery.of(context).size.width;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 200,
        margin: EdgeInsets.only(bottom: 10),
        child: NeumorphicButton(
          onPressed: () {
             Navigator.of(context).push(PageTransition(
                type: PageTransitionType.rightToLeftWithFade,
                child: DocumentDetails(document: widget.document),
                duration: Duration(milliseconds: 300)));
          },
          margin: EdgeInsets.symmetric(horizontal: 10),
          padding: EdgeInsets.only(left: 5,right: 5,top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        widget.document.issuedBy.toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      child: Avatar(
                        path: widget.document.frontFace.fullPath,
                        tile: true,
                        height: 100,
                        width: 100,
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                flex: 5,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Text(
                              widget.document.type == "ID"
                                  ? "Identity card"
                                  : "Residence permit",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                          Spacer(),
                          Text(widget.document.payload.documentNumber,
                              style: TextStyle(
                                  fontSize: 17, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text("Surname"),
                      Text(widget.document.payload.surname,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text("Forename"),
                      Text(widget.document.payload.forename,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Text("Birth date"),
                      Text(widget.document.payload.birthDate,
                          style: TextStyle(
                              fontSize: 17, fontWeight: FontWeight.bold)),
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextButton(
                            style: ElevatedButton.styleFrom(
                                primary: UIData.colors.primary,
                                padding: EdgeInsets.only(left: 10,bottom: 0)),
                            child: Row(
                              children: [
                                Text("See more",
                                    style: TextStyle(color: Colors.white)),
                                Icon(Icons.navigate_next, color: Colors.white)
                              ],
                            ),
                            onPressed: () {},
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
