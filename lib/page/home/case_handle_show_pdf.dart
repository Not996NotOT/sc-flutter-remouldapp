import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/log_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../utils/common_tools.dart';

class CaseHandleShowPDF extends StatefulWidget {
  final String fileId;

  final String unitGuid;

  final String unionnotaritionid;

  final String userName;

  final String idCard;

  final String token;

  // 是否开启线上支付
  final int isOnlinePay;
  // 支付金额
  final double money;
  // 是否支付
  final int payStatus;
  // 公证处名称
  final String notaryName;

  CaseHandleShowPDF(
      {Key key,
      this.fileId,
      this.unitGuid,
      this.unionnotaritionid,
      this.token,
      this.userName,
      this.idCard,
      this.isOnlinePay,
      this.money,
      this.payStatus,
      this.notaryName})
      : super(key: key);

  @override
  State<CaseHandleShowPDF> createState() => _CaseHandleShowPDFState();
}

class _CaseHandleShowPDFState extends BaseState<CaseHandleShowPDF> {
  List images = [];

  String fileUrl = '';

  String unitGuid = '';

  String fileId = '';

  List imageData = [];

  SwiperController controller = SwiperController();

  @override
  void initState() {
    super.initState();
    unitGuid = widget.unitGuid;
    getFileInformation();
  }

  // 获取文件信息
  getFileInformation() {
    setState(() {
      fileUrl = '';
    });
    HomeApi.getSingleton().selectNotarizationForm(unitGuid,
        errorCallBack: (error) {
      ToastUtil.showErrorToast("获取文书信息失败！");
    }).then((value) async {
      if (value != null && value['code'] == 200 && value['data'] != null) {
        // "https://testgz.njguochu.com:33133/group1/M00/1E/03/wKgx4WVEifyAY5uVADFE8tF74FA094.pdf";//
        wjPrint("Start download file from internet!");
        String url = value['data']['filePath'];
        pdfToImage(url);
        // setState(() {
        //   fileUrl = url;
        // });

        // return completer.future;
      } else {
        ToastUtil.showErrorToast("获取文书信息失败！");
      }
    });
  }

  // 签字过后获取文书信息
  getSignFileInformation() {
    setState(() {
      fileUrl = '';
    });
    HomeApi.getSingleton().queryFileById(fileId, errorCallBack: (error) {
      ToastUtil.showErrorToast("获取文书信息失败！");
    }).then((value) async {
      if (value != null && value['code'] == 200 && value['data'] != null) {
        // "https://testgz.njguochu.com:33133/group1/M00/1E/03/wKgx4WVEifyAY5uVADFE8tF74FA094.pdf";//
        wjPrint("Start download file from internet!");
        String url = value['data']['filePath'];
        pdfToImage(url);
        // setState(() {
        //   fileUrl = url;
        // });

        // return completer.future;
      } else {
        ToastUtil.showErrorToast("获取文书信息失败！");
      }
    });
  }

  /// pdf 转图片

  void pdfToImage(String url) {
    HomeApi.getSingleton().pdfToImg({
      'filePath': url,
    }, errorCallBack: (error) {
      EasyLoading.dismiss();
    }).then((value) {
      if (value != null) {
        if (value['code'] == 200) {
          EasyLoading.dismiss();
          if (value['data'] != null && value['data'].toString().isNotEmpty) {
            setState(() {
              imageData = value['data'];
            });
          } else {
            ToastUtil.showToast(value['message'] ?? '');
          }
        } else {
          EasyLoading.dismiss();
          ToastUtil.showToast(value['message'] ?? '');
        }
      } else {
        EasyLoading.dismiss();
        ToastUtil.showToast("网络出错了，请稍后再试");
      }
    });
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
            G.pop();
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text('本案件由${widget.notaryName ?? "南京市石城公证处"}进行公证',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF333333),
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
              child: imageData.isNotEmpty
                  ? ColoredBox(
                      color: Colors.white,
                      key: Key('PDFKey'),
                      child: Swiper(
                        scrollDirection: Axis.vertical,
                        autoplay: false,
                        loop: false,
                        pagination: new SwiperPagination(
                          alignment: Alignment.topLeft,
                          builder: new MyFractionPaginationBuilder(
                              fontSize: 14,
                              activeFontSize: 14,
                              color: AppTheme.lightText,
                              activeColor: AppTheme.lightText),
                        ),
                        controller: controller,
                        itemBuilder: (context, index) {
                          return Image.network(imageData[index]);
                        },
                        itemCount: imageData.length,
                      ))
                  : loadingWidget()),
          DecreaseTimeButton(
            unionnotaritionid: widget.unionnotaritionid,
            unitGuid: widget.unitGuid,
            fileId: widget.fileId,
            userName: widget.userName,
            idCard: widget.idCard,
            money: widget.money,
            payStatus: widget.payStatus,
            isOnlinePay: widget.isOnlinePay,
            notaryName: widget.notaryName,
            functionCallBack: (value) {
              if (value.toString().isNotEmpty) {
                imageData.clear();
                fileId = value;
                getSignFileInformation();
              }
            },
          )
        ],
      ),
    );
  }
}

