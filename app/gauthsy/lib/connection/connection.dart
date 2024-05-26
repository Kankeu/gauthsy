import 'package:connectivity/connectivity.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gauthsy/views/offline/offline.dart';
import 'package:gauthsy/kernel/container/container.dart' as Kernel;
import 'package:gauthsy/kernel/event_manager/event_manager.dart' as Kernel;
import 'package:gauthsy/kernel/router/router.dart' as Kernel;
import 'package:page_transition/page_transition.dart';

class Connection {
  static Kernel.EventManager get em => Kernel.Container().get("em");

  static Kernel.Router get router => Kernel.Container().get<Kernel.Router>("router");

  static Future<bool> checkConnection() async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      router.navigator.pushReplacement(PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: Offline(),
          duration: Duration(milliseconds: 300)));
      var flush;
      flush = Flushbar(
        title: "Offline :(",
        backgroundColor: Colors.red,
        icon: Icon(
          Icons.signal_wifi_off,
          color: Colors.white,
        ),
        message: "Please switch on your internet connection",
        mainButton: ElevatedButton(
            onPressed: () {
              flush.dismiss(true);
            },
            child: Icon(
              Icons.close,
              color: Colors.white,
            )),
      )..show(router.navigator.context);
      return false;
    }
    return true;
  }
}
