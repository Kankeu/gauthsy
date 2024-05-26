import 'package:flutter/services.dart';
import 'package:gauthsy/components/flash_msg/flash_msg.dart';
import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkManager {


  static Future init() async {
    await _initUniLinks();
  }

  static Future<void> _initUniLinks() async {
    try {
      String deepLink = await getInitialLink();
      print(deepLink);
      if (deepLink != null) UrlParser.resolve(deepLink);
    } on PlatformException catch(e) {
      print("Deep link error");
      if (!Config.isProd)
        MFlushBar.flushBarError(
            title: "Deep link",
            message: e.message
        );
    }catch(e){
      print(e);
    }

    getLinksStream().listen((String link) {
      if (!Config.isProd)
        MFlushBar.flushBarSuccess(
            title: "Deep link",
            message: link
        );
      print(link);
      if (link != null) UrlParser.resolve(link);
    }, onError: (err) {
      print(err);
      if (!Config.isProd)
        MFlushBar.flushBarError(
          title: "Deep link",
message: err
        );
    });
  }
}