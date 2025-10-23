import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

final webViewKey = GlobalKey<WebViewContainerState>();

class DemoPage extends StatefulWidget {
  final String label;
  final String code;
  final String orderId;
  final String idCard;
  const DemoPage({Key key, this.label, this.code, this.orderId, this.idCard})
      : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String label = '';
  String code = '';
  String orderId = '';
  String idCard = '';
  @override
  void initState() {
    super.initState();
    label = widget.label;
    code = widget.code;
    orderId = widget.orderId;
    idCard = widget.idCard;
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
          idCard: idCard,
          orderId: orderId),
    );
  }
}

class WebViewContainer extends StatefulWidget {
  String url = '';
  String code = '';
  String idCard = '';
  String orderId = '';
  WebViewContainer({Key key, this.url, this.code, this.idCard, this.orderId})
      : super(key: key);

  @override
  WebViewContainerState createState() => WebViewContainerState();
}

class WebViewContainerState extends State<WebViewContainer> {
  WebViewPlusController _webViewController;
  UserViewModel userViewModel;
  String url = '';
  String code = '';
  String idCard = '';
  String orderId = '';

  @override
  void initState() {
    super.initState();
    url = widget.url;
    code = widget.code;
    idCard = widget.idCard;
    orderId = widget.orderId;
  }

  @override
  Widget build(BuildContext context) {
    return WebViewPlus(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _webViewController = controller;
        controller.loadUrl(url);
      },
      javascriptChannels: <JavascriptChannel>[
        JavascriptChannel(
            name: "share",
            onMessageReceived: (JavascriptMessage message) {
              if (message.message != null) {
                Map msg = json.decode(message.message);
                List arr = [];
                arr.add(msg['base64']);
                Map<String, Object> map1 = {"files": arr, "idCard": idCard};
                HomeApi.getSingleton().uploadImg(map1).then((res) {
                  if (res != null) {
                    if (res['code'] == 200) {
                      MqttClientMsg.instance?.postMessage(
                          json.encode({
                            "code": code,
                            "encDataFilePath": msg['encDataFilePath'],
                            "idCard": idCard,
                            "info": res['item'][0]['filePath']
                          }),
                          "/topic/bankXW/collect/$orderId");
                    }
                  }
                  G.pop();
                });
              }
            }),
      ].toSet(),
      onPageFinished: (url) {
        print('....$url');
      },
    );
  }

  void reloadWebView() {
    _webViewController.webViewController?.reload();
  }
}
