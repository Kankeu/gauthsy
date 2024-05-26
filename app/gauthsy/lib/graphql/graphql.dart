library graphql;

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:page_transition/page_transition.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:graphql/src/core/observable_query.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/components/loaders/loaders.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/kernel/container/container.dart' as Kernel;
import 'package:gauthsy/config/config.dart';
import 'package:graphql_flutter/src/widgets/query.dart' as GF;
import 'package:gql/ast.dart';
import 'package:gauthsy/localization/app_localization.dart';
import 'package:gauthsy/views/network_error/network_error.dart';
import 'package:gauthsy/views/not_found/not_found.dart';

part 'm_mutation.dart';

part 'm_query.dart';

part 'schema/user_schema.dart';

part 'schema/notification_schema.dart';

part 'schema/document_schema.dart';

class GraphQl {
  GraphQLClient get _client => _clientNotifier.value;

  ValueNotifier<GraphQLClient> _clientNotifier;

  ValueNotifier<GraphQLClient> get clientNotifier => _clientNotifier;

  GraphQl() {
    _clientNotifier = ValueNotifier<GraphQLClient>(_getClient());
  }

  static GraphQLClient _getClient([token = ""]) {
    final HttpLink httpLink = HttpLink(
      Config.apiUrl,
    );
    final AuthLink authLink = AuthLink(getToken: () => token);

    final Link link = authLink.concat(httpLink);
    return GraphQLClient(
      cache: GraphQLCache(
        dataIdFromObject: (Object object) {
          if (object is Map<String, Object>) {
            if (object.containsKey('id')) return object['id'];
          }
          return null;
        },
      ),
      link: link,
    );
  }

  static void init() async {
    Kernel.Container().set("graphql", () => new GraphQl());
  }

  static void reset() {
    Kernel.Container().get("graphql").clientNotifier.value.cache.store.reset();
    Kernel.Container().get("graphql").clientNotifier.value = _getClient();
  }

  final Map<String,String> headers = new Map<String,String>();

  void addAccessToken(String token, String tokenType) {
    headers["Authorization"] = "$tokenType $token";
    _clientNotifier.value = _getClient(headers["Authorization"]);
  }

  Future<QueryResult> mutate(DocumentNode documentNode,
      {FetchPolicy fetchPolicy,
      OnMutationUpdate update,
      Map<String, dynamic> variables}) async {
    final tmp = await _client.mutate(MutationOptions(
        variables: variables,
        update: update,
        fetchPolicy: fetchPolicy,
        document: documentNode));
    if (tmp.hasException) print(tmp.exception);
    return tmp;
  }

  String getMutationDocument(String mutation,
      {Map<String, dynamic> params,
      List returnFields,
      Map<String, String> variablesTypes}) {
    return makeDocument(
        "mutation${makeVariablesTypes(variablesTypes)}", mutation,
        params: params, returnFields: returnFields);
  }

  String getQueryDocument(String query,
      {Map<String, dynamic> params,
      List returnFields,
      Map<String, String> variablesTypes}) {
    return makeDocument("query", query,
        params: params, returnFields: returnFields);
  }

  String getQueriesDocument(
      {Map<String, String> variablesTypes, List queries}) {
    String queriesText = '';
    if (queries != null) queriesText = _parseReturnFields(queries);
    return "query${makeVariablesTypes(variablesTypes)}$queriesText";
  }

  ObservableQuery watchQuery(String document,
      {Map<String, dynamic> variables,
      FetchPolicy fetchPolicy = FetchPolicy.cacheFirst}) {
    return _client.watchQuery(WatchQueryOptions(
        variables: variables,
        fetchPolicy: fetchPolicy,
        fetchResults: true,
        document: gql(document)));
  }

  Future<QueryResult> query(DocumentNode documentNode,
      {Map<String, dynamic> variables, FetchPolicy fetchPolicy}) {
    return _client.query(QueryOptions(
        document: documentNode,
        variables: variables,
        fetchPolicy: fetchPolicy));
  }

  String makeVariablesTypes(Map<String, String> variablesTypes) {
    if (variablesTypes == null) return "";
    String text = '(';
    variablesTypes.forEach((k, v) {
      text += "$k:$v,";
    });
    text += ')';
    return text;
  }

  String makeDocument(String type, String name,
      {Map<String, dynamic> params, List returnFields}) {
    String paramsText = '';
    if (params != null) {
      paramsText = '(';
      params.forEach((k, v) {
        paramsText += "$k:${_parseParams(v, k)},";
      });
      paramsText += ')';
    }
    String returnFieldsText = '';
    if (returnFields != null)
      returnFieldsText = _parseReturnFields(returnFields);
    return "$type{$name$paramsText$returnFieldsText}";
  }

  dynamic _parseParams(params, k) {
    if (params is String)
      return k == "images" ? params : '"${params.replaceAll('"', '\\"')}"';
    else if (params is Map) {
      String res = '{';
      params.forEach((k, v) {
        res += "$k:${_parseParams(v, k)},";
      });
      res += '}';
      return res;
    } else if (params is List) {
      String res = '[';
      params.forEach((v) {
        res += "${_parseParams(v, k)},";
      });
      res += ']';
      return res;
    }
    return params;
  }

  dynamic _parseReturnFields(returnFields, [bool deep = false]) {
    if (returnFields is List) {
      String res = '{';
      if (deep) {
        res = "${returnFields[0]}{";
        returnFields = List.from(returnFields)..removeAt(0);
      }
      returnFields.forEach((v) {
        res += "${_parseReturnFields(v, true)},";
      });
      res += '}';
      return res;
    }
    return returnFields;
  }
}
