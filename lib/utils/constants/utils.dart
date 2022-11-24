import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

showToast(String msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      fontSize: 16.0);
}

String get currentDate {
  var now = DateTime.now();
  var formatter = DateFormat('MM-dd-yyyy');
  return formatter.format(now);
}
