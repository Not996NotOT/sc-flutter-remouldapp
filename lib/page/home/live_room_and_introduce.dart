import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/page/home/select_room_module_widget.dart';
import 'package:notarization_station_app/page/home/vm/live_room_and_introduce_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../utils/common_tools.dart';

// ignore: must_be_immutable
class LiveRoomAndIntroduceWidget extends StatefulWidget {
  String roomId;
  LiveRoomAndIntroduceWidget({Key key, this.roomId}) : super(key: key);

  @override
  State<LiveRoomAndIntroduceWidget> createState() =>
      _LiveRoomAndIntroduceWidgetState();
}

class _LiveRoomAndIntroduceWidgetState
    extends BaseState<LiveRoomAndIntroduceWidget> {
  LiveRoomAndIntroduceViewModel _viewModel;

  Timer _timer;

  int time = 5;

  int time2 = 90;

  Timer _timer2;

  List selectData = [
    {'name': '3栋一单元405', 'id': "1", 'isSelected': false},
    {'name': '3栋二单元405', 'id': "2", 'isSelected': false},
    {'name': '3栋三单元405', 'id': "3", 'isSelected': false}
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timmer) {
      time--;
      if (time == -1) {
        _timer.cancel();
      }
      setState(() {});
    });

    _timer2 = Timer.periodic(Duration(seconds: 1), (timmer) {
      time2--;
      if (time2 == -1) {
        time2 = 0;
        _timer2.cancel();
        AlertView.showExitApp(context);
      }
      setState(() {});
    });

    // Future.delayed(Duration(milliseconds: 100), () {
    //   showAlertView(context);
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: commonAppBar(
            title: "直播间介绍",
          ),
          body: WillPopScope(
            onWillPop: () {
              ADialog.confirm(context,
                  content: "是否确认退出直播选房？",
                  cancelButtonText: Text("取消"),
                  confirmButtonText: Text("确认"), cancelButtonPress: () {
                Navigator.of(context).pop();
              }, confirmButtonPress: () {
                _viewModel.destoryRoom();
                G.pop();
                G
                    .getCurrentState()
                    .popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
              });
              return Future.value(false);
            },
            child:
                Consumer<UserViewModel>(builder: (context, userModel, child) {
              return ProviderWidget<LiveRoomAndIntroduceViewModel>(
                builder: (context, vm, child) {
                  return Column(
                    children: [
                      // vm.userList[0]['widget'],
                      _selectionWidget(context),
                    ],
                  );
                },
                model: LiveRoomAndIntroduceViewModel(
                    userViewModel: userModel, roomId: widget.roomId),
                onModelReady: (vm) {
                  _viewModel = vm;
                  vm.initData();
                },
              );
            }),
          ),
          floatingActionButton: Builder(builder: (BuildContext context) {
            return GestureDetector(
              child: Container(
                width: 80.0,
                height: 80.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(40.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 6,
                        spreadRadius: 3,
                        offset: Offset(0, 3))
                  ],
                ),
                child: RichText(
                    text: TextSpan(
                        text: '倒计时 \n',
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w500),
                        children: [
                          TextSpan(
                              text: '$time2秒',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.w500))
                        ]),
                    textAlign: TextAlign.center),
              ),
              onTap: () {},
            );
          }),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        ),
        Offstage(child: showAlertView(), offstage: time == -1 ? true : true),
      ],
    );
  }

  /// 弹框开始选房间
  Widget showAlertView() {
    // showCupertinoDialog(
    //     context: context,
    //     builder: (context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Color(0xFFF4f4f4),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 120,
              height: 120,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(60),
              ),
              child: Text(
                '${time == -1 ? '0' : time}',
                style: TextStyle(
                  fontSize: 60,
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0),
              child: Text(
                '请做好准备开始选房间',
                style: TextStyle(fontSize: 30, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
    // });
  }

  // 切换tab
  Widget _selectionWidget(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color(0xFFF4F4F4), width: 1.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    border: Border(
                  right: BorderSide(color: Color(0xFFF4F4F4), width: 1.0),
                )),
                child: Text(
                  "楼盘介绍",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              onTap: () {
                AlertView.showSelectRoomBottomView(
                    context, selectData, (value) {});
              },
            ),
            flex: 1,
          ),
          Expanded(
            child: GestureDetector(
              child: Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                    border: Border(
                  left: BorderSide(color: Color(0xFFF4F4F4), width: 1.0),
                )),
                child: Text(
                  "房源信息",
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
              onTap: () {
                _showHouseInformationDialog(context);
              },
            ),
            flex: 1,
          ),
        ]),
      ),
    );
  }

  // 选房信息
  _showHouseInformationDialog(BuildContext context) {
    showBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 4 / 5,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 15.0),
                          child: Text(
                            "选房信息",
                            style: TextStyle(
                                fontSize: 18,
                                color: Color(0xFF333333),
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                        top: 15.0,
                        right: 20.0,
                        child: GestureDetector(
                          child: Icon(
                            Icons.close,
                            size: getWidthPx(36),
                            color: Color(0xFF333333),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ))
                  ],
                ),
                Expanded(child: SelectRoomModuleWidget()),
              ],
            ),
          );
        });
  }

  // 楼盘介绍详细信息
  Widget _houseIntroduceInformation() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Html(
            data: _viewModel.dataList[0],
            onLinkTap: (url) {
              wjPrint("Opening $url...");
            },
            onImageTap: (src) {
              wjPrint(src);
            },
            onImageError: (exception, stackTrace) {
              wjPrint(exception);
            },
          )
        ],
      ),
    );
  }
}
