import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../config.dart';

class MinePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MinePageState();
  }
}

class _MinePageState extends BaseState<MinePage> {
  TelAndSmsService _service = locator<TelAndSmsService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return Container(
            color: AppTheme.chipBackground,
            width: getWidthPx(750),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Stack(
                  children: [
                    Container(
                      height: getWidthPx(533),
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        image: DecorationImage(
                          image: AssetImage("lib/assets/images/minebg.png"),
                          fit: BoxFit.cover,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                top: MediaQueryData.fromWindow(window)
                                        .padding
                                        .top +
                                    8,
                                bottom: 15),
                            alignment: Alignment.center,
                            color: Colors.transparent,
                            child: Text(
                              "个人中心",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (!userModel.hasUser) {
                                Navigator.pushNamed(context, RoutePaths.LOGIN);
                              }
                            },
                            child: Container(
                              width: getWidthPx(162),
                              height: getWidthPx(162),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.all(
                                    Radius.circular(getWidthPx(81))),
                                border: Border.all(
                                    width: getWidthPx(10), color: Colors.white),
                              ),
                              child: ClipOval(
                                  child: FadeInImage.assetNetwork(
                                placeholder: 'lib/assets/images/on-boy.jpg',
                                image: userModel.hasUser
                                    ? Config.splicingImageUrl(
                                            userModel.headIcon) ??
                                        ""
                                    : "",
                                fit: BoxFit.fill,
                              )),
                            ),
                          ),
                          Offstage(
                            offstage: !userModel.hasUser,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: getWidthPx(10),
                                ),
                                Text(
                                  userModel.hasUser
                                      ? userModel.userName == null ||
                                              userModel.userName == ""
                                          ? "用户${userModel.mobile}"
                                          : userModel.userName
                                      : "",
                                  style: TextStyle(
                                      fontSize: getWidthPx(36),
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: getWidthPx(10),
                                ),
                                userModel.hasUser
                                    ? InkWell(
                                        onTap: () {
                                          if (userModel.hasUser) {
                                            if (userModel.idCard == null ||
                                                userModel.idCard == "") {
                                              return ToastUtil.showWarningToast(
                                                  "请先实名认证后，再进行操作");
                                            }
                                            Navigator.pushNamed(
                                                context, RoutePaths.MineInfo);
                                          } else {
                                            // ToastUtil.showErrorToast("请先登录！");
                                            G
                                                .getCurrentState()
                                                .pushNamedAndRemoveUntil(
                                                    RoutePaths.LOGIN,
                                                    (router) => router == null,
                                                    arguments: {
                                                  'isMine': true
                                                });
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "个人资料",
                                              style: TextStyle(
                                                fontSize: getWidthPx(30),
                                                color: AppTheme.textBlue_2,
                                              ),
                                            ),
                                            Image.asset(
                                              "lib/assets/images/more.png",
                                              width: getWidthPx(26),
                                              height: getWidthPx(26),
                                            )
                                          ],
                                        ),
                                      )
                                    : SizedBox(),
                              ],
                            ),
                          ),
                          Offstage(
                            offstage: userModel.hasUser,
                            child: InkWell(
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(
                                      "立即登录",
                                      style: TextStyle(
                                          fontSize: getSp(36),
                                          color: Colors.black45,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                G.getCurrentState().pushNamedAndRemoveUntil(
                                    RoutePaths.LOGIN,
                                    (router) => router == null,
                                    arguments: {'isMine': true});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: getWidthPx(180),
                      top: getWidthPx(180),
                      child: Offstage(
                          offstage: userModel.hasUser
                              ? userModel.idCard == null ||
                                      userModel.idCard == ""
                                  ? true
                                  : false
                              : true,
                          child: Image.asset(
                            "lib/assets/images/Certified.png",
                            width: getWidthPx(100),
                          )),
                    )
                  ],
                ),
                Expanded(
                    child: SingleChildScrollView(child: bodyList(userModel)))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget bodyList(UserViewModel user) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: getWidthPx(32)),
          padding: EdgeInsets.only(
              left: getWidthPx(40),
              right: getWidthPx(20),
              top: getWidthPx(30),
              bottom: getWidthPx(30)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10),
              )),
          child: InkWell(
            onTap: () {
              if (user.hasUser) {
                if (user.idCard == null || user.idCard == "") {
                  return ToastUtil.showWarningToast("请先实名认证后，再进行操作");
                }
                user.currentIndex = 1;
              } else {
                // ToastUtil.showErrorToast("请先登录！");
                G.getCurrentState().pushNamedAndRemoveUntil(
                    RoutePaths.LOGIN, (router) => router == null,
                    arguments: {'isMine': true});
              }
            },
            child: Row(
              children: <Widget>[
                Image.asset(
                  "lib/assets/images/per_order.png",
                  width: getWidthPx(40),
                  height: getWidthPx(40),
                ),
                SizedBox(
                  width: getWidthPx(20),
                ),
                Expanded(
                  child: Text('我的订单',
                      style:
                          TextStyle(fontSize: 16, color: AppTheme.textBlack)),
                ),
                Image.asset(
                  "lib/assets/images/more.png",
                  width: getWidthPx(26),
                  height: getWidthPx(26),
                ),
                SizedBox(
                  width: getWidthPx(20),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: getWidthPx(32)),
          padding: EdgeInsets.only(
              left: getWidthPx(40),
              right: getWidthPx(20),
              top: getWidthPx(30),
              bottom: getWidthPx(30)),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  top: BorderSide(width: 1, color: Colors.black12),
                  bottom: BorderSide(width: 1, color: Colors.black12))),
          child: InkWell(
            onTap: () {
              if (user.hasUser == false) {
                // ToastUtil.showErrorToast("请先登录！");
                G.getCurrentState().pushNamedAndRemoveUntil(
                    RoutePaths.LOGIN, (router) => router == null,
                    arguments: {'isMine': true});
              } else {
                if (user.idCard != null && user.idCard != '') {
                  ToastUtil.showErrorToast("您已实名认证完成了！");
                } else {
                  G.pushNamed(RoutePaths.RealName,
                      arguments: {'comeFrom': "Mine"});
                }
              }
            },
            child: Row(
              children: <Widget>[
                Image.asset(
                  "lib/assets/images/per_certified.png",
                  width: getWidthPx(40),
                  height: getWidthPx(40),
                ),
                SizedBox(
                  width: getWidthPx(20),
                ),
                Expanded(
                  child: Text('实名认证',
                      style:
                          TextStyle(fontSize: 16, color: AppTheme.textBlack)),
                ),
                Image.asset(
                  "lib/assets/images/more.png",
                  width: getWidthPx(26),
                  height: getWidthPx(26),
                ),
                SizedBox(
                  width: getWidthPx(20),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: getWidthPx(32)),
          padding: EdgeInsets.only(
              left: getWidthPx(40),
              right: getWidthPx(20),
              top: getWidthPx(30),
              bottom: getWidthPx(30)),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: InkWell(
            onTap: () {
              if (user.hasUser) {
                if (user.idCard == null || user.idCard == "") {
                  return ToastUtil.showWarningToast("请先实名认证后，再进行操作");
                }
                Navigator.pushNamed(context, RoutePaths.MineAddressList);
              } else {
                // ToastUtil.showErrorToast("请先登录！");
                G.getCurrentState().pushNamedAndRemoveUntil(
                    RoutePaths.LOGIN, (router) => router == null,
                    arguments: {'isMine': true});
              }
            },
            child: Row(
              children: <Widget>[
                Image.asset(
                  "lib/assets/images/per_add.png",
                  width: getWidthPx(40),
                  height: getWidthPx(40),
                ),
                SizedBox(
                  width: getWidthPx(20),
                ),
                Expanded(
                  child: Text('我的地址',
                      style:
                          TextStyle(fontSize: 16, color: AppTheme.textBlack)),
                ),
                Image.asset(
                  "lib/assets/images/more.png",
                  width: getWidthPx(26),
                  height: getWidthPx(26),
                ),
                SizedBox(
                  width: getWidthPx(20),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: getWidthPx(32)),
          padding: EdgeInsets.only(
              left: getWidthPx(40),
              right: getWidthPx(20),
              top: getWidthPx(30),
              bottom: getWidthPx(30)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(10),
              )),
          child: InkWell(
            onTap: () {
              if (user.hasUser) {
                if (user.idCard == null || user.idCard == "") {
                  return ToastUtil.showWarningToast("请先实名认证后，再进行操作");
                }
                G.getCurrentState().pushNamed(RoutePaths.mySignatureSetting);
              } else {
                G.getCurrentState().pushNamedAndRemoveUntil(
                    RoutePaths.LOGIN, (router) => router == null,
                    arguments: {'isMine': true});
              }
            },
            child: Row(
              children: <Widget>[
                Image.asset(
                  "lib/assets/images/enterprise_signature.png",
                  width: getWidthPx(40),
                  height: getWidthPx(40),
                ),
                SizedBox(
                  width: getWidthPx(20),
                ),
                Expanded(
                  child: Text('我的签章',
                      style:
                          TextStyle(fontSize: 16, color: AppTheme.textBlack)),
                ),
                Image.asset(
                  "lib/assets/images/more.png",
                  width: getWidthPx(26),
                  height: getWidthPx(26),
                ),
                SizedBox(
                  width: getWidthPx(20),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: getWidthPx(30),
        ),
        Container(
            margin: EdgeInsets.symmetric(horizontal: getWidthPx(32)),
            padding: EdgeInsets.only(
                left: getWidthPx(40),
                right: getWidthPx(20),
                top: getWidthPx(30),
                bottom: getWidthPx(30)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(10),
                )),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.settings);
              },
              child: Row(
                children: <Widget>[
                  Image.asset(
                    "lib/assets/images/per_set.png",
                    width: getWidthPx(40),
                    height: getWidthPx(40),
                  ),
                  SizedBox(
                    width: getWidthPx(20),
                  ),
                  Expanded(
                    child: Text('系统设置',
                        style:
                            TextStyle(fontSize: 16, color: AppTheme.textBlack)),
                  ),
                  Image.asset(
                    "lib/assets/images/more.png",
                    width: getWidthPx(26),
                    height: getWidthPx(26),
                  ),
                  SizedBox(
                    width: getWidthPx(20),
                  ),
                ],
              ),
            )),
        Container(
            margin: EdgeInsets.fromLTRB(getWidthPx(32), 1, getWidthPx(32), 0),
            padding: EdgeInsets.only(
                left: getWidthPx(40),
                right: getWidthPx(20),
                top: getWidthPx(30),
                bottom: getWidthPx(30)),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(10),
                )),
            child: InkWell(
              onTap: () {
                _service.call("4008001820");
              },
              child: Row(
                children: <Widget>[
                  Image.asset(
                    "lib/assets/images/per_tel.png",
                    width: getWidthPx(40),
                    height: getWidthPx(40),
                  ),
                  SizedBox(
                    width: getWidthPx(20),
                  ),
                  Expanded(
                    child: Text('咨询热线',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.textBlack)), // 中间用Expanded控件
                  ),
                  Text("4008001820"),
                  SizedBox(
                    width: getWidthPx(20),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}
