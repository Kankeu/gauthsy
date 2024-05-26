library helpers;
import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/auth_manager/auth_manager.dart';
import 'package:gauthsy/views/email_verification/email_verification.dart';
import 'package:gauthsy/views/home/home.dart';
import 'package:gauthsy/views/notifications/notifications.dart';
import 'package:gauthsy/views/reset_password/reset_password.dart';
import 'package:page_transition/page_transition.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gauthsy/kernel/container/container.dart' as Kernel;
import 'package:gauthsy/kernel/router/router.dart'as KR;
import 'package:gauthsy/kernel/event_manager/event_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

part 'permissions.dart';
part 'url_parser.dart';



class Helpers {
  static Future<E> attemptAsync<E>(Function f, {int tries = 3}) async {
    for (int i = 1; i <= tries; i++)
      try {
        return await f();
      } catch (e) {
        print(e);
      }
    return null;
  }
}
extension StringExtension on String {
  String pluralIf(int count) {
    if (Config.lang != "en") return this;
    return count > 0 ? plural() : this;
  }

  String plural() {
    if (Config.lang != "en") return this;
    String tmp = this;
    if(tmp=="day") return "days";
    if(tmp=="DAY") return "DAYS";
    if (tmp.endsWith("y"))
      tmp = tmp.substring(0, tmp.length - 1) + "ies";
    else if (tmp.endsWith("Y"))
      tmp = tmp.substring(0, tmp.length - 1) + "IES";
    else
      tmp +=
      tmp[tmp.length - 1].toLowerCase() == tmp[tmp.length - 1] ? "s" : "S";

    return tmp;
  }

  String toCapitalize() {
    if (this.isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + this.substring(1);
  }

  String toTitleCase() {
    if (this.length <= 1) return this.toUpperCase();
    var words = this.split(' ');
    var capitalized = words.map((word) {
      var first = word.substring(0, 1).toUpperCase();
      var rest = word.substring(1);
      return '$first$rest';
    });
    return capitalized.join(' ');
  }
}
extension DateTimeExtension on DateTime {
  String toDateString() {
    return DateFormat("yyyy-MM-dd").format(this.toUtc());
  }

  String toRfc3339String() {
    final Duration timezone = this.timeZoneOffset;

    return DateFormat("yyyy-MM-dd\THH:mm:ss").format(this) +
        (timezone.inHours >= 0 ? "+" : "-") +
        NumberFormat("00").format(timezone.inHours) +
        ":" +
        NumberFormat("00").format(
            timezone.inSeconds - Duration(hours: timezone.inHours).inSeconds);
  }
}

extension JsonFormatter on Map {
  Map<String, dynamic> jsonWithOutDataAttr() {
    var visited = Map<String, bool>();
    return _jsonWithOutDataAttr(this, visited);
  }

  dynamic _jsonWithOutDataAttr(data, visited) {
    if (data is Map)
      return Map<String, dynamic>.from(
          __jsonWithOutDataAttr(data, Map.from(visited)));
    else if (data is List)
      return data.where((v) {
        if (v is Map && v.containsKey("id")) {
          if (visited[v["id"]] == true) return false;
        }
        return true;
      }).map((e) {
        var tmp = Map.from(visited);
        if (e is Map && e.containsKey("id")) tmp[e["id"]] = true;
        return _jsonWithOutDataAttr(e, tmp);
      }).toList();

    return data;
  }

  Map<String, dynamic> __jsonWithOutDataAttr(
      Map json, Map<String, bool> visited) {
    var data = Map<String, dynamic>();
    if (json.containsKey("id")) visited[json["id"]] = true;

    json.forEach((k, v) {
      bool lock = false;
      if (v is Map && v.containsKey("id")) {
        if (visited[v["id"]] == true) lock = true;
      }

      if (!lock) {
        if (v is Map && v.containsKey("data")) {
          if (v.containsKey("paginatorInfo"))
            data.addAll({k+"PaginatorInfo": v["paginatorInfo"]});
          data[k] = _jsonWithOutDataAttr(v['data'], Map.from(visited));
        } else
          data[k] = _jsonWithOutDataAttr(v, Map.from(visited));
      }
    });
    return data;
  }
}

extension ColorExtension on Color {
  Color complement() {
    return this == null || this.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
  }
}