import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../../config.dart';
import '../../utils/common_tools.dart';

class ScanWidget1 extends StatefulWidget {
  const ScanWidget1({Key key}) : super(key: key);

  @override
  State<ScanWidget1> createState() => _ScanWidget1State();
}

class _ScanWidget1State extends BaseState<ScanWidget1> {
  Barcode result;
  QRViewController controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  bool isGranted = false;

  UserViewModel userViewModel;

  int count = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // 初始化访问权限
  void initPermission() async {
    Permission.camera.status.isGranted.then((value){
      if(!value){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机权限使用说明：",
            subTitleText: "用于拍摄、录制视频等场景",
            time: 2
        );
      }
    });
    Permission.camera.request().isGranted.then((value) {
      if (value) {
        setState(() {
          isGranted = true;
        });
      } else {
        setState(() {
          isGranted = false;
        });
        G.showPermissionDialog(str: '访问相机权限',cancelCallBack: (){
          userViewModel.currentIndex = 0;
        });
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else {
      controller.resumeCamera();
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      controller.pauseCamera();
      count ++;
      if(count == 1){
        if (scanData != null &&
            scanData.code != null &&
            scanData.code.isNotEmpty) {
          try {
            Map<String, dynamic> resultMap = jsonDecode(scanData.code);
            if (resultMap['type'] == 1) {
              if (resultMap['unitGuid'] == null) {
                ToastUtil.showToast("公证书制作中，请稍后再试");
                Future.delayed(const Duration(milliseconds: 200), () {
                  controller.resumeCamera();
                });
              } else {
                EasyLoading.show(status: '证书查询中...');
                HomeApi.getSingleton().selectByOrderGuid(
                    {"unitGuid": resultMap['unitGuid']}, errorCallBack: (e) {
                  EasyLoading.dismiss();
                  count = 0;
                }).then((value) {
                  EasyLoading.dismiss();
                  if (value['code'] == 200) {
                    if (value['data']) {
                      Navigator.pushNamed(
                          G.getCurrentContext(), RoutePaths.ElectronicNotarialCertificate,
                          arguments: {
                            "unitGuid": (jsonDecode(scanData.code) as Map)['unitGuid'],}).then((value){
                        controller.resumeCamera();
                        count = 0;
                      });
                    } else {
                      ToastUtil.showToast("公证书制作中，请稍后再试");
                      Future.delayed(const Duration(milliseconds: 200), () {
                        controller.resumeCamera();
                        count = 0;
                      });
                    }
                  } else {
                    ToastUtil.showToast("${value.data['message']}}");
                    Future.delayed(const Duration(milliseconds: 200), () {
                      controller.resumeCamera();
                      count = 0;
                    });
                  }
                });
              }
            } else {
              errorQRCodeAlert();
            }
          } catch (e) {
            errorQRCodeAlert();
          }
        } else if (result != null &&
            scanData.code != null &&
            scanData.code.isEmpty) {
          errorQRCodeAlert();
        }
      }
    });
  }

  // 不合规二维码提示
  void errorQRCodeAlert() {
    showDialog(
        context: context,
        builder: (context) {
          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: getWidthPx(40), horizontal: getWidthPx(60)),
                    child: Text(
                      "非系统内二维码不支持识别处理请确认二维码来源合法有效",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: getSp(30), color: AppTheme.lightText),
                    ),
                  ),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Future.delayed(const Duration(milliseconds: 200), () {
                        controller.resumeCamera();
                        count = 0;
                      });
                    },
                    child: Center(
                      child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: getWidthPx(30)),
                          child: Text('我知道了',
                              style: TextStyle(
                                  fontSize: getSp(30),
                                  color: AppTheme.themeBlue))),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    controller?.dispose();
    count = 0;
    super.dispose();
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (controller) {
        wjPrint("controller-------$controller");
        _onQRViewCreated(controller);
      },
      overlay: QrScannerOverlayShape(
          borderColor: AppTheme.themeBlue,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: 300),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    // wjPrint('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    // if (!p) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('no Permission')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        initPermission();
      },
      child: Scaffold(
        // appBar: commonAppBar(title: '扫一扫'),
        body: Consumer<UserViewModel>(builder: (context,userModel,child){
          userViewModel = userModel;
          return isGranted ? _buildQrView(context) : SizedBox();
        },),
      ),
    );
  }
}