class DecreaseTimeButton extends StatefulWidget {
  final int count;

  final String unitGuid;

  final String unionnotaritionid;

  final String userName;

  final String idCard;

  final Function functionCallBack;

  final String fileId;

  final double money;

  final int payStatus;

  final int isOnlinePay;

  final String notaryName;

  const DecreaseTimeButton(
      {Key key,
      this.count = 10,
      this.unionnotaritionid,
      this.unitGuid,
      this.functionCallBack,
      this.userName,
      this.idCard,
      this.fileId,
      this.money,
        this.payStatus,
        this.notaryName,
      this.isOnlinePay});

  @override
  State<DecreaseTimeButton> createState() => _DecreaseTimeButtonState();
}

class _DecreaseTimeButtonState extends State<DecreaseTimeButton> {
  Timer timer;

  String buttonStr = '';

  int timerCount = 10;

  bool isEnable = false;

  Key textKey = Key('textKey');

  @override
  void initState() {
    super.initState();
    String tempString = "(${timerCount--})S";
    buttonStr = tempString;
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount == 0) {
        timer.cancel();
        isEnable = true;
        tempString = '我阅读以上内容，无异议';
        // buttonStr = tempString;
        buttonStr = tempString;
      } else {
        tempString = "($timerCount)S";
        buttonStr = tempString;
        timerCount--;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return DebounceButton(
      isEnable: isEnable,
      margin: EdgeInsets.only(left: 15, right: 15, bottom: 30),
      padding: EdgeInsets.symmetric(vertical: 15),
      borderRadius: BorderRadius.circular(10),
      backgroundColor: AppTheme.themeBlue,
      disableColor: Colors.grey,
      clickTap: () {
        if (buttonStr == "下一步") {
          setState(() {
            isEnable = false;
          });
          wjPrint("G.isGranted-----${G.isGranted}");
          try {
            if (G.isGranted != 1) {
              G.requestForegroundService(decideBack: () {
                // 开始录屏
                showRecordAlert(context, decideFunction: () {
                  G.pop();
                  Permission.microphone.status.isGranted.then((tempValue) {
                    if (!tempValue) {
                      G.showCustomToast(
                        context: context,
                        titleText: "录音权限使用说明：",
                        subTitleText: "用于语音录制等场景",
                        time: 2,
                      );
                    }
                  });
                  Permission.microphone.request().isGranted.then((value) {
                    if (value) {
                      // 开始录屏
                      String fileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                       EasyLoading.show(status: "录屏准备中，请稍候...");
                       // 延迟5秒后开始录屏，避免页面跳转冲突
                       Future.delayed(const Duration(seconds: 5), () {
                         EasyLoading.show(status: "录屏即将开始");
                         FlutterScreenRecording.startRecordScreen(fileName)
                          .then((data) {
                        wjPrint("started-------$data");
                        if (data) {
                          Future.delayed(const Duration(seconds: 2), () {
                            EasyLoading.dismiss();
                            setState(() {
                              isEnable = true;
                            });
                            G.pushNamed(RoutePaths.notaryExtractWidget,
                                arguments: {
                                  'unitGuid': widget.unitGuid,
                                  'unionnotaritionid': widget.unionnotaritionid,
                                  'userName': widget.userName,
                                  'idCard': widget.idCard,
                                  "notaryName":widget.notaryName
                                });
                          });
                        } else {
                          EasyLoading.dismiss();
                          setState(() {
                            isEnable = true;
                          });
                        }
                        });
                      });
                    } else {
                      setState(() {
                        isEnable = true;
                      });
                      EasyLoading.dismiss();
                      G.showPermissionDialog(str: '访问麦克风权限');
                    }
                  });
                }, cancelFunction: () {
                  setState(() {
                    isEnable = true;
                  });
                });
              }, cancelBack: () {
                setState(() {
                  isEnable = true;
                });
                ToastUtil.showToast(
                    "青桐智盒没有获取前台服务权限，无法录制当前设备界面，请授权前台服务后在进行摇号操作");
                return;
              }, iosBack: () {
                // 开始录屏
                showRecordAlert(context, decideFunction: () {
                  G.pop();
                  Permission.microphone.status.isGranted.then((tempValue) {
                    if (!tempValue) {
                      G.showCustomToast(
                        context: context,
                        titleText: "录音权限使用说明：",
                        subTitleText: "用于语音录制等场景",
                        time: 2,
                      );
                    }
                  });
                  Permission.microphone.request().isGranted.then((value) {
                    if (value) {
                      // 开始录屏
                      String fileName =
                          DateTime.now().millisecondsSinceEpoch.toString();
                       EasyLoading.show(status: "录屏准备中，请稍候...");
                       // 延迟5秒后开始录屏，避免页面跳转冲突
                       Future.delayed(const Duration(seconds: 5), () {
                         EasyLoading.show(status: "录屏即将开始");
                         FlutterScreenRecording.startRecordScreen(fileName)
                          .then((data) {
                        wjPrint("started-------$data");
                        if (data) {
                          Future.delayed(const Duration(seconds: 2), () {
                            EasyLoading.dismiss();
                            setState(() {
                              isEnable = true;
                            });
                            G.pushNamed(RoutePaths.notaryExtractWidget,
                                arguments: {
                                  'unitGuid': widget.unitGuid,
                                  'unionnotaritionid': widget.unionnotaritionid,
                                  'userName': widget.userName,
                                  'idCard': widget.idCard,
                                  "notaryName":widget.notaryName
                                });
                          });
                        } else {
                          EasyLoading.dismiss();
                          setState(() {
                            isEnable = true;
                          });
                        }
                        });
                      });
                    } else {
                      setState(() {
                        isEnable = true;
                      });
                      EasyLoading.dismiss();
                      G.showPermissionDialog(str: '访问麦克风权限');
                    }
                  });
                }, cancelFunction: () {
                  setState(() {
                    isEnable = true;
                  });
                });
              });
            } else {
              showRecordAlert(context, decideFunction: () {
                G.pop();
                Permission.microphone.status.isGranted.then((tempValue) {
                  if (!tempValue) {
                    G.showCustomToast(
                      context: context,
                      titleText: "录音权限使用说明：",
                      subTitleText: "用于语音录制等场景",
                      time: 2,
                    );
                  }
                });
                Permission.microphone.request().isGranted.then((value) {
                  if (value) {
                    // 开始录屏
                    String fileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                       EasyLoading.show(status: "录屏准备中，请稍候...");
                       // 延迟5秒后开始录屏，避免页面跳转冲突
                       Future.delayed(const Duration(seconds: 5), () {
                         EasyLoading.show(status: "录屏即将开始");
                         FlutterScreenRecording.startRecordScreen(fileName)
                        .then((data) {
                      wjPrint("started-------$data");
                      if (data) {
                        Future.delayed(const Duration(seconds: 2), () {
                          EasyLoading.dismiss();
                          setState(() {
                            isEnable = true;
                          });
                          G.pushNamed(RoutePaths.notaryExtractWidget,
                              arguments: {
                                'unitGuid': widget.unitGuid,
                                'unionnotaritionid': widget.unionnotaritionid,
                                'userName': widget.userName,
                                'idCard': widget.idCard,
                                "notaryName":widget.notaryName
                              });
                        });
                      } else {
                        EasyLoading.dismiss();
                        setState(() {
                          isEnable = true;
                        });
                      }
                    });
                  });
                } else {
                    setState(() {
                      isEnable = true;
                    });
                    EasyLoading.dismiss();
                    G.showPermissionDialog(str: '访问麦克风权限');
                  }
                });
              }, cancelFunction: () {
                setState(() {
                  isEnable = true;
                });
              });
            }
          } catch (e) {
            LogUtils.writeDataToFilePath("在启动录屏时报错：$e");
          }
        } else {
          searchOrderStatus(callBack: (result){
            if(ObjectUtil.isNotEmpty(result)){
              //	1：未支付 2：支付成功 3：支付进行中 4：无需支付
              if (result['payStatus']==2||result['payStatus']==4){
                Navigator.of(context).pushNamed(RoutePaths.signatureWidget,
                    arguments: {
                      'unitGuid': widget.unitGuid,
                      "fileId": widget.fileId
                    }).then((value) {
                  if (value != null && value.toString().isNotEmpty) {
                    // fileId = value;
                    // getFileInformation();
                    widget.functionCallBack(value);
                    setState(() {
                      buttonStr = "下一步";
                    });
                  }
                });
              }else {
                if (widget.money != 0) {
                  Navigator.of(context).pushNamed(RoutePaths.cashierDesk,
                      arguments: {
                        'money': widget.money,
                        "orderNumber": widget.unitGuid
                      }).then((value) {
                    if (value) {
                      Navigator.of(context)
                          .pushNamed(RoutePaths.signatureWidget, arguments: {
                        'unitGuid': widget.unitGuid,
                        "fileId": widget.fileId
                      }).then((value) {
                        if (value != null && value.toString().isNotEmpty) {
                          // fileId = value;
                          // getFileInformation();
                          widget.functionCallBack(value);
                          setState(() {
                            buttonStr = "下一步";
                          });
                        }
                      });
                    }
                  });
                } else {
                  ToastUtil.showToast("金额有误请联系相关工作人员");
                }
              }
            }else {
              ToastUtil.showErrorToast("服务异常，请稍后再试！");
            }
          });
        }
      },
      child: Text(
        buttonStr,
        key: textKey,
        style: TextStyle(
            fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500),
      ),
    );
  }


