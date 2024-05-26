library auth_manager;

import 'dart:convert';

import 'package:flutter/material.dart' as UI;
import 'package:gauthsy/connection/connection.dart';
import 'package:gauthsy/views/offline/offline.dart';
import 'package:gauthsy/views/upgrade/upgrade.dart';
import 'package:page_transition/page_transition.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/database/database.dart';
import 'package:gauthsy/graphql/graphql.dart';
import 'package:gauthsy/kernel/container/container.dart';
import 'package:gauthsy/kernel/event_manager/event_manager.dart';
import 'package:gauthsy/kernel/router/router.dart';
import 'package:gauthsy/models/token.dart';
import 'package:gauthsy/models/user.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/views/email_verification/email_verification.dart';
import 'package:gauthsy/views/home/home.dart';
import 'package:gauthsy/views/starting/starting.dart';
import 'package:version/version.dart';

part 'auth.dart';

class AuthManager {
  static Auth user;

  static bool get logged => user != null && user.verified;

  static Router get router => Container().get<Router>("router");

  static EventManager get em => Container().get<EventManager>("em");

  static GraphQl get graphql => Container().get<GraphQl>("graphql");

  static void init() {
    em.attach("unauthenticated", (_) {
      router.navigator.pushReplacement(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: Starting(),
          duration: Duration(milliseconds: 300)));
    });
    em.attach("authenticated", (_) {
      router.navigator.pushReplacement(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: Home(),
          duration: Duration(milliseconds: 300)));
    });
    em.attach("authenticate", (_) async {
      if (!(await Connection.checkConnection())) return;
      if (!(await checkAppVersion())) return;

      Auth user =
          await Auth().where('is_account', '1').where('is_active', '1').first();
      final token = await user?.token;
      print(token?.accessToken);
      // em.clearListeners("authenticated");

      if (token != null)
        _loginWithToken(token);
      else {
        em.signal("unauthenticated");
      }
      // em.clearListeners('authenticate');
    });
  }

  static Future<bool> _loginWithToken(Token token, {int tries = 3}) async {
    graphql.addAccessToken(token.accessToken, token.tokenType);
    final QueryResult result = await graphql.query(UserSchema.me,
        fetchPolicy: FetchPolicy.networkOnly);
    //result.data = (result.data as Map).jsonWithOutDataAttr();
    print(result.data);

    if (result.hasException) {
      if (tries == 1) {
        em.signal("unauthenticated");
        return false;
      }
      return await _loginWithToken(token, tries: tries - 1);
    }
    user = Auth.fromJson(result.data['me']);
    em.signal('authenticated');
    return true;
  }

  static void login(Map<String, dynamic> data) async {
    data["me"]["token"] = data;
    data = data["me"];

    var user = Auth.fromJson(data);

    if (!user.verified) {
      router.navigator.pushReplacement(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: EmailVerification(id: data['id']),
          duration: Duration(milliseconds: 300)));
    } else {
      AuthManager.user = user;
      graphql.addAccessToken(
          (await user.token).accessToken, (await user.token).tokenType);
      user.save();
      em.signal('authenticated');
      MToast.success("logged");
    }
  }

  static void signUp(Map<String, dynamic> data) {
    user = Auth.fromJson(data);
    router.navigator.pushReplacement(PageTransition(
        type: PageTransitionType.rightToLeftWithFade,
        child: EmailVerification(id: data['id']),
        duration: Duration(milliseconds: 300)));
  }

  static void verify() {
    // user.emailVerifiedAt = DateTime.now().toString();
    if (logged)
      router.navigator.pop();
    else
      router.navigator.pushReplacement(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: Starting(),
          duration: Duration(milliseconds: 300)));
    MFlushBar.flushBarSuccess(
        duration: Duration(seconds: 10),
        title: "Email verified",
        message: "Your email address has been successfully saved");
    // em.signal('authenticated');
  }

  static Function callback;

  static void navigate(UI.VoidCallback f, {bool skip = false}) {
    if (logged) return f();
    if (callback != null) em.detach("authenticated", callback);
    callback = (_) async {
      if (skip)
        router.navigator.pop();
      else
        router.navigator.pushReplacement(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: Home(),
            duration: Duration(milliseconds: 300)));
      f();
    };
    em.attach("authenticated", callback);
    router.navigator
        .push(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: Starting(),
            duration: Duration(milliseconds: 300)))
        .whenComplete(() => em.detach("authenticated", callback));
  }

  static void updateUser(Map<String, dynamic> data) {
    user = Auth.fromJson(user.toJson()..addAll(data));
  }

  static Future<bool> updateFcmToken(String fcmToken) async {
    final QueryResult result =
        await graphql.mutate(UserSchema.updateFcmToken, variables: {
      "data": {"fcm_token": fcmToken}
    });
    if (!result.hasException) print("FcmToken updated");
    return !result.hasException;
  }

  static void logout() async {
    print((await user.token).accessToken);
    final QueryResult result = await graphql.mutate(UserSchema.logout,
        fetchPolicy: FetchPolicy.networkOnly);
    if ((!result.hasException && result.data["logout"]) ||
        (result.hasException &&
            result.exception.graphqlErrors.isNotEmpty &&
            result.exception.graphqlErrors[0].extensions!=null&&
            result.exception.graphqlErrors[0].extensions["category"] ==
                "authentication")) {
      await Database.reset();
      GraphQl.reset();
      user = null;
      router.pushAndRemoveUntil(
          UI.MaterialPageRoute(builder: (_) => Starting()),
          (UI.Route<dynamic> route) => false);
      AuthManager.navigate(() {
        router.navigator.push(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: Home(),
            duration: Duration(milliseconds: 300)));
      });
      MToast.success("Logout");
    }
  }

  static Future<bool> checkAppVersion([int tries = 3]) async {
    final QueryResult result = await graphql.query(UserSchema.appVersion,
        fetchPolicy: FetchPolicy.networkOnly);
    //result.data = (result.data as Map).jsonWithOutDataAttr();
    print(result.data);

    if (result.hasException) {
      if (tries == 1) {
        MToast.error("Oops something went wrong");
        await router.navigator.pushReplacement(PageTransition(
            type: PageTransitionType.rightToLeftWithFade,
            child: Offline(),
            duration: Duration(milliseconds: 300)));
        return false;
      }
      return checkAppVersion(tries - 1);
    }
    if (Version.parse(result.data['appVersion']['version']) >
        Version.parse(Config.version)) {
      await router.navigator.push(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: Upgrade(
              version: result.data['appVersion']['version'],
              mustUpgrade: result.data['appVersion']['must_upgrade'],
              message: result.data['appVersion']['message'],
              publishedAt: result.data['appVersion']['published_at']),
          duration: Duration(milliseconds: 300)));
      return !result.data['appVersion']['must_upgrade'];
    }
    return true;
  }
}
