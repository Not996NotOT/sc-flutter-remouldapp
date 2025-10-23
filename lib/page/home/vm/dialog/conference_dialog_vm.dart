import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

final webViewKey = GlobalKey<WebViewContainerState>();

class DemoPage extends StatefulWidget {
  final String label;
  final String code;
  final String roomId;
  final String userName;
  final String userId;
  final String pdfUrl;

  const DemoPage(
      {Key key,
      this.label,
      this.code,
      this.roomId,
      this.userName,
      this.userId,
      this.pdfUrl})
      : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String label = '';
  String code = '';
  String roomId = '';
  String userId = '';
  String userName = '';
  String pdfUrl = '';
  WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    label = widget.label;
    code = widget.code;
    roomId = widget.roomId;
    userId = widget.userId;
    userName = widget.userName;
    pdfUrl = widget.pdfUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              webViewKey.currentState?.reloadWebView();
            },
          ),
        ],
      ),
      body: WebViewContainer(
        key: webViewKey,
        url: label,
        code: code,
        roomId: roomId,
        userName: userName,
        userId: userId,
        pdfUrl: pdfUrl,
      ),
    );
  }
}

class WebViewContainer extends StatefulWidget {
  String url = '';
  String code = '';
  String roomId = '';
  String userName = '';
  String userId = '';
  String pdfUrl = '';

  WebViewContainer(
      {Key key,
      this.url,
      this.code,
      this.roomId,
      this.userId,
      this.userName,
      this.pdfUrl})
      : super(key: key);

  @override
  WebViewContainerState createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {
  WebViewPlusController _webViewController;
  UserViewModel userViewModel;
  String url = '';
  String code = '';
  String roomId = '';
  String userId = '';
  String userName = '';
  String pdfUrl = "";
  SharedPreferences prefs;
  @override
  void initState() {
    super.initState();
    url = widget.url;
    code = widget.code;
    roomId = widget.roomId;
    userId = widget.userId;
    userName = widget.userName;
    pdfUrl = widget.pdfUrl;
    sharepre();
  }

  sharepre() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Future.value(false);
      },
      child: WebViewPlus(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (controller) {
          _webViewController = controller;
          controller.loadUrl(url, headers: {});
        },
        javascriptChannels: <JavascriptChannel>[
          JavascriptChannel(
              name: "share",
              onMessageReceived: (JavascriptMessage message) {
                if (message.message != null) {
                  Map msg = json.decode(message.message);
                  print('=================================================');
                  print('======================msg: $msg');
                  print('======================userId: $userId');
                  print('======================pdfUrl: $pdfUrl');
                  print(
                      '======================encDataFilePath: ${json.decode(msg['encDataFilePath'])}');
                  print('=================================================');
                  G.pop();
                  Map<String, dynamic> data = {
                    "userId": userId,
                    "pdfPath": pdfUrl,
                    "sign": json.decode(msg['encDataFilePath']),
                    "userToken": userId
                  };
                  HomeApi.getSingleton().postSignature(data).then((res) {
                    print("...33333....$res");
                    if (res['code'] == 200) {
                      prefs.setBool("isSignature", true);
                      MqttClientMsg.instance?.postMessage(
                          json.encode({
                            "code": code,
                            "info": "已签字",
                            "userName": userName
                          }),
                          "/topic/conference/collect/${roomId}");
                    }
                  });
                }
              }),
        ].toSet(),
        onPageFinished: (url) {
          print('....$url');
        },
      ),
    );
  }

  void reloadWebView() {
    _webViewController.webViewController?.reload();
  }
}
