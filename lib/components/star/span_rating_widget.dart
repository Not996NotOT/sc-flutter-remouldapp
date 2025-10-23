import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';

class SponRatingWidget extends StatefulWidget {
  final int count;

  final double maxRating;

  final int value;

  final double size;

  final String evaluate;

  final bool isInput;

  final void Function(int type, String params) onRatingUpdate;

  final Color color;

  SponRatingWidget(
      {this.maxRating = 10.0,
      this.count = 5,
      this.value = 3,
      this.size = 30,
      this.color = Colors.blue,
      this.evaluate,
      this.isInput = true,
      @required this.onRatingUpdate})
      : assert(value <= count),
        assert(onRatingUpdate != null);

  @override
  _SponRatingWidgetState createState() => _SponRatingWidgetState();
}

class _SponRatingWidgetState extends BaseState<SponRatingWidget> {
  TextEditingController textEditingController = TextEditingController();
  int value = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            width: getWidthPx(750),
            height: 50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: getWidthPx(40),
                ),
                Text(
                  widget.isInput ? "" : "您的评价",
                  style: TextStyle(fontSize: 16),
                ),
                ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.count,
                    itemBuilder: (ctx, a) {
                      return InkWell(
                        onTap: widget.isInput
                            ? () {
                                value = a + 1;
                                setState(() {});
                              }
                            : null,
                        child: a < (widget.isInput ? value : widget.value)
                            ? Icon(
                                Icons.star,
                                size: widget.size,
                                color: widget.color,
                              )
                            : Icon(
                                Icons.star_border,
                                size: widget.size,
                                color: widget.color,
                              ),
                      );
                    }),
                Expanded(
                  flex: 1,
                  child: widget.isInput
                      ? InkWell(
                          onTap: () {
                            widget.onRatingUpdate(
                                value, textEditingController.text);
                          },
                          child: Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "发布评价",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.blue),
                              )))
                      : SizedBox(),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: new BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
              border: new Border.all(width: 1, color: AppTheme.Text_min),
            ),
            child: TextFormField(
              enabled: widget.isInput,
              decoration: InputDecoration(
                hintText: "请输入评价和建议",
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 16.0, color: Color(0xff606266)),
              controller: textEditingController,
              // cursorColor: Color(0xff00c295),
              scrollPadding: EdgeInsets.only(top: 0.0, bottom: 6.0),
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(
                    "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")),
                LengthLimitingTextInputFormatter(100)
              ],
              minLines: 6,
              maxLines: 6,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    value = widget.value;
    if (widget.evaluate.isNotEmpty) {
      textEditingController.text = "${widget.evaluate}";
    }
  }

  @override
  void didUpdateWidget(covariant SponRatingWidget oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (widget.evaluate.isNotEmpty) {
      textEditingController.text = "${widget.evaluate}";
    }
  }
}
