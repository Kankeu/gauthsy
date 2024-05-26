part of graphql;

class MMutation extends Mutation {
  MMutation(DocumentNode document,
      {Map<String, dynamic> variables,
      OnError onError,
      List<String> ignoreErrors = const [],
      OnMutationCompleted onCompleted,
      OnMutationUpdate update,
      Map<String,String> errorMessages,
      OnMutationUpdate onSuccess,
      MutationBuilder builder})
      : super(
            options: MutationOptions(
                document: document,
                variables: variables,
                onCompleted: onCompleted,
                onError: onError,
                fetchPolicy: FetchPolicy.networkOnly,
                errorPolicy: ErrorPolicy.all,
                update: (GraphQLDataProxy cache, QueryResult result) {
                  if (result.hasException) {
                    print(result.exception);
                    print(result.exception.graphqlErrors);
                    final extensions =
                        result.exception.graphqlErrors[0].extensions;
                    if (!ignoreErrors.contains(extensions["category"])) {
                      final bool hasErrors = extensions.containsKey('errors') &&
                          extensions['errors'].isNotEmpty;
                      final errors = !hasErrors
                          ? []
                          : (extensions['errors'] is List
                              ? (extensions['errors'] as List)
                              : (extensions['errors'] as Map).keys.map((e) => (errorMessages??{})[e]??(extensions['errors'] as Map)[e]));

                      MFlushBar.flushBarError(
                          title: result.exception.graphqlErrors[0].message,
                          message: !hasErrors
                              ? " "
                              : errors.fold(
                                  "",
                                  (previousValue, element) =>
                                      previousValue +
                                      "\n" +
                                      (element is List
                                          ? element.reduce(
                                              (acc, x) => acc + "\n" + x)
                                          : element)),
                          duration: Duration(seconds: 10));
                    }
                  }

                  if (update != null) update(cache, result);
                  if (onSuccess != null && !result.hasException)
                    {
                      result.data = (result.data as Map).jsonWithOutDataAttr();
                      onSuccess(cache, result);
                    }
                }),
            builder: (
              RunMutation runMutation,
              QueryResult result,
            ) {
              return builder(runMutation, result);
            });
}
