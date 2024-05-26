import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/helpers/helpers.dart';


String trans(String keys, [Map<String, dynamic> attributes]) {
  return attributes == null
      ? AppLang.sentences.get(keys)
      : attributes.keys
          .fold(
              AppLang.sentences.get(keys),
              (previousValue, element) => previousValue.replaceFirst(
                  ":" + element, attributes[element].toString()));
}

class AppLang {
  AppLang(this.locale);

  final Locale locale;

  static AppLang of(BuildContext context) {
    return Localizations.of<AppLang>(context, AppLang);
  }

  static Collection sentences;

  Future<void> load() async {
    String data = await rootBundle.loadString(
        Config.langPath.replaceFirst(":name", this.locale.languageCode));
    Map<String, dynamic> _result = json.decode(data);

    sentences = Collection(_result);
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLang> {
  @override
  bool isSupported(Locale locale) => Config.locales.contains(locale);

  @override
  Future<AppLang> load(Locale locale) async {
    AppLang localizations = new AppLang(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}

class Collection {
  Map<String, dynamic> data = new Map<String, dynamic>();

  Collection([this.data]);

  T get<T>(String keys) {
    dynamic tmp = data;
    for (String key in keys.split(".")) tmp = tmp[key];

    return tmp as T;
  }

  Collection put(String keys, String value) {
    dynamic tmp = data;
    var parts = keys.split(".");
    for (int i = 0; i < parts.length; i++) {
      String key = parts[i];
      if (tmp.containsKey(key))
        tmp = tmp[key];
      else
        tmp[key] = i == parts.length - 1 ? value : {};
    }
    return this;
  }
}
