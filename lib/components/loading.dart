import 'package:color_dart/color_dart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/utils/global.dart';

class Loading {
  static DateTime _lastPressedAt;

  static show({String text = "正在加载中"}) {
    showGeneralDialog(
      context: G.getCurrentState().overlay.context,
      pageBuilder: (BuildContext buildContext, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: SafeArea(
            child: Builder(builder: (BuildContext context) {
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: Colors.black54,
                  ),
                  width: 120,
                  height: 120,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2.5,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        text,
                        style: TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        );
      },
      barrierDismissible: false,
      barrierLabel:
          MaterialLocalizations.of(G.getCurrentState().overlay.context)
              .modalBarrierDismissLabel,
      barrierColor: rgba(255, 255, 255, 0),
      transitionDuration: const Duration(milliseconds: 150),
      transitionBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: child,
        );
      },
    );
  }

  static close() async {
    while (_lastPressedAt != null) {
      if (_lastPressedAt == null ||
          DateTime.now().difference(_lastPressedAt) > Duration(seconds: 8)) {
      } else {
        ToastUtil.showWarningToast("服务端异常,请稍后再试！");
        G.pop();
      }
    }
  }

  static hide() {
    _lastPressedAt = null;
    Navigator.pop(G.getCurrentState().overlay.context);
  }
}
