import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

//参数
enum ToastState { normal, success, warning, error, unknown }

class ToastUtil {
  static void showNormalToast(String text,
      {String gravity = "top", int second = 1}) {
    showToast(text, type: ToastState.normal, gravity: gravity, second: second);
  }

  static void showWarningToast(String text,
      {String gravity = "top", int second = 1}) {
    showToast(text, type: ToastState.warning, gravity: gravity, second: second);
  }

  static void showSuccessToast(String text,
      {String gravity = "top", int second = 1}) {
    showToast(text, type: ToastState.success, gravity: gravity, second: second);
  }

  static void showErrorToast(String text,
      {String gravity = "top", int second = 1}) {
    showToast(text, type: ToastState.error, gravity: gravity, second: 1);
  }

  static void showOtherToast(String text,
      {String gravity = "top", int second = 1}) {
    showToast(text, type: ToastState.unknown, gravity: gravity, second: 1);
  }

  //消息提示
  static void showToast(String text,
      {ToastState type = ToastState.success,
      String gravity = "top",
      bool clearToastQueue = false,
      int second = 1}) {
    //if (clearToastQueue) //清除消息队列
    Fluttertoast.cancel();
    var bgColor;
    var toastGravity;
    switch (type) {
      case ToastState.normal:
        bgColor = Colors.blueGrey;
        break;
      case ToastState.warning:
        bgColor = Colors.amber;
        break;
      case ToastState.success:
        bgColor = Colors.blue;
        break;
      case ToastState.error:
        bgColor = Colors.redAccent;
        break;
      default:
        bgColor = Colors.blueGrey;
        break;
    }
    switch (gravity) {
      case "top":
        toastGravity = ToastGravity.TOP;
        break;
      case "top_left":
        toastGravity = ToastGravity.TOP_LEFT;
        break;
      case "top_right":
        toastGravity = ToastGravity.TOP_RIGHT;
        break;
      case "bottom":
        toastGravity = ToastGravity.BOTTOM;
        break;
      case "bottom_left":
        toastGravity = ToastGravity.BOTTOM_LEFT;
        break;
      case "bottom_right":
        toastGravity = ToastGravity.BOTTOM_RIGHT;
        break;
      case "center":
        toastGravity = ToastGravity.CENTER;
        break;
      case "center_left":
        toastGravity = ToastGravity.CENTER_LEFT;
        break;
      case "center_right":
        toastGravity = ToastGravity.CENTER_RIGHT;
        break;
      default:
        toastGravity = ToastGravity.TOP;
        break;
    }

    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: toastGravity,
        timeInSecForIosWeb: second,
        backgroundColor: bgColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
