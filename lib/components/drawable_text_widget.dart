import 'package:flutter/material.dart';

//图文组合的控件
class DrawableTextView extends StatelessWidget {
  final Widget text;
  final DrawableModel model;
  final String asset;
  final double drawablePadding;
  final double assetWidth;
  final double assetHeight;
  final Color assetColor;
  final GestureTapCallback onTap;

  const DrawableTextView(
      {Key key,
      this.text,
      this.model,
      this.asset,
      this.drawablePadding,
      this.assetWidth,
      this.assetHeight,
      this.assetColor,
      this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (model) {
      case DrawableModel.left:
        return InkWell(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              Image.asset(asset,
                  width: assetWidth, height: assetHeight, color: assetColor),
              drawablePadding != 0
                  ? SizedBox(width: drawablePadding)
                  : Container(),
              text
            ],
          ),
        );
        break;
      case DrawableModel.right:
        return InkWell(
          onTap: onTap,
          child: Row(
            children: <Widget>[
              text,
              drawablePadding != 0
                  ? SizedBox(width: drawablePadding)
                  : Container(),
              Image.asset(asset,
                  width: assetWidth, height: assetHeight, color: assetColor)
            ],
          ),
        );
        break;
      case DrawableModel.top:
        return InkWell(
          onTap: onTap,
          child: Column(
            children: <Widget>[
              Image.asset(asset,
                  width: assetWidth, height: assetHeight, color: assetColor),
              drawablePadding != 0
                  ? SizedBox(height: drawablePadding)
                  : Container(),
              text
            ],
          ),
        );
        break;
      case DrawableModel.bottom:
        return InkWell(
          onTap: onTap,
          child: Column(
            children: <Widget>[
              text,
              drawablePadding != 0
                  ? SizedBox(height: drawablePadding)
                  : Container(),
              Image.asset(asset,
                  width: assetWidth, height: assetHeight, color: assetColor)
            ],
          ),
        );
        break;
    }
  }
}

enum DrawableModel {
  left,
  right,
  top,
  bottom,
}
