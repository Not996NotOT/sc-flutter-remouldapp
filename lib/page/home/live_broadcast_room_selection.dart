import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/live_broadcast_room_selection_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../appTheme.dart';
import 'entity/data.dart';

class LiveBroadcastRoomSelectionWidget extends StatefulWidget {
  const LiveBroadcastRoomSelectionWidget({Key key}) : super(key: key);

  @override
  State<LiveBroadcastRoomSelectionWidget> createState() =>
      _LiveBroadcastRoomSelectionWidgetState();
}

class _LiveBroadcastRoomSelectionWidgetState
    extends BaseState<LiveBroadcastRoomSelectionWidget> {
  LiveBroadcastRoomSelectionViewModel _selectionViewModel;

  SharedPreferences prefs;

  getCameras() async {
    VideoConferenceData.cameras = await availableCameras();
    prefs = await SharedPreferences.getInstance();
  }

  getVideoConference(int type) {
    String userId =
        "user-${VideoConferenceData.userName}-${VideoConferenceData.userIdCard}";
    VideoConferenceData.id = userId;
  }

  @override
  void initState() {
    super.initState();
    getCameras();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Consumer<UserViewModel>(builder: (context, userViewModel, child) {
        return ProviderWidget(
            builder: (context, liveSelectionViewModel, child) {
              _selectionViewModel = liveSelectionViewModel;
              return Column(
                children: [
                  _topHeaderImageWidget(),
                  Expanded(child: _bottomWidget())
                ],
              );
            },
            model: LiveBroadcastRoomSelectionViewModel(
                userViewModel: userViewModel),
            onModelReady: (liveSelectionViewModel) {
              _selectionViewModel = liveSelectionViewModel;
            });
      }),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  // 顶部的背景图片
  Widget _topHeaderImageWidget() {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(getHeightPx(150))),
        image: DecorationImage(
          image: AssetImage("lib/assets/images/bgcImg.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      height: getHeightPx(600),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Color(0xa5000000),
          borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(getHeightPx(150))),
        ),
        height: getHeightPx(700),
        padding: EdgeInsets.only(left: 20, right: 20, top: 44),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              onTap: () {
                G.pop();
              },
              child: Container(
                alignment: Alignment.centerLeft,
                width: getWidthPx(750),
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              width: getWidthPx(180),
              height: getWidthPx(180),
              margin: EdgeInsets.only(top: getWidthPx(80)),
              padding: EdgeInsets.fromLTRB(0, 5, 3, 0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(getWidthPx(20))),
              ),
              child: Center(
                child: Image.asset('lib/assets/images/logoOne.png',
                    fit: BoxFit.cover),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: getHeightPx(20)),
                child: Text(
                  "青桐智盒直播选房平台",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                )),
            Expanded(
              child: Container(
                margin: EdgeInsets.fromLTRB(getWidthPx(50), getWidthPx(20),
                    getWidthPx(50), getWidthPx(20)),
                child: Text(
                  "        根据南京市司法局批准文件，南京智慧公证研究中心由南京市石城公证处和南京市紫金公证处共同组建，致力于研究开发信息技术，用于辅助公证机构、公证员开展公证活动，以便向人民群众提供更高效、便捷的公证法律服务。",
                  style: TextStyle(fontSize: getSp(18), color: Colors.white),
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(top: getHeightPx(20)),
                child: Text(
                  "Developed by 南京智慧公证研究发展中心",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                )),
          ],
        ),
      ),
    );
  }

  // 底部身份证，姓名及令牌
  Widget _bottomWidget() {
    return Container(
      padding: const EdgeInsets.only(top: 40),
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: getHeightPx(100),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
            ),
            margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
            padding: EdgeInsets.fromLTRB(
                getWidthPx(40), getWidthPx(20), getWidthPx(40), getWidthPx(20)),
            child: Row(
              children: <Widget>[
                Text('名字',
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.right,
                      maxLength: 11,
                      controller: _selectionViewModel.nameController,
                      inputFormatters: [LengthLimitingTextInputFormatter(10)],
                      decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: '请输入的姓名',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: getHeightPx(100),
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
            ),
            margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
            padding: EdgeInsets.fromLTRB(
                getWidthPx(40), getWidthPx(20), getWidthPx(40), getWidthPx(20)),
            child: Row(
              children: <Widget>[
                Text('身份证号',
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextField(
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.right,
                      maxLength: 18,
                      controller: _selectionViewModel.cardController,
                      inputFormatters: [
                        FilteringTextInputFormatter(RegExp("[A-Za-z0-9]"),
                            allow: true),
                        LengthLimitingTextInputFormatter(18)
                      ],
                      decoration: InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                        hintText: '请输入身份证号',
                        hintStyle: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
            ),
            margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
            padding: EdgeInsets.fromLTRB(
                getWidthPx(40), getWidthPx(20), getWidthPx(40), getWidthPx(20)),
            child: Row(
              children: <Widget>[
                Text('令牌',
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.right,
                    textAlignVertical: TextAlignVertical.center,
                    maxLength: 40,
                    controller: _selectionViewModel.tokenController,
                    inputFormatters: [
                      FilteringTextInputFormatter(RegExp("[0-9]"), allow: true),
                      LengthLimitingTextInputFormatter(18)
                    ],
                    decoration: InputDecoration(
                      counterText: "",
                      border: InputBorder.none,
                      hintText: '请输入令牌',
                      hintStyle: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: _selectionViewModel.throttleUtil.throttle(() async {
              await _selectionViewModel.enterDirectSeeding();
            }),
            child: Container(
              width: getWidthPx(670),
              margin: EdgeInsets.fromLTRB(getWidthPx(150), getWidthPx(40),
                  getWidthPx(150), getWidthPx(10)),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(width: 1, color: AppTheme.themeBlue),
                borderRadius: BorderRadius.all(Radius.circular(50)),
              ),
              child: Center(
                child: Text('进入选房直播间',
                    style: TextStyle(fontSize: 16, color: AppTheme.themeBlue)),
              ),
            ),
          ),
          InkWell(
            onTap: _selectionViewModel.throttleUtil.throttle(() async {
              G.pushNamed(RoutePaths.selectRoomHistory);
            }),
            child: Container(
              width: getWidthPx(670),
              margin: EdgeInsets.fromLTRB(getWidthPx(150), getWidthPx(40),
                  getWidthPx(150), getWidthPx(10)),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: AppTheme.themeBlue,
              ),
              child: Center(
                child: Text('选房记录',
                    style: TextStyle(fontSize: 16, color: AppTheme.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
