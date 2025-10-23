import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'dart:convert';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
// import 'package:notarization_station_app/page/home/demo/demo.dart';
import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show ImageByteFormat, Image;
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

final webViewKey = GlobalKey<WebViewContainerState>();

class DemoPage extends StatefulWidget {
  final String label;
  final String name;
  final String code;
  final String roomId;
  final String idCard;
  const DemoPage(
      {Key key, this.label, this.name, this.code, this.roomId, this.idCard})
      : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String label = '';
  String name = '';
  String code = '';
  String roomId = '';
  String idCard = '';
  @override
  void initState() {
    super.initState();
    label = widget.label;
    name = widget.name;
    code = widget.code;
    roomId = widget.roomId;
    idCard = widget.idCard;
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('签名'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            // IconButton(
            //   icon: Icon(Icons.refresh),
            //   onPressed: () {
            //     webViewKey.currentState?.reloadWebView();
            //   },
            // ),
          ],
        ),
        body: qmDemoPage(
          label: label,
          name: name,
          code: code,
          roomId: roomId,
          idCard: idCard,
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('签名'),
    //     leading: IconButton(
    //       icon: Icon(
    //         Icons.arrow_back
    //       ),
    //       onPressed: (){
    //         Navigator.pop(context);
    //       },
    //     ),
    //     actions: <Widget>[
    //       // IconButton(
    //       //   icon: Icon(Icons.refresh),
    //       //   onPressed: () {
    //       //     webViewKey.currentState?.reloadWebView();
    //       //   },
    //       // ),
    //     ],
    //   ),
    //   // body: WebViewContainer(key: webViewKey,url:label,code:code,idCard:idCard,roomId:roomId),
    //   body: qmDemoPage(label: label,
    //           name:name,
    //           code: code,
    //           roomId:roomId,
    //           idCard:idCard,),
    // );
  }
}

/// Description: 签名画板并截图
///
class qmDemoPage extends StatefulWidget {
  final String label;
  final String code;
  final String name;
  final String roomId;
  final String idCard;
  const qmDemoPage(
      {Key key, this.label, this.name, this.code, this.roomId, this.idCard})
      : super(key: key);
  @override
  _qmDemoPageState createState() => _qmDemoPageState();
}

class _qmDemoPageState extends State<qmDemoPage> {
  String label = '';
  String name = '';
  String code = '';
  String roomId = '';
  String idCard = '';

  /// 标记签名画板的Key，用于截图
  GlobalKey _globalKey;

  /// 已描绘的点
  List<Offset> _points = <Offset>[];

  /// 记录截图的本地保存路径
  String _imageLocalPath;

  File img;

