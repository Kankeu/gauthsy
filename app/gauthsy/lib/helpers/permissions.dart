part of helpers;

class Permissions {


  static Future<bool> storage([once=false]) async {
    var res = await Permission
        .storage.request().isGranted;
    if (!res&&!once) return storage();
    return true;
  }

  static Future<bool> canStorage() async {
    return
        await Permission
            .storage.request().isGranted;
  }




  static Future<bool> camera([once = false]) async {
    var res =
        await Permission.camera.request().isGranted;
    if (!res && !once) return camera();
    return res;
  }



}
