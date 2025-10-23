import 'package:flutter/material.dart';

class BaseDialog extends Dialog {
  //子控件
  final Widget widget;

  // 高
  final double height;

  //宽
  final double width;

  //BG颜色
  final Color bgcolor;

  BaseDialog(this.widget, this.height, this.width, this.bgcolor, {Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: new Material(
            type: MaterialType.transparency,
            child: new Container(
                height: this.height,
                width: this.width,
                decoration: ShapeDecoration(
                    color: this.bgcolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ))),
                child: this.widget),
          )),
    );
  }
}
