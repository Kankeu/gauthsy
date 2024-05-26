part of graphql;

class MQuery extends StatefulWidget {
  final DocumentNode document;
  final Map<String, dynamic> Function() variablesFunc;
  final Map<String, dynamic> variables;
  final int pollInterval;
  final FetchPolicy fetchPolicy;
  final String keysForMerge;
  final MQueryBuilder builder;
  final bool withNotFound;
  final bool forceNetworkError;
  final ScrollController scrollController;

  MQuery(this.document,
      {this.variablesFunc,
      this.variables,
      this.pollInterval,
      this.fetchPolicy,
      this.keysForMerge,
      this.builder,
      this.forceNetworkError = false,
      this.withNotFound = false,
      this.scrollController});

  @override
  _MQueryState createState() => _MQueryState();
}

typedef MQueryBuilder = Widget Function(
  QueryResult result, {
  Future Function() refetch,
  Future<QueryResult> Function() fetchMore,
});

class _MQueryState extends State<MQuery> {
  int page = 1;
  Future<QueryResult> Function() fetchMore;
  bool alreadyLoadNotFound = false;
  bool alreadyLoadNetworkError = false;

  double get height => MediaQuery.of(context).size.height * .4;

  @override
  Widget build(BuildContext context) {
    return Query(
        options: QueryOptions(
          document: widget.document,
          fetchPolicy: widget.fetchPolicy,
          variables: widget.variables ??
              (widget.variablesFunc != null ? widget.variablesFunc() : {}),
          pollInterval: widget.pollInterval == null
              ? null
              : Duration(seconds: widget.pollInterval),
        ),
        builder: (QueryResult result, {Refetch refetch, FetchMore fetchMore}) {
          var tmp = this.checkResult(result);
          if (tmp is Widget) return tmp;
          this.checkIfEnd(result.data);
          result.data = (result.data as Map).jsonWithOutDataAttr();
          this.fetchMore = () async {
            if (page < 0) return null;
             var res = await fetchMore(FetchMoreOptions(
                variables: {"page": ++page},
                updateQuery: (lastData, newData) {
                  var tmp1 = lastData;
                  var tmp2 = newData;
                  tmp2 = (tmp2 as Map).jsonWithOutDataAttr();
                  for (var key in widget.keysForMerge.split(".")) {
                    tmp1 = tmp1[key];
                    tmp2 = tmp2[key];
                    newData = newData[key];
                  }
                  if (!newData["paginatorInfo"]["hasMorePages"]) page = -1;
                  tmp1..addAll(tmp2);
                  return lastData;
                }));
             this.checkResult(res);
            return res;
          };
          return widget.builder(result,
              refetch: () async {
                result.data = null;
                this.checkResult(await fetchMore(FetchMoreOptions(
                    variables: widget.variables ??
                        (widget.variablesFunc != null
                            ? widget.variablesFunc()
                            : {}),
                    updateQuery: (lastData, newData) {
                      return newData;
                    })));
              },
              fetchMore: () async => await this.fetchMore());
        });
  }

  void checkIfEnd(newData) {
    for (var key in widget.keysForMerge.split(".")) {
      if (newData == null || !newData.containsKey(key)) return;
      newData = newData[key];
    }

    if (newData is Map &&
        newData.containsKey("paginatorInfo") &&
        !newData["paginatorInfo"]["hasMorePages"]) page = -1;
  }

  @override
  void initState() {
    if (widget.scrollController != null)
      widget.scrollController.addListener(() {
        double maxScroll = widget.scrollController.position.maxScrollExtent;
        double currentScroll = widget.scrollController.position.pixels;
        if (maxScroll - currentScroll <= 100) {
          if (this.fetchMore != null) this.fetchMore();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    try {
      widget.scrollController?.dispose();
    } catch (_) {}
    super.dispose();
  }

  Widget checkResult(QueryResult result) {
    if (result.hasException) {
      print(result.exception);
      print(result.exception.graphqlErrors[0].extensions);
      if (result.exception.graphqlErrors.isEmpty || widget.forceNetworkError) {
        if (!alreadyLoadNetworkError) {
          alreadyLoadNetworkError = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context)
                .pushReplacement(PageTransition(
                    type: PageTransitionType.rightToLeftWithFade,
                    child: NetworkError(),
                    duration: Duration(milliseconds: 300)))
                .whenComplete(() => Navigator.pop(context));
          });
        }
      }
      if (result.exception.graphqlErrors.isNotEmpty) {
        final extensions = result.exception.graphqlErrors[0].extensions;
        final bool hasErrors =
            extensions.containsKey('errors') && extensions['errors'].isNotEmpty;
        final errors = !hasErrors
            ? []
            : (extensions['errors'] is List
                ? (extensions['errors'] as List)
                : (extensions['errors'] as Map).values);
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          MFlushBar.flushBarError(
              title: result.exception.graphqlErrors[0].message,
              message: !hasErrors
                  ? " "
                  : errors.fold(
                      "",
                      (previousValue, element) =>
                          previousValue + "\n" + element is List
                              ? element.reduce((acc, x) => acc + "\n" + x)
                              : element),
              duration: Duration(seconds: 10));
          AuthManager.logout();
        });
      }
      if (alreadyLoadNetworkError) return Container();
    }
    if (widget.forceNetworkError &&
        result.data != null &&
        Collection(result.data).get(widget.keysForMerge) == null)
      return Container();

    if (widget.withNotFound &&
        !result.isLoading &&
        Collection(result.data).get(widget.keysForMerge) == null) {
      if (result.source != QueryResultSource.network)
        return Center(
          child: Container(
              margin: EdgeInsets.only(top: height), child: DoubleBounce()),
        );
      if (!alreadyLoadNotFound) {
        alreadyLoadNotFound = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context)
              .pushReplacement(PageTransition(
                  type: PageTransitionType.rightToLeftWithFade,
                  child: NotFound(),
                  duration: Duration(milliseconds: 300)))
              .whenComplete(() => Navigator.pop(context));
        });
      }
      return Container();
    }
    return null;
  }
}
