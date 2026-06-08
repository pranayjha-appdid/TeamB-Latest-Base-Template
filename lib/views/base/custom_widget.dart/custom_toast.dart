import 'package:fluttertoast/fluttertoast.dart';

void showCustomToast(msg, {color}) {
  Fluttertoast.showToast(
    msg: "$msg",
    backgroundColor: color,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    webPosition: "center",
    webBgColor: "linear-gradient(to right, #dc1c13, #dc1c13)",
  );
}
