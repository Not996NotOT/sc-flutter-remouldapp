import 'package:flutter/material.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'dart:convert';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';

final webViewKey = GlobalKey<WebViewContainerState>();

class DemoPage extends StatefulWidget {
  final String label;
  final String code;
  final String orderId;
  final String idCard;
  final String roomId;
  final String annexId;
  final String path;
  final String companyId;
  final String route;

  const DemoPage(
      {Key key,
      this.label,
      this.code,
      this.orderId,
      this.idCard,
      this.roomId,
      this.annexId,
      this.path,
      this.companyId,
      this.route})
      : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String label = '';
  String code = '';
  String orderId = '';
  String idCard = '';
  String roomId = '';
  String annexId = '';
  String path = '';
  String companyId = '';
  String route = '';
  @override
  void initState() {
    super.initState();
    label = widget.label;
    code = widget.code;
    orderId = widget.orderId;
    idCard = widget.idCard;
    path = widget.path;
    annexId = widget.annexId;
    companyId = widget.companyId;
    roomId = widget.roomId;
    route = widget.route;
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
          orderId: orderId,
          roomId: roomId,
          annexId: annexId,
          path: path,
          companyId: companyId,
          route: route),
    );
  }
}

class WebViewContainer extends StatefulWidget {
  String url = '';
  String code = '';
  String idCard = '';
  String orderId = '';
  String roomId = '';
  String annexId = '';
  String path = '';
  String companyId = '';
  String route = '';
  WebViewContainer(
      {Key key,
      this.url,
      this.code,
      this.idCard,
      this.orderId,
      this.roomId,
      this.annexId,
      this.path,
      this.companyId,
      this.route})
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
  String roomId = '';
  String annexId = '';
  String path = '';
  String companyId = '';
  String route = '';

  @override
  void initState() {
    super.initState();
    url = widget.url;
    code = widget.code;
    idCard = widget.idCard;
    orderId = widget.orderId;
    roomId = widget.roomId;
    annexId = widget.annexId;
    path = widget.path;
    companyId = widget.companyId;
    route = widget.route;
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
                Map<String, Object> map1 = {"files": arr, "idCard": '111'};
                HomeApi.getSingleton().uploadImg(map1).then((res) {
                  if (res != null) {
                    if (res['code'] == 200) {
                      MqttClientMsg.instance?.postMessage(
                          json.encode({
                            "code": code,
                            "encDataFilePath": msg['encDataFilePath'],
                            "userId": roomId,
                            "idCard": idCard,
                            "info": res['item'][0]['filePath']
                          }),
                          "/topic/bank/collect/${route}");
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
