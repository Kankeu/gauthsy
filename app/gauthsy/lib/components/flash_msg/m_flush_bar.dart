part of flash_msg;

class MFlushBar {
  static  flushBarError(
      {String title,
      String message,
      Icon icon,
      MaterialButton mainButton,
      Duration duration = const Duration(seconds: 3)}) {
    return Flushbar(
      title: title,
      flushbarPosition: FlushbarPosition.TOP,
      mainButton: mainButton,
      message: message,
      icon: icon,
      isDismissible: true,
      duration: duration,
      leftBarIndicatorColor: UIData.colors.error,
    )..show(router.navigatorKey.currentContext);
  }

  static void flushBarUndo({@required Function onTap}) {
    var flush;
    flush = Flushbar(
      title: "Undo",
      message: "Are you sure?",
      flushbarPosition: FlushbarPosition.TOP,
      mainButton: MButton(
          width: 50,
          hint: "Undo",
          tile:true,
          padding: EdgeInsets.all(15),
          color: UIData.colors.primary,
          onPressed: () async {
            onTap();
            flush.dismiss(false);
          }),
      icon: Icon(Icons.info,color: UIData.colors.primary),
      isDismissible: true,
      duration: const Duration(seconds: 3),
      leftBarIndicatorColor: UIData.colors.primary,
    )..show(router.navigatorKey.currentContext);
  }
  static KR.Router get router => KR.Container().get<KR.Router>("router");

  static flushBarSuccess({
    String title,
    String message,
    Icon icon,
    MaterialButton mainButton,
    Duration duration = const Duration(seconds: 3),
  }) {
    return Flushbar(
      title: title,
      flushbarPosition: FlushbarPosition.TOP,
      message: message ?? " ",
      mainButton: mainButton,
      icon: icon,
      isDismissible: true,
      duration: duration,
      leftBarIndicatorColor: UIData.colors.success,
    )..show(router.navigatorKey.currentContext);
  }
}
