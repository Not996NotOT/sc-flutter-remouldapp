import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

final webViewKey = GlobalKey<WebViewContainerState>();

class IndexDemoPage extends StatefulWidget {
  final String label;
  final String code;
  final String roomId;
  final String idCard;
  const IndexDemoPage(
      {Key key, this.label, this.code, this.roomId, this.idCard})
      : super(key: key);

  @override
  _IndexDemoPageState createState() => _IndexDemoPageState();
}

class _IndexDemoPageState extends State<IndexDemoPage> {
  String label = '';
  String code = '';
  String roomId = '';
  String idCard = '';
  @override
  void initState() {
    super.initState();
    label = widget.label;
    code = widget.code;
    roomId = widget.roomId;
    idCard = widget.idCard;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('IndexDemo'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.ac_unit),
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
          roomId: roomId),
    );
  }
}

class WebViewContainer extends StatefulWidget {
  String url = '';
  String code = '';
  String idCard = '';
  String roomId = '';
  WebViewContainer({Key key, this.url, this.code, this.idCard, this.roomId})
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
  String roomId = '';
  // var url = 'https://scgzdt.com:9007?name=张三&idCard=320882199509213611&tyKeyword=shiping,手印&offSet=1&terminalType=flutter';
  @override
  void initState() {
    super.initState();
    url = widget.url;
    code = widget.code;
    idCard = widget.idCard;
    roomId = widget.roomId;
  }

  @override
  Widget build(BuildContext context) {
    return WebViewPlus(
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (controller) {
        _webViewController = controller;
        controller.loadUrl(url, headers: {});
      },
      javascriptChannels: <JavascriptChannel>[
        JavascriptChannel(
            name: "share",
            onMessageReceived: (JavascriptMessage message) {
              print("================code: ${code} ");
              print("================roomId: ${roomId} ");
              print("================userViewModel.idCard: ${idCard}");
              if (message.message != null) {
                G.pop();
                Map msg = json.decode(message.message);
                List arr = [];
                arr.add(msg['base64']);
                Map<String, Object> map1 = {"files": arr, "idCard": '111'};
                print(
                    "================code: ${code} roomId: ${roomId}  userViewModel.idCard: ${idCard}");
                HomeApi.getSingleton().uploadImg(map1).then((res) {
                  if (res != null) {
                    if (res['code'] == 200) {
                      MqttClientMsg.instance.postMessage(
                          json.encode({
                            "code": code,
                            "encDataFilePath": msg['encDataFilePath'],
                            "userId": roomId,
                            "info": res['item'][0]['filePath']
                          }),
                          "/topic/shiping/collect/${idCard}");
                    }
                  }
                });
              }
            }),
      ].toSet(),
      onPageFinished: (url) {
        print('....$url');
      },
    );

    // return WebView(
    //   onWebViewCreated: (controller) {
    //     _webViewController = controller;
    //     controller.loadUrl(url,headers: {});
    //   },
    //   javascriptMode: JavascriptMode.unrestricted,
    //   initialUrl: widget.url,
    //   javascriptChannels: <JavascriptChannel>[
    //     JavascriptChannel(
    //         name: "share",
    //         onMessageReceived: (JavascriptMessage message) {
    //           if(message.message!=null){
    //             G.pop();
    //             Map msg =  json.decode(message.message);
    //             List arr = [];
    //             arr.add(msg['base64']);
    //             Map<String,Object> map1 = {"files": arr,"idCard":'111'};
    //             print("================code: ${code} roomId: ${roomId}  userViewModel.idCard: ${userViewModel.idCard}");
    //             HomeApi.getSingleton().uploadImg(map1).then((res){
    //               if(res!=null){
    //                 if(res['code']==200){
    //                   MqttClientMsg.instance.postMessage(json.encode({"code":code,"encDataFilePath": msg['encDataFilePath'],"userId": roomId,"info": res['item'][0]['filePath']}),"/topic/shiping/collect/${userViewModel.idCard}");
    //                 }
    //               }
    //             });
    //           }
    //         }
    //     ),
    //   ].toSet(),
    //   onPageFinished: (url) {
    //     print('....$url');
    //   },
    // );
  }

  void reloadWebView() {
    _webViewController.webViewController?.reload();
  }
}
