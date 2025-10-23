import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';

class DebounceButton extends StatefulWidget {
  bool isEnable;
  Function clickTap;
  Widget child;
  EdgeInsets margin;
  EdgeInsets padding;
  BorderRadiusGeometry borderRadius;
  Color backgroundColor;
  Color disableColor;
  DebounceButton(
      {Key key,
      this.isEnable,
      this.clickTap,
      this.child,
      this.margin,
      this.padding,
      this.borderRadius,
      this.backgroundColor,
      this.disableColor})
      : super(key: key);

  @override
  State<DebounceButton> createState() => _DebounceButtonState();
}

class _DebounceButtonState extends State<DebounceButton> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.margin ?? EdgeInsets.all(0),
      child: InkWell(
        onTap: widget.isEnable
            ? () {
                if (widget.clickTap != null) {
                  widget.clickTap.call();
                }
              }
            : null,
        child: Container(
          alignment: Alignment.center,
          child: widget.child,
          padding: widget.padding,
          decoration: BoxDecoration(
            color: widget.isEnable
                ? (widget.backgroundColor ?? AppTheme.themeBlue)
                : (widget.disableColor ?? AppTheme.textBlack_4),
            borderRadius: widget.borderRadius,
          ),
        ),
      ),
    );
  }
}