  // 查询当前订单是否已支付或者是否需要支付 true:已支付或者不需要支付 false:未支付或者需要支付
 void searchOrderStatus({Function callBack}){
    EasyLoading.show();
    HomeApi.getSingleton().getPayStatus({"unitGuid":widget.unitGuid},errorCallBack: (e){
      ToastUtil.showErrorToast("服务异常，请稍后再试！");
      EasyLoading.dismiss();
    }).then((value){
      EasyLoading.dismiss();
      if (value!=null){
        if ( value["code"]==200){
          callBack.call(value['data']);
        }else {
          ToastUtil.showErrorToast(value["msg"]??value["message"]??value["data"]);
        }
      }else {
        ToastUtil.showErrorToast("服务异常，请稍后再试！");
      }
    });
 }
}

class MyFractionPaginationBuilder extends SwiperPlugin {
  ///color ,if set null , will be Theme.of(context).scaffoldBackgroundColor
  Color color;

  ///color when active,if set null , will be Theme.of(context).primaryColor
  Color activeColor;

  ////font size
  double fontSize;

  ///font size when active
  double activeFontSize;

  Key key;

  MyFractionPaginationBuilder(
      {this.color,
      this.fontSize: 20.0,
      this.key,
      this.activeColor,
      this.activeFontSize: 35.0});

  @override
  Widget build(BuildContext context, SwiperPluginConfig config) {
    ThemeData themeData = Theme.of(context);
    Color activeColor = this.activeColor ?? themeData.primaryColor;
    Color color = this.color ?? themeData.scaffoldBackgroundColor;

    if (Axis.vertical != config.scrollDirection) {
      return new Column(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            "${config.activeIndex + 1}",
            style: TextStyle(color: activeColor, fontSize: activeFontSize),
          ),
          new Text(
            "/",
            style: TextStyle(color: color, fontSize: fontSize),
          ),
          new Text(
            "${config.itemCount}",
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      );
    } else {
      return new Row(
        key: key,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Text(
            "${config.activeIndex + 1}",
            style: TextStyle(color: activeColor, fontSize: activeFontSize),
          ),
          new Text(
            " / ${config.itemCount}",
            style: TextStyle(color: color, fontSize: fontSize),
          )
        ],
      );
    }
  }
}
