import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'dart:convert';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:developer';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/routes/router.dart';

import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui show ImageByteFormat, Image;
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

final webViewKey = GlobalKey<WebViewContainerState>();

class DemoPage extends StatefulWidget {
  // final  arguments;
  final String orderId;
  final String idCard;
  final String name;
  final String unitGuid;
  final dynamic notarizationMatters;
  final String notaryForm;

  const DemoPage(
      {Key key,
      this.orderId,
      this.idCard,
      this.name,
      this.unitGuid,
      this.notarizationMatters,
      this.notaryForm})
      : super(key: key);

  @override
  _DemoPageState createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  String orderId = '';
  String idCard = '';
  String name = '';
  // String unitGuid = '';
  dynamic notarizationMatters = '';
  String notaryForm = '';
  int quarter = 0;
  @override
  void initState() {
    super.initState();
    orderId = widget.orderId;
    idCard = widget.idCard;
    name = widget.name;
    // unitGuid = widget.unitGuid;
    // notarizationMatters = widget.notarizationMatters;
    notaryForm = widget.notaryForm;
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: quarter,
      child: Scaffold(
        appBar: AppBar(
          title: Text('签名'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          // actions: <Widget>[
          //   IconButton(
          //     icon: Icon(Icons.refresh),
          //     onPressed: () {
          //       setState(() {
          //         if(quarter == 0){
          //           quarter = 1;
          //         }else{
          //           quarter = 0;
          //         }
          //       });
          //     },
          //   ),
          // ],
        ),
        body: qmDemoPage(
          name: name,
          idCard: idCard,
          orderId: orderId,
          unitGuid: widget.unitGuid,
          notarizationMatters: widget.notarizationMatters,
          notaryForm: widget.notaryForm,
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
    //   // body: WebViewContainer(key: webViewKey,
    //   //         url:label,
    //   //         arguments:widget.arguments,
    //   //         idCard:idCard,
    //   //         orderId:orderId,
    //   //         roomId:roomId,
    //   //         annexId:annexId,
    //   //         path:path,
    //   //         companyId:companyId,
    //   //         route:route),
    //   body: qmDemoPage(
    //     name:name,
    //     idCard:idCard,
    //     orderId:orderId,
    //     unitGuid:widget.unitGuid,
    //     notarizationMatters:widget.notarizationMatters,
    //     notaryForm:widget.notaryForm,
    //   ),
    // );
  }
}

/// Description: 签名画板并截图
///
class qmDemoPage extends StatefulWidget {
  final String name;
  final String idCard;
  final String orderId;
  final String unitGuid;
  final dynamic notarizationMatters;
  final String notaryForm;

  const qmDemoPage(
      {Key key,
      this.name,
      this.idCard,
      this.orderId,
      this.unitGuid,
      this.notarizationMatters,
      this.notaryForm})
      : super(key: key);
  @override
  _qmDemoPageState createState() => _qmDemoPageState();
}

class _qmDemoPageState extends State<qmDemoPage> {
  String userName = '';
  String idCard = '';
  String orderId = '';

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
    userName = widget.name;
    idCard = widget.idCard;
    orderId = widget.orderId;
    // Init
    _globalKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: new SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
        child: Column(
          children: <Widget>[
            Row(
              children: [Text('签名人： ${userName}')],
            ),
            Row(
              children: [Text('签名人身份证： ${idCard}')],
            ),
            Container(
              height: 50.0,
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
                      faceComparison(_imageLocalPath);
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
          ],
        ),
      ),
    ));
  }

  // dialog(){
  //   return AlertDialog(
  //     title: Text("提示"),
  //     content: Text("您确定要删除当前文件吗?"),
  //     actions: <Widget>[
  //       FlatButton(
  //         child: Text("取消"),
  //         onPressed: () => Navigator.of(context).pop(), //关闭对话框
  //       ),
  //       FlatButton(
  //         child: Text("确定"),
  //         onPressed: ()async {
  //             File toFile = await _saveImageToFile();
  //             String toPath = await _capturePng(toFile);
  //             print('Image Path: $toPath');
  //             setState(() {
  //               _imageLocalPath=toFile.path;
  //               faceComparison(_imageLocalPath);
  //             });
  //           Navigator.of(context).pop(true); //关闭对话框
  //         },
  //       ),
  //     ],
  //   );
  // }

