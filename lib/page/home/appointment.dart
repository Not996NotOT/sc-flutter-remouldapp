import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/appointment_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../appTheme.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends BaseState<AppointmentPage> {
  AppointmentViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  void beginVideoConnect(Map item){
    if (item['notaryPublicName'] != null &&
        item['notaryPublicName'] != "") {
      showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content: const Text(
                "我已与公证员确认当前时间进行视频公证，即将向公证员发起订单"),
            actions: <Widget>[
              // ignore: deprecated_member_use
              TextButton(
                child: const Text("取消"),
                onPressed: () =>
                    Navigator.of(context).pop(), // 关闭对话框
              ),
              // ignore: deprecated_member_use
              TextButton(
                child: const Text("确定"),
                onPressed: () async {
                  if(!await Permission.camera.status.isGranted || !await Permission.speech.status.isGranted || !await Permission.storage.status.isGranted){
                    G.showCustomToast(
                        context: context,
                        titleText: "相机、麦克风、存储权限说明：",
                        subTitleText: "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                        time: 2
                    );
                  }
                  //关闭对话框并返回true
                  final status =
                  await Permission.speech.request();
                  if (status ==
                      PermissionStatus.granted) {
                    final cameraS =
                    await Permission.camera.request();
                    if (cameraS ==
                        PermissionStatus.granted) {
                      final storageS = await Permission
                          .storage
                          .request();
                      if (storageS ==
                          PermissionStatus.granted) {
                        Navigator.of(context).pop(true);
                        viewModel.selectMap = item;
                        viewModel.addOrder(item);
                      } else {
                        G.showPermissionDialog(
                            str: "访问内部存储权限");
                      }
                    } else {
                      G.showPermissionDialog(
                          str: "访问内部相机、相册权限");
                    }
                  } else {
                    G.showPermissionDialog(
                        str: "访问内部语音麦克风权限");
                  }
                },
              ),
            ],
          );
        },
      );
    } else {
      ToastUtil.showErrorToast("该公证员已不在受理业务，请重新发起预约");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: commonAppBar(title: "预约公证"),
        body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
          return ProviderWidget<AppointmentViewModel>(
              model: AppointmentViewModel(userModel),
              onModelReady: (model) {
                viewModel = model;
                model.getAppointmentLists();
                model.getLocation();
              },
              builder: (ctx, helpModel, child) {
                return Column(
                  children: [
                    Expanded(
                      child: ColoredBox(
                          color: Color.fromRGBO(247, 247, 247, 1),
                          child: helpModel.busy
                              ? loadingWidget()
                              : viewModel.appointmentLists.length > 0
                                  ? SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      header: HomeRefreshHeader(Colors.black),
                                      footer: RefresherFooter(),
                                      controller: helpModel.refreshController,
                                      onRefresh: helpModel.refresh,
                                      onLoading: helpModel.loadMore,
                                      child: ListView.builder(
                                        itemBuilder: (context, index) {
                                          return _listItem(viewModel
                                              .appointmentLists[index]);
                                        },
                                        itemCount:
                                            viewModel.appointmentLists.length,
                                      ))
                                  : const Center(
                                      child: Text(
                                        "暂无预约",
                                      ),
                                    )),
                    ),
                    DebounceButton(
                      clickTap: () {
                        viewModel.isEnable = false;
                        viewModel.notifyListeners();
                        Navigator.pushNamed(context, RoutePaths.AddAppointment)
                            .then((value) {
                          viewModel.isEnable = true;
                          viewModel.notifyListeners();
                          viewModel.refresh();
                        });
                      },
                      isEnable: viewModel.isEnable,
                      margin: EdgeInsets.fromLTRB(
                          getWidthPx(40),
                          getWidthPx(10),
                          getWidthPx(40),
                          getWidthPx(10) +
                              MediaQuery.of(context).padding.bottom),
                      padding: EdgeInsets.all(10),
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      child: const Text('新增预约',
                          style: TextStyle(
                              fontSize: 16, color: AppTheme.nearlyWhite)),
                    )
                  ],
                );
              });
        }));
  }

  /// list item
  Widget _listItem(Map item) {
    return Container(
      color: Colors.white,
      margin: EdgeInsets.fromLTRB(0, 0, 0, getWidthPx(20)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: getWidthPx(700),
            margin: EdgeInsets.fromLTRB(
                getWidthPx(20), getWidthPx(30), getWidthPx(20), getWidthPx(0)),
            child: Row(
              children: <Widget>[
                const Text(
                  "公证处:",
                  style: TextStyle(
                    color: Color.fromRGBO(195, 195, 195, 1),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                    child: Text(
                  "${item['notaryName']}",
                  overflow: TextOverflow.ellipsis,
                )),
                Text(
                  item['status'] == 0
                      ? "待公证员确认"
                      : item['status'] == 1
                          ? "预约成功"
                          : item['status'] == 2
                              ? "已结束"
                              : "已取消",
                  style: TextStyle(
                    color: item['status'] == 0
                        ? Colors.red
                        : item['status'] == 1
                            ? Colors.green
                            : Colors.black45,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: getWidthPx(700),
            margin: EdgeInsets.fromLTRB(
                getWidthPx(20), getWidthPx(30), getWidthPx(20), getWidthPx(0)),
            child: Row(
              children: <Widget>[
                const Text(
                  "时间:",
                  style: TextStyle(
                    color: Color.fromRGBO(195, 195, 195, 1),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${item['processingTime'] ?? ''}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                item['status'] == 1
                    ? DebounceButton(
                        clickTap: () {
                          if(G.isGranted==1){
                            beginVideoConnect(item);
                          }else{
                          G.requestForegroundService(decideBack:
                          () async {
                            beginVideoConnect(item);
                          }, cancelBack:
                          () async{
                            beginVideoConnect(item);
                          }, iosBack:
                          () async {
                            beginVideoConnect(item);
                          });
                          }
                        },
                        isEnable: viewModel.selectMap.isEmpty
                            ? true
                            : (viewModel.selectMap["notaryId"] ==
                                    item['notaryId']
                                ? false
                                : true),
                        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                        backgroundColor: Colors.green,
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: const Text('开始公证',
                            style: TextStyle(color: AppTheme.nearlyWhite)),
                      )
                    : SizedBox()
              ],
            ),
          ),
          Container(
            width: getWidthPx(700),
            margin: EdgeInsets.fromLTRB(
                getWidthPx(20), getWidthPx(30), getWidthPx(20), getWidthPx(20)),
            child: Row(
              children: <Widget>[
                const Text(
                  "备注:",
                  style: TextStyle(
                    color: Color.fromRGBO(195, 195, 195, 1),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Text("${item['remarks'] ?? ''}",
                      overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
