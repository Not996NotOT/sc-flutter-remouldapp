import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui show ImageByteFormat, Image;

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http_parser/src/media_type.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/judicial_network.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:path_provider/path_provider.dart';

import '../../config.dart';
import '../../utils/common_tools.dart';

class SignatureWidget extends StatefulWidget {
  final String fileId;
  final String unitGuid;
  const SignatureWidget({Key key, this.fileId, this.unitGuid})
      : super(key: key);

  @override
  State<SignatureWidget> createState() => _SignatureWidgetState();
}

class _SignatureWidgetState extends State<SignatureWidget> {
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

  num imglen = 0;
  // 保存截图数组
  var imglist = [];
  int nameWidth = 110;
  double nameheight = 0;

  String annexId = '';
  String companyId = '';

  //引入防抖
  ThrottleUtil throttleUtil = ThrottleUtil();

  String userName = '';

  bool isEnable = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _globalKey = GlobalKey();
    _globalKey1 = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("案件办理", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_outlined,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context, '');
          },
        ),
      ),
      body: RotatedBox(
        quarterTurns: 1,
        child: Container(
          margin: const EdgeInsets.only(left: 15),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    '签名区域',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16.0),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15, horizontal: 30),
                  child: ColoredBox(
                    color: Color(0xFFF8F8F8),
                    child: Stack(children: [
                      Center(
                        child: Text(
                          G.userName,
                          style: TextStyle(
                              fontSize: 125,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF333333).withAlpha(15)),
                        ),
                      ),
                      RepaintBoundary(
                          key: _globalKey,
                          child: Opacity(
                            opacity: 1,
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onPanUpdate: (details) =>
                                      _addPoint(details),
                                  onPanDown: (details) =>
                                      _addPoint(details),
                                  onPanEnd: (details) => _points.add(null),
                                ),
                                CustomPaint(painter: BoardPainter(_points)),
                              ],
                            ),
                          )),
                    ]),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(

                    onTap: () {
                      setState(() {
                        _points?.clear();
                        _points = [];
                        _imageLocalPath = null;
                        imglist.clear();
                        _imageLocalPath1 = null;
                      });
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        '重签',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('请签'),
                      Container(
                        padding: EdgeInsets.symmetric(
                            vertical: 5, horizontal: 15),
                        // decoration: BoxDecoration(
                        // color: Colors.grey,
                        // border: Border.all(color: Colors.black)),
                        child: Text(
                          " ${G.userName}",
                          maxLines: 1,
                          style: TextStyle(color: Colors.blue),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  DebounceButton(
                    isEnable: isEnable,
                    borderRadius: BorderRadius.circular(10),
                    padding:
                    EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    clickTap: () {
                      // splitList = userName.split('');
                      // if (nextbtn == '提交') {
                      if(_points.isEmpty){
                        ToastUtil.showToast("请签字后再提交");
                        return;
                      }
                      setState(() {
                        isEnable = false;
                      });
                      EasyLoading.show();
                      Future.delayed(new Duration(seconds: 2), () async {
                        File toFile1 = await _saveImageToFile();
                        String toPath1 = await _capturePng(toFile1);
                        _imageLocalPath1 = toPath1;

                        wjPrint("_imageLocalPath1-------$_imageLocalPath1");
                        faceComparison(_imageLocalPath1);
                      });
                      i++;
                      wjPrint(""
                          " i++;用户名字" +
                          aloneName +
                          "  i:" +
                          i.toString());
                      wjPrint("imageList--------$imglist");
                    },
                    child: Text(
                      '提交',
                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              )
            ],
          ),
        ),
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
    wjPrint('签名-----------path--------------$path');
    try {
      // final result = await FlutterImageCompress.compressWithFile(
      //   path,
      //   minWidth: 900, //压缩后的最小宽度
      //   minHeight: 600, //压缩后的最小高度
      //   quality: 20, //压缩质量
      //   rotate: 0, //旋转角度
      //   format: CompressFormat.png
      // );
      String name = path.substring(path.lastIndexOf("/") + 1, path.length);
      // MultipartFile multipartFile =
      // MultipartFile.fromFileSync(path, filename: name);
      // wjwjPrint('multipartFile1文件格式：${multipartFile.contentType}');

      dio.MultipartFile multipartFile = dio.MultipartFile.fromBytes(imageData,
          filename: name, contentType: MediaType('image', 'png'));
      wjPrint('multipartFile文件格式：${multipartFile.contentType}');
      uploadPictures(multipartFile, errorCallBack: (e) {
        EasyLoading.dismiss();
        setState(() {
          isEnable = true;
        });
        ToastUtil.showErrorToast("网络出错了，请稍后再试");
      }).then((res) {
        if (res != null && res['code'] == 200) {
          signTellFile(res['item']['unitGuid']);
          setState(() {
            uploadimg = res['item']['filePath'].toString();
          });
        } else {
          setState(() {
            isEnable = true;
          });
          EasyLoading.dismiss();
          ToastUtil.showErrorToast(res['msg'] ?? res['message'] ?? res['data']);
        }
      });
    } catch (error) {
      setState(() {
        isEnable = true;
      });
      EasyLoading.dismiss();
      log("$error");
    }
  }


  Future uploadPictures(MultipartFile file, {Function errorCallBack}) async {
    FormData formData = FormData.fromMap({
      "file": file,
    });
    Options options = Options(
        receiveTimeout: 5000,
        sendTimeout: 5000,
        headers: {
          'token':G.userToken,
        },
        contentType: "multipart/form-data");
    final response = await JudicialNetwork.instance.post(
        "${Config.annexModule}/sys/annex/fastDFSUpload",
        data: formData,
        options: options,
        errorCallBack: errorCallBack);
    wjPrint("uploadPictures---------$response");
    return response.data;
  }

  // 调用签字接口
  void signTellFile(String signId) {
    Map data = {
      'unitGuid': widget.unitGuid,
      'notificationFileId': widget.fileId,
      'signId': signId,
      'currentPaqe': 1,
      'pageSize': 99
    };
    HomeApi.getSingleton().signTellFile(data, errorCallBack: (error) {
      EasyLoading.dismiss();
      ToastUtil.showErrorToast("网络出错了，请稍后再试");
      setState(() {
        isEnable = true;
      });
    }).then((value) {
      if (value != null && value['code'] == 200) {
        updateOrderState(status: '3', signId: signId);
      } else {
        setState(() {
          isEnable = true;
        });
        EasyLoading.dismiss();
        ToastUtil.showErrorToast("签字报错了！");
      }
    });
  }

  // 更新订单状态
  void updateOrderState({String status, int lotteryStatus, String signId}) {
    Map data = {
      'status': status,
      'unitGuid': widget.unitGuid,
      'signId': signId
    };

    HomeApi.getSingleton().updateOrder(data, errorCallBack: (error) {
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      EasyLoading.dismiss();
    }).then((value) {
      setState(() {
        isEnable = true;
      });
      if (value != null) {
        if (value['code'] == 200) {
          EasyLoading.dismiss();
          SystemChrome.setPreferredOrientations(
              [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
          Navigator.pop(context, value['data']['notificationFileId']);
        } else {
          EasyLoading.dismiss();
          ToastUtil.showErrorToast(
              value['message'] ?? value['msg'] ?? value['data']);
        }
      } else {
        EasyLoading.dismiss();
        ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      }
    });
  }

  /// 添加点，注意不要超过Widget范围
  _addPoint(details) {
    RenderBox referenceBox = _globalKey.currentContext.findRenderObject();
    Offset localPosition = referenceBox.globalToLocal(details.globalPosition);
    double maxW = referenceBox.size.width;
    double maxH = referenceBox.size.height;
    // wjwjPrint('=========================referenceBox: '+referenceBox.toString());
    // wjwjPrint('=========================localPosition: '+localPosition.toString());
    // wjPrint('=========================maxW: '+maxW.toString());
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
      ..strokeWidth = 10.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }

  bool shouldRepaint(BoardPainter other) => other.points != points;
}
