part of helpers;

class UrlParser {
  static String getPpLink() {
    return Config.appUrl + "/privacy_policy";
  }

  static String md(String value) {
    return getFullUrl(value, 200, 200);
  }

  static String getFullUrl(String value, int width, int height) {
    List words = value.split('.');
    String extension = words[words.length - 1];
    words[words.length - 1] = "${width.toString()}x${height.toString()}";
    words.add(extension);
    return Config.appUrl + words.join('.');
  }

  static String getNotificationsLink() {
    return Config.appUrl + "/api/documents";
  }

  static bool can(String url) {
    return AuthManager.logged ||
        url.contains("reset") ||
        url.contains("verified");
  }

  static void resolve(String url) {
    if (ctx == null) {
      em.attach("router.attached", (_) {
        if (can(url))
          _resolver(url);
        else {
          em.attach("authenticated", (_) => _resolver(url));
          em.attach("unauthenticated",
              (_) => AuthManager.navigate(() => _resolver(url)));
        }
      });
    } else {
      if (can(url))
        _resolver(url);
      else
        AuthManager.navigate(() => _resolver(url));
    }
  }

  static void _resolver(String url) {
    if (url.contains("notifications")) {
      router.navigator.push(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: Notifications(),
          duration: Duration(milliseconds: 300)));
    } else if (url.contains("verified")) {
      final parts = url.split("/");
      router.navigator.push(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: EmailVerification(
              id: parts[parts.length - 2], token: parts[parts.length - 1]),
          duration: Duration(milliseconds: 300)));
    } else if (url.contains("reset")) {
      router.navigator.push(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: ResetPassword(token: url.split("/").last),
          duration: Duration(milliseconds: 300)));
    } else if (url.contains("documents")) {
      router.navigator.push(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: Home(),
          duration: Duration(milliseconds: 300)));
    }
  }

  static EventManager get em => Kernel.Container().get("em");

  static KR.Router get router => Kernel.Container().get<KR.Router>("router");

  static BuildContext get ctx => router?.navigatorKey?.currentContext;
}