  String uploadimg = '';
  faceComparison(String path) async {
    EasyLoading.show();
    print('签名-----------path--------------$path');
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
      print(
          '签名-----------info-------------${res['item']['filePath'].toString()}');
      setState(() {
        uploadimg = res['item']['filePath'].toString();
      });

      if (res['code'] == 200) {
        print('签名-----------code-------------${idCard}');
        print('签名-----------unitGuid-------------${widget.unitGuid}');
        print(
            '签名-----------notarizationMatters-------------${widget.notarizationMatters}');
        print('签名-----------notaryForm-------------${widget.notaryForm}');
        var map = {
          "idCard": idCard,
          "signPictureUrl": uploadimg,
          "terminalType": 1,
          "unitGuid": widget.orderId,
          "userName": userName
        };
        // print('map: $map');

        HomeApi.getSingleton().doSetSignNameJSCA(map).then((res) {
          EasyLoading.dismiss();
          if (res["code"] == 200) {
            ToastUtil.showSuccessToast("签字成功！");
            G.pushNamed(RoutePaths.SubmitOrderList, arguments: {
              "notarizationMatters": widget.notarizationMatters,
              "orderId": widget.orderId,
              "notaryForm": widget.notaryForm
            });
          } else {
            ToastUtil.showErrorToast(res["msg"]);
            G.pop();
          }
        });
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

// 签名webview=================================================================
class WebViewContainer extends StatefulWidget {
  String url = '';
  final arguments;
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
      this.arguments,
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
  dynamic arguments;
  String idCard = '';
  String orderId = '';
  String roomId = '';
  String annexId = '';
  String path = '';
  String companyId = '';
  String route = '';
  var jiaMiBao;
  bool isName = true;
  @override
  void initState() {
    super.initState();
    url = widget.url;
    arguments = widget.arguments;
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
    print('============look=============arguments: ' + arguments.toString());
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
              if (message.message != null) {
                G.pop();
                Map msg = json.decode(message.message);
                List arr = [];
                arr.add(msg['base64']);
                Map<String, Object> map1 = {"files": arr, "idCard": '111'};
                HomeApi.getSingleton().uploadImg(map1).then((res) {
                  if (res != null) {
                    if (res['code'] == 200) {
                      log(msg['encDataFilePath'].toString());
                      EasyLoading.show();
                      jiaMiBao = jsonDecode(msg['encDataFilePath']);
                      doSetSignName(res['item'][0]['filePath'], arguments);
                      isName = false;
                      // notifyListeners();
                    }
                  }
                });
              }
            }),
      ].toSet(),
      onPageFinished: (url) {
        EasyLoading.dismiss();
      },
    );
  }

  void doSetSignName(String path, dynamic arguments) async {
    //签字
    var map = {
      "unitGuid": arguments["orderId"],
      "signName": Config.splicingImageUrl(path),
      "encDataFilePath": jiaMiBao,
    };
    print("++++++++++++++$map");
    HomeApi.getSingleton().doSetSignName(map).then((value) {
      EasyLoading.dismiss();
      if (value["code"] == 200) {
        ToastUtil.showSuccessToast("签字成功！");

        G.pushNamed(RoutePaths.SubmitOrderList, arguments: {
          "notarizationMatters": arguments["notarizationMatters"],
          "orderId": arguments["orderId"],
          "notaryForm": arguments["notaryForm"]
        });
      } else {
        ToastUtil.showErrorToast(value["msg"]);
        G.pop();
      }
    });
  }

  void reloadWebView() {
    _webViewController.webViewController?.reload();
  }
}
