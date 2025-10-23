import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show ImageByteFormat, Image;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DemoPage1 extends StatefulWidget {
  // final  arguments;
  final String orderId;
  final String idCard;
  final String name;
  final String unitGuid;
  final dynamic notarizationMatters;
  final String notaryForm;

  const DemoPage1(
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

class _DemoPageState extends State<DemoPage1> {
  String orderId = '';
  String idCard = '';
  String name = '';
  // String unitGuid = '';
  dynamic notarizationMatters = '';
  String notaryForm = '';
  int quarter = 0;
  WebViewController _webViewController;
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
          title: Text('签名区域(请逐字签署)'),
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
                setState(() {
                  if (quarter == 0) {
                    quarter = 1;
                  } else {
                    quarter = 0;
                  }
                });
              },
            ),
          ],
        ),
        body: qmDemoPage1(
          name: name,
          idCard: idCard,
          orderId: orderId,
          // unitGuid:widget.unitGuid,
          // notarizationMatters:widget.notarizationMatters,
          // notaryForm:widget.notaryForm,
        ),
      ),
    );
  }
}

/// Description: 签名画板并截图
///
class qmDemoPage1 extends StatefulWidget {
  final String name;
  final String idCard;
  final String orderId;
  final String unitGuid; //code
  final dynamic notarizationMatters; //roomId
  final String code = '';
  final String roomId = '';
  final Function callBack;

  const qmDemoPage1(
      {Key key,
      this.name,
      this.idCard,
      this.orderId,
      this.unitGuid,
      this.callBack,
      this.notarizationMatters})
      : super(key: key);
  @override
  _qmDemoPage1State createState() => _qmDemoPage1State();
}

class _qmDemoPage1State extends State<qmDemoPage1> {
  String userName = '';
  String idCard = '';
  String orderId = '';
  String code = '';
  String roomId = '';

  /// 标记签名画板的Key，用于截图
  GlobalKey _globalKey;
  GlobalKey _globalKey1;

  /// 已描绘的点
  List<Offset> _points = <Offset>[];

  /// 记录截图的本地保存路径
  String _imageLocalPath;
  String _imageLocalPath1;
  Uint8List imageData;

  // 签名
  List<String> splitList;
  List<String> indexList;
  String aloneName = '';
  num i = 1;
  bool nextvisible = true;
  String nextbtn = '下一步';
  String commitbtn = '提交';
  bool commitvisible = false;

  num imglen = 0;
  // 保存截图数组
  var imglist = [];
  int nameWidth = 110;
  double nameheight = 0;

  //引入防抖
  ThrottleUtil throttleUtil = ThrottleUtil();

