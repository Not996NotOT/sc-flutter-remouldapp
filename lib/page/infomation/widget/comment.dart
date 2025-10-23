import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';

class CommentDialog extends StatelessWidget {
  final dynamic callback;
  final String params;

  CommentDialog({Key key, @required this.callback, this.params})
      : assert(callback != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: GestureDetector(
          onTap: () {
            return false;
          },
          child: Stack(children: <Widget>[
            Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).viewInsets.bottom > 0
                    ? MediaQuery.of(context).viewInsets.bottom
                    : 0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 10.0, bottom: 6.0),
                    decoration: BoxDecoration(color: Colors.white),
                    child: CommentContent(
                      params: params,
                      callback: callback,
                    )))
          ])),
    );
  }
}

// typedef OnSuccess = void Function(String o);
class CommentContentState extends State<CommentContent> {
  String text;
  String currentValue = '';
  List<File> imgList = [];
  List<String> imgPaths = [];
  bool pending = false;
  bool isFrist = true;

  var _myEventBus;

  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _myEventBus = eventBus.on<Map>().listen((Map event) {
      if (event["isDeal"]) {
        _textEditingController.text = "";
      }
    });
  }

  comment() {
    if (isFrist) {
      isFrist = false;
      widget.callback(currentValue);
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _myEventBus.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: 40.0,
          ),
          child: Container(
            padding: EdgeInsets.only(left: 6.0, right: 6.0, bottom: 4.0),
            decoration: BoxDecoration(color: Color(0xfff0f0f0)),
            child: TextFormField(
              controller: _textEditingController,
              decoration: InputDecoration(
                hintText: widget.params == "" ? "说点什么" : widget.params,
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 14.0, color: Color(0xff606266)),
              autofocus: true,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(
                    "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")),
                LengthLimitingTextInputFormatter(200)
              ],
              scrollPadding: EdgeInsets.only(top: 0.0, bottom: 6.0),
              minLines: 2,
              maxLines: 3,
              onChanged: (v) {
                currentValue = v;
                setState(() {});
              },
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 4.0)),
        Row(
          children: <Widget>[
            const Expanded(child: SizedBox()),
            SizedBox(
                height: 30.0,
                width: 40.0,
                child: FlatButton(
                  padding: EdgeInsets.all(0.0),
                  focusColor: Colors.white,
                  hoverColor: Colors.white,
                  highlightColor: Colors.white,
                  splashColor: Colors.white,
                  child: Text(
                    '发布',
                    style: TextStyle(
                        color: Color(currentValue.length == 0
                            ? 0xffbcbcbc
                            : 0xff00c295)),
                  ),
                  onPressed: () {
                    if (currentValue == '') return;
                    isFrist = true;
                    // G.pop();
                    comment();
                  },
                ))
          ],
        )
      ],
    );
  }
}

class CommentContent extends StatefulWidget {
  final dynamic callback;
  final String params;

  CommentContent({Key key, @required this.callback, this.params})
      : assert(callback != null),
        super(key: key);

  @override
  CommentContentState createState() => CommentContentState();
}
