import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/activity_indicator.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/generated/json/Notarial_status_model.dart';
import 'package:notarization_station_app/page/home/vm/video_view_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/bottom_alert_search_list.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../utils/common_tools.dart';

class VideoNotarizePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return VideoNotarizePageState();
  }
}

class VideoNotarizePageState extends BaseState<VideoNotarizePage> {
  VideoViewModel videoVm;
  UserViewModel userInfo;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    videoVm.timer1?.cancel();
    videoVm.timer2?.cancel();
    videoVm.timer3?.cancel();
  }

  Future<void> changeLanguage() async {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return BottomAlertSearchList(
            holderString: "请输入你要搜索的公证处",
            selectValueCallBack: (value) {
              wjPrint("value---------$value");
              videoVm.notarialList.forEach((element) {
                if (element.notarialName == value) {
                  videoVm.notarialUpdate(element);
                }
              });
            },
            dataSource: videoVm.notarialOfficeNameList,
          );
        });
  }

  // 开始公证弹窗
  showBeginNotarizeAlertWidget(bool isSuccess) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: ()async{
              return Future.value(false);
            },
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: Container(
                  height: getWidthPx(540),
                  width: getWidthPx(600),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        'lib/assets/images/mqt_send_alert.png',
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: getWidthPx(120), bottom: getWidthPx(40)),
                        child: isSuccess
                            ? ActivityIndicator()
                            : Image.asset(
                                'lib/assets/images/connect_failure.png',
                                width: getWidthPx(70),
                                height: getWidthPx(70),
                              ),
                      ),
                      Text(
                        isSuccess ? '视频连线中' : '连接失败',
                        style: TextStyle(
                            fontSize: getSp(40), fontWeight: FontWeight.w500),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: getWidthPx(26),
                            bottom: getWidthPx(60),
                            left: getWidthPx(30),
                            right: getWidthPx(30)),
                        child: Text(
                          isSuccess
                              ? "请耐心等待，不要离开本页"
                              : '该公证员忙碌中,\n请更换其他公证员受理或稍后重试',
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: TextStyle(fontSize: getSp(26)),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          videoVm.changeButtonState();
                          if (isSuccess) {
                            videoVm.timer2.cancel();
                            videoVm.sendNotarizeRequest(
                                cardId: videoVm.notarialStatusModel.idCard,
                                type: 2);
                            videoVm.notarialStatusModel = null;
                          }else {
                            videoVm.notarialStatusModel = null;
                          }
                        },
                        child: Container(
                          width: getWidthPx(240),
                          height: getWidthPx(72),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(
                                      'lib/assets/images/btn_blue_image.png'))),
                          child: Text(
                            '取消',
                            style: TextStyle(
                                fontSize: getSp(30), color: AppTheme.white),
                          ),
                        ),
                      ),
                      const Spacer()
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
        if (videoVm != null) {
          videoVm.getNotarialOfficeList();
        }
      },
      child: Scaffold(
        appBar: commonAppBar(title: "视频公证"),
        body: WillPopScope(
          onWillPop: () async {
            return Future.value(false);
          },
          child: Consumer<UserViewModel>(
            builder: (ctx, userModel, child) {
              userInfo = userModel;
              return ProviderWidget<VideoViewModel>(
                  model: VideoViewModel(userModel),
                  onModelReady: (model) {
                    videoVm = model;
                    model.initData();
                  },
                  builder: (ctx, vm, child) {
                    return SingleChildScrollView(
                      child: Container(
                        color: Color(0xfff2f5fa),
                        width: getWidthPx(750),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: getHeightPx(20),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: getWidthPx(30)),
                              child: const Text(
                                '办理机构',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xff5496e0)),
                              ),
                            ),
                            SizedBox(
                              height: getHeightPx(20),
                            ),
                            Container(
                              height: getHeightPx(100),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    getWidthPx(40), 0, getWidthPx(20), 0),
                                child: InkWell(
                                  onTap: () async {
                                    AlertView.showCityPickerView(context,
                                        resultCallBack: (CityResult msg) {
                                      wjPrint(
                                          "showCityPickerView/位置信息：-----$msg");
                                      if (msg != null) {
                                        vm.city = "${msg.province} ${msg.city}";
                                        vm.adCode = "${msg.cityCode}";
                                        vm.getNotarial();
                                        vm.notifyListeners();
                                        vm.notarialInfo = null;
                                      }
                                    }, locationCode: '320100');
                                    // Result result =
                                    //     await CityPickers.showCityPicker(
                                    //   context: context,
                                    //   height: 300.0,
                                    //   locationCode: '320100',
                                    //   showType: ShowType.pc,
                                    // );
                                    // wjPrint("位置信息：-----$result");
                                    // if (result != null) {
                                    //   vm.city =
                                    //       "${result.provinceName} ${result.cityName}";
                                    //   vm.adCode = "${result.cityId}";
                                    //   vm.getNotarial();
                                    //   vm.notifyListeners();
                                    //   vm.notarialInfo = null;
                                    // }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text('当前城市',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87)),
                                      ),
                                      Text(
                                        vm.city ?? '请点击选择',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.Text_min),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: AppTheme.Text_min,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: getHeightPx(100),
                              color: Colors.white,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    getWidthPx(40), 0, getWidthPx(20), 0),
                                child: InkWell(
                                  onTap: () {
                                    if (vm.notarialList.length != 0) {
                                      changeLanguage();
                                    } else {
                                      ToastUtil.showErrorToast("该城市无可办理公证的公证处");
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      const Expanded(
                                        child: Text('公证处',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black87)),
                                      ),
                                      Text(
                                        vm.notarialInfo == null
                                            ? '请点击选择'
                                            : vm.notarialInfo['notarialName'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.Text_min),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: AppTheme.Text_min,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: getWidthPx(20)),
                              child: Row(
                                children: [
                                  const Text(
                                    '选择公证员',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xff5496e0)),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: videoVm.secondCount == 10
                                        ? () {
                                            videoVm
                                                .autoRefreshGetListNotaryStatusData();
                                          }
                                        : null,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          right: getWidthPx(40),
                                          top: getHeightPx(20),
                                          bottom: getHeightPx(20),
                                          left: getWidthPx(30)),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.refresh,
                                            size: 20,
                                            color: videoVm.secondCount == 10
                                                ? AppTheme.themeBlue
                                                : Colors.grey,
                                          ),
                                          Text(
                                            '刷新',
                                            style: TextStyle(
                                                fontSize: getSp(28),
                                                color: videoVm.secondCount == 10
                                                    ? AppTheme.themeBlue
                                                    : Colors.grey,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: getWidthPx(30),
                                        top: getHeightPx(20),
                                        bottom: getHeightPx(20)),
                                    child: Text(
                                      vm.notarialInfo == null
                                          ? ''
                                          : vm.notarialInfo['notarialName'],
                                      style: TextStyle(
                                          fontSize: getSp(32),
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  vm.notarialStatusList.isNotEmpty
                                      ? MediaQuery.removePadding(
                                          context: context,
                                          removeTop: true,
                                          removeBottom: true,
                                          child: ListView.builder(
                                              itemCount: videoVm
                                                  .notarialStatusList.length,
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemBuilder: (context, index) {
                                                NotarialStatusModel model =
                                                    videoVm.notarialStatusList[
                                                        index];
                                                wjPrint("model-------${model.toJson()}");
                                                return Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: AppTheme.bg_e),
                                                    ),
                                                  ),
                                                  padding: EdgeInsets.only(
                                                      bottom: getHeightPx(20),
                                                      top: getHeightPx(20),
                                                      left: getWidthPx(40),
                                                      right: getWidthPx(30)),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                        model.currentState == 0
                                                            ? 'lib/assets/images/online_headIcon_light.png'
                                                            : "lib/assets/images/free_headIcon_grey.png",
                                                        width: getWidthPx(92),
                                                        height:
                                                            getHeightPx(100),
                                                      ),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            8.0),
                                                                child: Text(
                                                                  '公证员：${model.userName}',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                      fontSize:
                                                                          getSp(
                                                                              32)),
                                                                ),
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text('状态：',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w400,
                                                                          fontSize:
                                                                              getSp(32))),
                                                                  Image.asset(
                                                                    model.currentState ==
                                                                            0
                                                                        ? 'lib/assets/images/online_light_icon.png'
                                                                        : "lib/assets/images/free_grey_icon.png",
                                                                    width:
                                                                        getWidthPx(
                                                                            30),
                                                                    height:
                                                                        getHeightPx(
                                                                            30),
                                                                  ),
                                                                  Text(
                                                                    '${model.currentState == 0 ? " 空闲" : " 忙碌"}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            getWidthPx(
                                                                                30),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Color(model.currentState ==
                                                                                0
                                                                            ? 0xFF36BC9E
                                                                            : 0xFF999999)),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap:
                                                            model.currentState ==
                                                                        0 &&
                                                                    model
                                                                        .isVideo
                                                                ? () async {
                                                                    if(G.isGranted==1){
                                                                      videoVm
                                                                          .notarialStatusList[
                                                                      index]
                                                                          .isVideo = false;
                                                                      videoVm
                                                                          .notifyListeners();
                                                                      EasyLoading
                                                                          .show();
                                                                      if (!await Permission.camera.status.isGranted ||
                                                                          !await Permission
                                                                              .speech
                                                                              .status
                                                                              .isGranted ||
                                                                          !await Permission
                                                                              .storage
                                                                              .status
                                                                              .isGranted) {
                                                                        G.showCustomToast(
                                                                            context:
                                                                            context,
                                                                            titleText:
                                                                            "相机、麦克风、存储权限说明：",
                                                                            subTitleText:
                                                                            "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                                                                            time:
                                                                            2);
                                                                      }
                                                                      if (await Permission.camera.request().isGranted &&
                                                                          await Permission
                                                                              .speech
                                                                              .request()
                                                                              .isGranted &&
                                                                          await Permission
                                                                              .storage
                                                                              .request()
                                                                              .isGranted) {
                                                                        videoVm.notarialStatusModel =
                                                                            model;
                                                                        videoVm.addOrder(
                                                                            cardId: model.idCard,
                                                                            notaryPublicId: model.unitGuid,
                                                                            type: 1,
                                                                            success: () {
                                                                              showBeginNotarizeAlertWidget(true);
                                                                            },
                                                                            failure: () {
                                                                              Navigator.pop(context);
                                                                              videoVm.sendNotarizeRequest(cardId: videoVm.notarialStatusModel.idCard, type: 2);
                                                                              showBeginNotarizeAlertWidget(false);
                                                                            });
                                                                      } else {
                                                                        videoVm
                                                                            .notarialStatusList[index]
                                                                            .isVideo = true;
                                                                        videoVm
                                                                            .notifyListeners();
                                                                        EasyLoading
                                                                            .dismiss();
                                                                        G.showPermissionDialog(
                                                                            str:
                                                                            "访问内部存储、语音麦克风、相机、相册权限");
                                                                      }
                                                                    }else{
                                                                      G.requestForegroundService(decideBack:
                                                                          () async {
                                                                        videoVm
                                                                            .notarialStatusList[
                                                                        index]
                                                                            .isVideo = false;
                                                                        videoVm
                                                                            .notifyListeners();
                                                                        EasyLoading
                                                                            .show();
                                                                        if (!await Permission.camera.status.isGranted ||
                                                                            !await Permission
                                                                                .speech
                                                                                .status
                                                                                .isGranted ||
                                                                            !await Permission
                                                                                .storage
                                                                                .status
                                                                                .isGranted) {
                                                                          G.showCustomToast(
                                                                              context:
                                                                              context,
                                                                              titleText:
                                                                              "相机、麦克风、存储权限说明：",
                                                                              subTitleText:
                                                                              "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                                                                              time:
                                                                              2);
                                                                        }
                                                                        if (await Permission.camera.request().isGranted &&
                                                                            await Permission
                                                                                .speech
                                                                                .request()
                                                                                .isGranted &&
                                                                            await Permission
                                                                                .storage
                                                                                .request()
                                                                                .isGranted) {
                                                                          videoVm.notarialStatusModel =
                                                                              model;
                                                                          videoVm.addOrder(
                                                                              cardId: model.idCard,
                                                                              notaryPublicId: model.unitGuid,
                                                                              type: 1,
                                                                              success: () {
                                                                                showBeginNotarizeAlertWidget(true);
                                                                              },
                                                                              failure: () {
                                                                                Navigator.pop(context);
                                                                                videoVm.sendNotarizeRequest(cardId: videoVm.notarialStatusModel.idCard, type: 2);
                                                                                showBeginNotarizeAlertWidget(false);
                                                                              });
                                                                        } else {
                                                                          videoVm
                                                                              .notarialStatusList[index]
                                                                              .isVideo = false;
                                                                          videoVm
                                                                              .notifyListeners();
                                                                          EasyLoading
                                                                              .dismiss();
                                                                          G.showPermissionDialog(
                                                                              str:
                                                                              "访问内部存储、语音麦克风、相机、相册权限");
                                                                        }
                                                                      }, cancelBack:
                                                                          () async{
                                                                            videoVm
                                                                                .notarialStatusList[
                                                                            index]
                                                                                .isVideo = false;
                                                                            videoVm
                                                                                .notifyListeners();
                                                                            EasyLoading
                                                                                .show();
                                                                            if (!await Permission.camera.status.isGranted ||
                                                                            !await Permission
                                                                                .speech
                                                                                .status
                                                                                .isGranted ||
                                                                            !await Permission
                                                                                .storage
                                                                                .status
                                                                                .isGranted) {
                                                                              G.showCustomToast(
                                                                                  context:
                                                                                  context,
                                                                                  titleText:
                                                                                  "相机、麦克风、存储权限说明：",
                                                                                  subTitleText:
                                                                                  "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                                                                                  time:
                                                                                  2);
                                                                            }
                                                                            if (await Permission.camera.request().isGranted &&
                                                                            await Permission
                                                                                .speech
                                                                                .request()
                                                                                .isGranted &&
                                                                            await Permission
                                                                                .storage
                                                                                .request()
                                                                                .isGranted) {
                                                                            videoVm.notarialStatusModel =
                                                                            model;
                                                                            videoVm.addOrder(
                                                                            cardId: model.idCard,
                                                                            notaryPublicId: model.unitGuid,
                                                                            type: 1,
                                                                            success: () {
                                                                            showBeginNotarizeAlertWidget(true);
                                                                            },
                                                                            failure: () {
                                                                            Navigator.pop(context);
                                                                            videoVm.sendNotarizeRequest(cardId: videoVm.notarialStatusModel.idCard, type: 2);
                                                                            showBeginNotarizeAlertWidget(false);
                                                                            });
                                                                            } else {
                                                                            videoVm
                                                                                .notarialStatusList[index]
                                                                                .isVideo = false;
                                                                            videoVm
                                                                                .notifyListeners();
                                                                            EasyLoading
                                                                                .dismiss();
                                                                            G.showPermissionDialog(
                                                                            str:
                                                                            "访问内部存储、语音麦克风、相机、相册权限");
                                                                            }
                                                                      }, iosBack:
                                                                          () async {
                                                                        videoVm
                                                                            .notarialStatusList[
                                                                        index]
                                                                            .isVideo = false;
                                                                        videoVm
                                                                            .notifyListeners();
                                                                        EasyLoading
                                                                            .show();
                                                                        if (!await Permission.camera.status.isGranted ||
                                                                            !await Permission
                                                                                .speech
                                                                                .status
                                                                                .isGranted ||
                                                                            !await Permission
                                                                                .storage
                                                                                .status
                                                                                .isGranted) {
                                                                          G.showCustomToast(
                                                                              context:
                                                                              context,
                                                                              titleText:
                                                                              "相机、麦克风、存储权限说明：",
                                                                              subTitleText:
                                                                              "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                                                                              time:
                                                                              2);
                                                                        }
                                                                        if (await Permission.camera.request().isGranted &&
                                                                            await Permission
                                                                                .speech
                                                                                .request()
                                                                                .isGranted &&
                                                                            await Permission
                                                                                .storage
                                                                                .request()
                                                                                .isGranted) {
                                                                          videoVm.notarialStatusModel =
                                                                              model;
                                                                          videoVm.addOrder(
                                                                              cardId: model.idCard,
                                                                              notaryPublicId: model.unitGuid,
                                                                              type: 1,
                                                                              success: () {
                                                                                showBeginNotarizeAlertWidget(true);
                                                                              },
                                                                              failure: () {
                                                                                Navigator.pop(context);
                                                                                videoVm.sendNotarizeRequest(cardId: videoVm.notarialStatusModel.idCard, type: 2);
                                                                                showBeginNotarizeAlertWidget(false);
                                                                              });
                                                                        } else {
                                                                          videoVm
                                                                              .notarialStatusList[index]
                                                                              .isVideo = false;
                                                                          videoVm
                                                                              .notifyListeners();
                                                                          EasyLoading
                                                                              .dismiss();
                                                                          G.showPermissionDialog(
                                                                              str:
                                                                              "访问内部存储、语音麦克风、相机、相册权限");
                                                                        }
                                                                      });
                                                                    }
                                                                  }
                                                                : null,
                                                        child: Container(
                                                          width:
                                                              getWidthPx(220),
                                                          height:
                                                              getHeightPx(60),
                                                          margin:
                                                              EdgeInsets.only(
                                                                  right: 10,
                                                                  left: 5),
                                                          alignment:
                                                              Alignment.center,
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          getWidthPx(
                                                                              10)),
                                                              color: model.currentState ==
                                                                          0 &&
                                                                      model
                                                                          .isVideo
                                                                  ? AppTheme
                                                                      .themeBlue
                                                                  : Color(
                                                                      0xFF999999)),
                                                          child: Text(
                                                            '开始公证',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    getSp(28),
                                                                color: AppTheme
                                                                    .white),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              }),
                                        )
                                      : Container(),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            },
          ),
        ),
      ),
    );
  }
}
