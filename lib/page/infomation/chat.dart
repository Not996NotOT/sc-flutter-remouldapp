import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/fade_route.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/photo_view_simple.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/infomation/vm/chat_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/page/mine/widget/triangle.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';

class ChatPage extends StatefulWidget {
  final arguments;
  ChatPage({Key key, this.arguments}) : super(key: key);
  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends BaseState<ChatPage> with WidgetsBindingObserver {
  ChatModel viewModel;
  double heightNum = 133;
  FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (MediaQuery.of(context).viewInsets.bottom == 0) {
          //关闭键盘
          wjPrint("1----------+++++1");
          heightNum = 130;
          viewModel.scrollMsgBottom();
          setState(() {});
        } else {
          //显示键盘
          wjPrint("1----------+++++2");
          heightNum = 410;
          viewModel.scrollMsgBottom();
          setState(() {});
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.themeBlue,
          centerTitle: true,
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 22,
            ),
            onTap: () {
              Navigator.pop(context, "refresh");
            },
          ),
          title: Text(
            "${widget.arguments['name']}的聊天",
            style: TextStyle(fontSize: 16),
          ),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.pop(context, "refresh");
            return Future.value(false);
          },
          child: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
            return ProviderWidget<ChatModel>(
                model: ChatModel(userModel, widget.arguments),
                onModelReady: (model) {
                  viewModel = model;
                  model.loadData();
                },
                builder: (ctx, vm, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            focusNode.unfocus();
                          },
                          child: Container(
                            //列表内容少的时候靠上
                            height: getHeightPx(1334) - heightNum,
                            color: AppTheme.bg_b,
                            alignment: Alignment.topCenter,
                            child: ListView.builder(
                              shrinkWrap: true,
                              // physics:NeverScrollableScrollPhysics(),
                              physics: const AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.only(top: 27),
                              itemBuilder: (context, index) {
                                var item = vm.chatList[index];
                                return item['me'] == 1
                                    ? Container(
                                        color: AppTheme.bg_b,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 20),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 45, right: 15),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            textDirection: TextDirection.rtl,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 15),
                                                alignment: Alignment.center,
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF464EB5),
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: const Padding(
                                                  child: Text(
                                                    "我",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      bottom: 2),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: <Widget>[
                                                    Padding(
                                                      child: Text(
                                                        "${item['time']}  ${item['name']}",
                                                        softWrap: true,
                                                        style: const TextStyle(
                                                          color:
                                                              Color(0xFF677092),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          right: 20),
                                                    ),
                                                    Bubble(
                                                      direction:
                                                          BubbleDirection.right,
                                                      color: AppTheme.themeBlue,
                                                      child: item['isImg'] == 0
                                                          ? Text(
                                                              item['info'],
                                                              softWrap: true,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(new FadeRoute(
                                                                        page: PhotoViewSimpleScreen(
                                                                  imageProvider:
                                                                      NetworkImage(
                                                                          item[
                                                                              'info']), //传入图片
                                                                  heroTag:
                                                                      'simple',
                                                                )));
                                                              },
                                                              child:
                                                                  Image.network(
                                                                item['info'],
                                                                width:
                                                                    getWidthPx(
                                                                        200),
                                                                height:
                                                                    getWidthPx(
                                                                        200),
                                                                fit:
                                                                    BoxFit.fill,
                                                              )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(
                                        color: AppTheme.bg_b,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 20),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              left: 15, right: 45),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                alignment: Alignment.center,
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: Color(0xFF464EB5),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15))),
                                                child: Padding(
                                                  child: Text(
                                                    item['name'] ??
                                                        ''
                                                            .toString()
                                                            .substring(0, 1),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      bottom: 2),
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                      child: Text(
                                                        "${item['name']}  ${item['time']}",
                                                        softWrap: true,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFF677092),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      padding: EdgeInsets.only(
                                                          left: 20, right: 30),
                                                    ),
                                                    Bubble(
                                                      color: Colors.white,
                                                      child: item['isImg'] == 0
                                                          ? Text(
                                                              item['info'],
                                                              style: TextStyle(
                                                                  color: AppTheme
                                                                      .darkerText),
                                                            )
                                                          : InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .push(new FadeRoute(
                                                                        page: PhotoViewSimpleScreen(
                                                                  imageProvider:
                                                                      NetworkImage(
                                                                          item[
                                                                              'info']), //传入图片
                                                                  heroTag:
                                                                      'simple',
                                                                )));
                                                              },
                                                              child:
                                                                  Image.network(
                                                                item['info'],
                                                                width:
                                                                    getWidthPx(
                                                                        200),
                                                                height:
                                                                    getWidthPx(
                                                                        200),
                                                                fit:
                                                                    BoxFit.fill,
                                                              )),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                              },
                              itemCount: vm.chatList.length,
                              controller: vm.msgController,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: getWidthPx(750),
                        margin: EdgeInsets.only(top: 1),
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        decoration: BoxDecoration(
                          color: AppTheme.bg_b,
                          border: Border(
                              top: BorderSide(
                                  width: 1, color: Color(0xFFcccccc))),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                vm.requestCameraPermission();
                              },
                              child: Icon(
                                Icons.photo,
                                color: Colors.black26,
                                size: 35,
                              ),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(6, 6, 10, 6),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(3.0)),
                                constraints: BoxConstraints(
                                    minHeight: 35.0, maxHeight: 100.0),
                                child: TextField(
                                  maxLines: null,
                                  keyboardType: TextInputType.multiline,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                      hintStyle: TextStyle(fontSize: 16.0),
                                      hintText: "请输入内容",
                                      isDense: true,
                                      contentPadding: EdgeInsets.all(5.0),
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none)),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(
                                        "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")),
                                    LengthLimitingTextInputFormatter(200)
                                  ],
                                  controller: vm.textEditingController,
                                  // focusNode: _focusNode,
                                ),
                              ),
                            ),
                            Container(
                              height: 35,
                              child: FlatButton(
                                color: Colors.blue,
                                highlightColor: Colors.blue[700],
                                colorBrightness: Brightness.dark,
                                splashColor: Colors.grey,
                                child: Text("发送"),
                                onPressed: () {
                                  vm.sendMessage();
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                });
          }),
        ));
  }
}
