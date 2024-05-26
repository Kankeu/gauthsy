library config;

import 'package:flutter/material.dart';


class Config {
  static final String version = "1.0.0";

  static final String _env = "prod";

  static bool get isDev => _env == "dev";

  static bool get isTest => _env == "test";

  static bool get isProd => _env == "prod";

  static String get appName => "GauthSy";

  static String lang = "en";

  static String get downloadApp => appUrl+"/app/gauthsy.apk";

  static final String langPath = "assets/lang/:name.json";

  static List<Locale> locales = [Locale("en", "US"), Locale("fr", "FR")];

  static final List<String> serversUrl = [
    "http://192.168.0.101",
    "http://95.88.229.112",
  ];

  static String _serverUrl = "http://192.168.0.101";

  static String get serverUrl => isTest ? "http://95.88.229.112" : _serverUrl;

  static String get domainName => "https://gauthsy.restopres.com";

  static String get appUrl => isProd ? domainName : "$serverUrl:8000";

  static set appUrl(String v) {
    _serverUrl = v;
  }

  static String get apiUrl => "$appUrl/graphql";


}