  @override
  void initState() {
    super.initState();
    label = widget.label;
    name = widget.name;
    code = widget.code;
    roomId = widget.roomId;
    idCard = widget.idCard;
    // Init
    _globalKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [Text('签名人： ${name}')],
            ),
            Row(
              children: [Text('签名人身份证： ${idCard}')],
            ),
            Container(
              height: 180.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 0.5),
              ),
              child: RepaintBoundary(
                key: _globalKey,
                child: Stack(
                  children: [
                    GestureDetector(
                      onPanUpdate: (details) => _addPoint(details),
                      onPanEnd: (details) => _points.add(null),
                    ),
                    CustomPaint(painter: BoardPainter(_points)),
                  ],
                ),
              ),
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    setState(() {
                      _points?.clear();
                      _points = [];
                      _imageLocalPath = null;
                    });
                  },
                  child: Text(
                    '重签',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Expanded(child: Container()),
                RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () async {
                    File toFile = await _saveImageToFile();
                    String toPath = await _capturePng(toFile);
                    print('Image Path: $toPath');
                    setState(() {
                      _imageLocalPath = toFile.path;
                      faceComparison(toFile.path);
                    });
                  },
                  child: Text(
                    '提交',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 4.0),
            //   child: Text('签名图片路径:'),
            // ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 4.0),
            //   child: Text(
            //     _imageLocalPath ?? '',
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
            // // Container(
            // //   alignment: Alignment.centerLeft,
            // //   margin: EdgeInsets.only(top: 4.0),
            // //   child: Text('如图: '),
            // // ),
            // Container(
            //   height: 100.0,
            //   margin: EdgeInsets.only(top: 4.0),
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey, width: 0.5),
            //   ),
            //   child: Image.file(File(_imageLocalPath ?? '')),
            // ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 4.0),
            //   child: Text('上传获取路径:'),
            // ),
            // Container(
            //   alignment: Alignment.centerLeft,
            //   margin: EdgeInsets.only(top: 4.0),
            //   child: Text(
            //     uploadimg ?? '',
            //     style: TextStyle(color: Colors.blue),
            //   ),
            // ),
            // Container(
            //   height: 100.0,
            //   margin: EdgeInsets.only(top: 4.0),
            //   alignment: Alignment.center,
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey, width: 0.5),
            //   ),
            //   child: Image.network(uploadimg?? ''),
            // )
          ],
        ),
      ),
    );
  }

  String uploadimg = '';

  faceComparison(String path) async {
    final result = await FlutterImageCompress.compressWithFile(
      path,
      minWidth: 2300, //压缩后的最小宽度
      minHeight: 1500, //压缩后的最小高度
      quality: 20, //压缩质量
      rotate: 0, //旋转角度
    );
    String name = path.substring(path.lastIndexOf("/") + 1, path.length);
    MultipartFile multipartFile =
        MultipartFile.fromFileSync(path, filename: name);

    HomeApi.getSingleton().uploadPictures(multipartFile).then((res) {
      print('签名-----------res--------------$res');
      print('签名-----------code-------------$code');
      print('签名-----------roomId-----------$roomId');
      print(
          '签名-----------info-------------${res['item']['filePath'].toString()}');
      setState(() {
        uploadimg = res['item']['filePath'].toString();
      });
      if (res['code'] == 200) {
        MqttClientMsg.instance.postMessage(
            json.encode({
              "code": code,
              "userId": roomId,
              "info": res['item']['filePath']
            }),
            "/topic/shiping/collect/${idCard}");
        G.pop();
      }
    });
  }

  /// 添加点，注意不要超过Widget范围
  _addPoint(DragUpdateDetails details) {
    RenderBox referenceBox = _globalKey.currentContext.findRenderObject();
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    double maxW = referenceBox.size.width;
    double maxH = referenceBox.size.height;
    // 校验范围
    if (localPosition.dx <= 0 || localPosition.dy <= 0) return;
    if (localPosition.dx > maxW || localPosition.dy > maxH) return;
    setState(() {
      _points = List.from(_points)..add(localPosition);
    });
  }

  /// 选取保存文件的路径
  Future<File> _saveImageToFile() async {
    Directory tempDir = await getTemporaryDirectory();
    int curT = DateTime.now().millisecondsSinceEpoch;
    String toFilePath = '${tempDir.path}/$curT.png';
    File toFile = File(toFilePath);
    bool exists = await toFile.exists();
    if (!exists) {
      await toFile.create(recursive: true);
    }
    return toFile;
  }

  /// 截图，并且返回图片的缓存地址
  Future<String> _capturePng(File toFile) async {
    // 1. 获取 RenderRepaintBoundary
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    // 2. 生成 Image
    ui.Image image = await boundary.toImage();
    // 3. 生成 Uint8List
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    // 4. 本地存储Image
    toFile.writeAsBytes(pngBytes);
    return toFile.path;
  }
}

class BoardPainter extends CustomPainter {
  BoardPainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(BoardPainter other) => other.points != points;
}

// webview签名============================================================================
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
                print("================message: ${msg} ");
                List arr = [];
                arr.add(msg['base64']);
                Map<String, Object> map1 = {"files": arr, "idCard": '111'};
                print(
                    "================code: ${code} roomId: ${roomId}  userViewModel.idCard: ${idCard}");
                HomeApi.getSingleton().uploadImg(map1).then((res) {
                  if (res != null) {
                    if (res['code'] == 200) {
                      print(
                          "================encDataFilePath:${msg['encDataFilePath']}");
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
