part of notifications;

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;
  static Dio _http = Dio();

  void setUpFirebase()async {
    _http = new Dio();
    await Firebase.initializeApp();
    _firebaseMessaging = FirebaseMessaging.instance;
    firebaseCloudMessagingListeners();
  }

  static var eventsListeners = Map<String, Function>();

  static void listen(String event, Function listener) {
    eventsListeners[event] = listener;
  }

  static void unlisten(String event) {
    eventsListeners.remove(event);
  }

  static Future<dynamic> myBackgroundMessageHandler(
      RemoteMessage e) async{
    await Firebase.initializeApp();
    var event = e.data;
    print("on background message $event");
    NotificationManager.initOnlyLocalNotification();
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    LocalNotifications.dispatch(event);
  }

  Future firebaseCloudMessagingListeners()async {
     if(!(await askPermission()))return MToast.error("App needs access to notification");

    _firebaseMessaging.getToken().then((token) {
      if (AuthManager.user.fcmToken != token) {
        AuthManager.user.fcmToken = token;
        AuthManager.updateFcmToken(token);
      }
    });
    FirebaseMessaging.onMessage.listen((e) {
      var event= e.data;
      print('on message $event');
      LocalNotifications.dispatch(event);
    });
     FirebaseMessaging.onMessageOpenedApp.listen((e) {
       var event= e.data;
       print('on launch $event');
     });
     FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  }

  Future<bool> askPermission() async{
     var settings =await FirebaseMessaging.instance.requestPermission(sound: true,badge: true,alert: true);
      return AuthorizationStatus.authorized==settings.authorizationStatus||AuthorizationStatus.provisional==settings.authorizationStatus;
  }

}