  @override
  void initState() {
    super.initState();
    userName = widget.name;
    code = widget.unitGuid;
    roomId = widget.notarizationMatters;

    // userName = "李沁女明星";

    splitList = judgeChineseOrEnglishName(userName);
    indexList = splitList;
    // indexList = [];
    // for (int i = 0; i < splitList.length; i++,) {
    //   for (int j = 0; j < splitList[i].length; j++) {
    //     indexList.add(splitList[i].substring(j, j + 1).toLowerCase());
    //   }
    // }
    aloneName = indexList[0];
    imglist = [];
    print("用户名字长度：" + indexList.length.toString());
    nameheight = 200 / (indexList.length);
    nextbtn = splitList.length == 1 ? "提交" : '下一步';

    // 签名
    idCard = widget.idCard;
    orderId = widget.orderId;
    // Init
    _globalKey = GlobalKey();
    _globalKey1 = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 45,
      child: Container(
        clipBehavior: Clip.antiAlias,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20.0),
            topRight: const Radius.circular(20.0),
          ),
        ),
        child: Column(children: [
          SizedBox(
            height: 50,
            child: Stack(
              textDirection: TextDirection.rtl,
              children: [
                Center(
                  child: Text(
                    '签名区域',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () async {
                      SystemChrome.setPreferredOrientations([
                        DeviceOrientation.portraitUp,
                        DeviceOrientation.portraitDown
                      ]);
                      Navigator.of(context).pop();
                    }),
              ],
            ),
          ),
          Divider(height: 1.0),
          Container(
            margin: EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0.0),
            width: MediaQuery.of(context).size.height - 70,
            height: MediaQuery.of(context).size.width - 70,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 0.5),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  userName ?? '',
                                  textAlign: TextAlign.center,
                                  textScaleFactor: 1.2,
                                  style: TextStyle(
                                      fontSize: 150, color: Color(0xFFF4F4F4)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        RepaintBoundary(
                            key: _globalKey,
                            child: Opacity(
                              opacity: commitvisible == true ? 0 : 1,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                    onPanUpdate: (details) =>
                                        _addPoint(details),
                                    onPanDown: (details) => _addPoint(details),
                                    onPanEnd: (details) => _points.add(null),
                                  ),
                                  CustomPaint(painter: BoardPainter(_points)),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        // G.pop();
                        print("是否点了重置按钮");
                        setState(() {
                          _points?.clear();
                          _points = [];
                          _imageLocalPath = null;
                          // i = 0;
                          // aloneName = indexList[0];
                          // i = 1;
                          // nextbtn = splitList.length == 1 ? "提交" : '下一步';
                          // nextvisible = true;
                          commitvisible = false;
                          imglist.clear();
                          _imageLocalPath1 = null;
                        });
                      },
                      child: Text(
                        '重签',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('请签'),
                        Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                          // decoration: BoxDecoration(
                          // color: Colors.grey,
                          // border: Border.all(color: Colors.black)),
                          child: Text(
                            " $userName ",
                            maxLines: 1,
                            style: TextStyle(color: Colors.blue),
                            textAlign: TextAlign.center,
                          ),
                        )
                      ],
                    ),
                    ButtonTheme(
                      minWidth: 0.0, //设置最小宽度
                      height: 40.0,
                      child: RaisedButton(
                        color: Theme.of(context).primaryColor,
                        onPressed: throttleUtil.throttle(() {
                          setState(() {
                            // splitList = userName.split('');
                            // if (nextbtn == '提交') {
                            EasyLoading.show();
                            Future.delayed(new Duration(seconds: 2), () async {
                              File toFile1 = await _saveImageToFile();
                              String toPath1 = await _capturePng(toFile1);
                              _imageLocalPath1 = toPath1;

                              print("_imageLocalPath1-------$_imageLocalPath1");
                              faceComparison(_imageLocalPath1);
                              EasyLoading.dismiss();
                            });
                            i++;
                            print(""
                                    " i++;用户名字" +
                                aloneName +
                                "  i:" +
                                i.toString());
                            print("imageList--------$imglist");
                          });
                        }),
                        child: Text(
                          '提交',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }

  Widget getItem() {
    return RepaintBoundary(
        key: _globalKey1,
        child: GridView.builder(
          scrollDirection: Axis.horizontal, //增加上这个就会横向滚动
          reverse: false, //设置为true就会反向滚动，比如从下到上，从左到右
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, //这里代表每行显示几个
            // crossAxisSpacing: 10, //两列之间的距离(竖向滚动)
            // mainAxisSpacing: 4 //两行之间的距离（竖向滚动）
          ),
          itemBuilder: (context, index) {
            return _createGridViewItem(Colors.blue, imglist[index]);
          },
          itemCount: imglist.length - 1 == 0 ? 1 : imglist.length,
        ));
  }

  //单个crad,这里可以自己定义一些样式
  Widget _createGridViewItem(Color color, String _imageLocalPath) {
    return
        // Row(
        //   children: [
        //     Expanded(
        //       child:
        Container(
      height: 50,
      width: 50,
      // color: color,
      child: Image.file(File(_imageLocalPath ?? '')),
    );
    //     )
    //   ],
    // );
  }

  String uploadimg = '';
  faceComparison(String path) async {
    print('签名-----------path--------------$path');
    // File compressedFile = await FlutterNativeImage.compressImage(
    //   path,
    //   quality: 5,
    // );
    EasyLoading.show();
    try {
      // final result = await FlutterImageCompress.compressWithFile(
      //   path,
      //   minWidth: 900, //压缩后的最小宽度
      //   minHeight: 600, //压缩后的最小高度
      //   quality: 20, //压缩质量
      //   rotate: 0, //旋转角度
      // );
      String name = path.substring(path.lastIndexOf("/") + 1, path.length);
      // MultipartFile multipartFile =
      //     MultipartFile.fromFileSync(path, filename: name);
      MultipartFile multipartFile = MultipartFile.fromBytes(imageData,
          filename: name, contentType: MediaType('image', 'png'));
      HomeApi.getSingleton().uploadPictures(multipartFile, errorCallBack: (e) {
        EasyLoading.dismiss();
      }).then((res) {
        EasyLoading.dismiss();
        print('签名-----------res--------------$res');
        print('签名-----------code-------------$code');
        print('签名-----------roomId-----------$roomId');
        print(
            '签名-----------info-------------${res['item']['filePath'].toString()}');
        setState(() {
          uploadimg = res['item']['filePath'].toString();
        });

        if (res['code'] == 200) {
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          if (widget.callBack == null) {
            MqttClientMsg.instance.postMessage(
                json.encode({
                  "code": code,
                  "formUserId": idCard,
                  "userId": roomId,
                  "info": res['item']['filePath']
                }),
                "/topic/hetong/collect/${idCard}");
          } else {
            widget.callBack(res['item']['filePath']);
          }

          G.pop();
        }
      });
    } catch (error) {
      EasyLoading.dismiss();
      log("$error");
    }
  }

  /// 添加点，注意不要超过Widget范围
  _addPoint(details) {
    RenderBox referenceBox = _globalKey.currentContext.findRenderObject();
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    double maxW = referenceBox.size.width;
    double maxH = referenceBox.size.height;
    // print('=========================referenceBox: '+referenceBox.toString());
    // print('=========================localPosition: '+localPosition.toString());
    // print('=========================maxW: '+maxW.toString());
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
    imageData = pngBytes;
    await toFile.writeAsBytes(pngBytes);
    return toFile.path;
  }

// =========================================================================
  /// 选取保存文件的路径
  Future<File> _saveImageToFile1() async {
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
  Future<String> _capturePng1(File toFile) async {
    // 1. 获取 RenderRepaintBoundary
    RenderRepaintBoundary boundary =
        _globalKey1.currentContext.findRenderObject();
    // 2. 生成 Image
    ui.Image image = await boundary.toImage();
    // 3. 生成 Uint8List
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    // 4. 本地存储Image
    imageData = pngBytes;
    await toFile.writeAsBytes(pngBytes);
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
      ..strokeWidth = 10.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(BoardPainter other) => other.points != points;
}
