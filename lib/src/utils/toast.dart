import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static void show(String? message) {
    Fluttertoast.showToast(msg: message!,gravity: ToastGravity.CENTER);
  }
}
