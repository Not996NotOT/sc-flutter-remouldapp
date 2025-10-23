import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/entity/data.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VideoConferencePage extends StatefulWidget {
  @override
  _VideoConferencePageState createState() => _VideoConferencePageState();
}

class _VideoConferencePageState extends BaseState<VideoConferencePage> {
  List conferenceList = [];
  List conferenceHistoryList = [];
  RefreshController refreshController = RefreshController();

  TextEditingController nameController = TextEditingController();
  TextEditingController cardController = TextEditingController();
  TextEditingController tokenController = TextEditingController();
  SharedPreferences prefs;

  bool isEnable = true;

  @override
  void initState() {
    super.initState();
    nameController.text = "";
    cardController.text = "";
    tokenController.text = "";
    getCameras();
  }

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
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              width: getWidthPx(750),
              height: getHeightPx(1334) - MediaQuery.of(context).padding.top,
              child: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
                return Column(
                  children: <Widget>[
                    Stack(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(getHeightPx(150))),
                            image: DecorationImage(
                              image: AssetImage("lib/assets/images/bgcImg.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          height: getHeightPx(700),
                        ),
                        Align(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Color(0xa5000000),
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(getHeightPx(150))),
                            ),
                            height: getHeightPx(700),
                            padding:
                                EdgeInsets.only(left: 20, right: 20, top: 44),
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
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(getWidthPx(20))),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                        'lib/assets/images/logoOne.png',
                                        fit: BoxFit.cover),
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: getHeightPx(20)),
                                    child: Text(
                                      "青桐智盒视频会议平台",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 28),
                                    )),
                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        getWidthPx(50),
                                        getWidthPx(20),
                                        getWidthPx(50),
                                        getWidthPx(20)),
                                    child: Text(
                                      "        根据南京市司法局批准文件，南京智慧公证研究中心由南京市石城公证处和南京市紫金公证处共同组建，致力于研究开发信息技术，用于辅助公证机构、公证员开展公证活动，以便向人民群众提供更高效、便捷的公证法律服务。",
                                      style: TextStyle(
                                          fontSize: getSp(18),
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.only(top: getHeightPx(20)),
                                    child: Text(
                                      "Developed by 南京智慧公证研究发展中心",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    )),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: getHeightPx(80)),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            height: getHeightPx(100),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: AppTheme.bg_c)),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: getWidthPx(10)),
                            padding: EdgeInsets.fromLTRB(getWidthPx(40),
                                getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                            child: Row(
                              children: <Widget>[
                                Text('名字',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87)),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: TextField(
                                      keyboardType: TextInputType.text,
                                      textAlign: TextAlign.right,
                                      maxLength: 11,
                                      controller: nameController,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(10)
                                      ],
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
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: AppTheme.bg_c)),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: getWidthPx(10)),
                            padding: EdgeInsets.fromLTRB(getWidthPx(40),
                                getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                            child: Row(
                              children: <Widget>[
                                Text('身份证号',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87)),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: TextField(
                                      keyboardType: TextInputType.emailAddress,
                                      textAlign: TextAlign.right,
                                      maxLength: 18,
                                      controller: cardController,
                                      inputFormatters: [
                                        FilteringTextInputFormatter(
                                            RegExp("[A-Za-z0-9]"),
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
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1, color: AppTheme.bg_c)),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: getWidthPx(10)),
                            padding: EdgeInsets.fromLTRB(getWidthPx(40),
                                getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                            child: Row(
                              children: <Widget>[
                                Text('令牌',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.black87)),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.right,
                                    textAlignVertical: TextAlignVertical.center,
                                    maxLength: 40,
                                    controller: tokenController,
                                    inputFormatters: [
                                      FilteringTextInputFormatter(
                                          RegExp("[0-9]"),
                                          allow: true),
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
                          DebounceButton(
                            clickTap: () async {
                              if(!await Permission.camera.status.isGranted || !await Permission.speech.status.isGranted || !await Permission.storage.status.isGranted){
                                G.showCustomToast(
                                    context: context,
                                    titleText: "相机、麦克风、存储权限说明：",
                                    subTitleText: "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                                    time: 2
                                );
                              }
                              if (await Permission.camera.request().isGranted &&
                                  await Permission.speech.request().isGranted &&
                                  await Permission.storage
                                      .request()
                                      .isGranted) {
                                if (nameController.text.isEmpty ||
                                    cardController.text.isEmpty ||
                                    tokenController.text.isEmpty) {
                                  ToastUtil.showOtherToast("姓名、身份证、令牌不能为空");
                                } else {
                                  setState(() {
                                    isEnable = false;
                                  });
                                  EasyLoading.show();
                                  Map<String, dynamic> data = {
                                    "userName": nameController.text,
                                    "idCard": cardController.text,
                                    "tokenVerification": tokenController.text
                                  };

                                  HomeApi.getSingleton().postConference(data,
                                      errorCallBack: (e) {
                                    EasyLoading.dismiss();
                                    setState(() {
                                      isEnable = true;
                                    });
                                  }).then((res) {
                                    EasyLoading.dismiss();
                                    setState(() {
                                      isEnable = true;
                                    });
                                    print("....1111....$res");
                                    if (res['code'] == 200) {
                                      VideoConferenceData.token =
                                          res['item']['token'];
                                      VideoConferenceData.userId =
                                          res['item']['userId'];
                                      VideoConferenceData.userType =
                                          res['item']['userType'];
                                      VideoConferenceData.meetTitle =
                                          res['item']['meetTitle'];
                                      VideoConferenceData.userName =
                                          nameController.text;
                                      VideoConferenceData.userIdCard =
                                          cardController.text;
                                      VideoConferenceData.roomId =
                                          tokenController.text;
                                      VideoConferenceData.mute =
                                          res['item']['banSpeech'];
                                      getVideoConference(
                                          VideoConferenceData.userType);
                                      if (userModel.idCard == null) {
                                        MqttClientMsg.instance
                                            .connect(cardController.text);
                                      }
                                      G.pushNamed(RoutePaths.FaceFail);
                                      //G.pushNamed(RoutePaths.ConferenceIng);
                                      if (prefs.getString("token") == null) {
                                        prefs.setString("token",
                                            "${VideoConferenceData.roomId}${cardController.text}");
                                      } else {
                                        if ("${VideoConferenceData.roomId}${cardController.text}" !=
                                            prefs.getString("token")) {
                                          prefs.remove("token");
                                          // prefs.remove("startVote");
                                          // prefs.remove("isSignature");
                                          prefs.setString("token",
                                              "${VideoConferenceData.roomId}${cardController.text}");
                                        }
                                      }
                                    } else {
                                      ToastUtil.showOtherToast(res['msg']);
                                    }
                                  });
                                }
                              } else {
                                G.showPermissionDialog(
                                    str: "访问内部存储、语音麦克风、相机、相册权限");
                              }
                            },
                            isEnable: isEnable,
                            backgroundColor: Colors.transparent,
                            disableColor: Colors.transparent,
                            padding: EdgeInsets.fromLTRB(getWidthPx(150), 0,
                                getWidthPx(150), getWidthPx(10)),
                            child: Container(
                              width: getWidthPx(670),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1, color: AppTheme.themeBlue),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                              ),
                              child: Center(
                                child: const Text('进入会议',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.themeBlue)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          )),
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }
}
