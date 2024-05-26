part of notifications;

class LocalNotifications {
  static int get id => Random().nextInt(1000000);

  // static AudioCache player = new AudioCache();

  static Future<void> ring() async {
    /*   if(Config.app.mute) return;
    try{
      await player.play(UIData.sounds.notification);
    }catch(e){}*/
  }

  static void dispatch(Map<String, dynamic> event) {
    var title = event['event']=="document.validated"?"Document validated":"Document rejected";
   if(event['event']=="document.validated")
    newNotification(title, "Your identity document with number \""+jsonDecode(event['data'])['number']+"\" has been validated");
   else  newNotification(title, "Your identity document with number \""+jsonDecode(event['data'])['number']+"\" has been rejected");

  }

  static newNotification(String title, String content) async {
    await NotificationManager.showNotification(
        id: id, title: title, content: content, payload: UrlParser.getNotificationsLink());
  }

  static Future cancelFileDownload(int id) async {
    await NotificationManager.cancelNotification(id: id);
  }

}
