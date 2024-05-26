part of flash_msg;

class MToast{

  static void success(String text, {timeInSecForIos=2}){
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: timeInSecForIos,
      backgroundColor: UIData.colors.success,
      textColor: Colors.white,
    );
  }


  static error(String text){
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: UIData.colors.error,
      textColor: Colors.white,
    );
  }


  static void normal(String text){
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
    );
  }

}