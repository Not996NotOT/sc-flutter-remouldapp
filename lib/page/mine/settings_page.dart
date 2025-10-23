import 'dart:convert';

import 'package:color_dart/RgbaColor.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/page/mine/vm/settings_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends BaseState<SettingsPage> {
  SettingsViewModel settingsViewModel;
  UserViewModel userViewModel;
  PackageInfo version;
  bool isLogout = false;
  String isMD5 = "";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      version = await PackageInfo.fromPlatform();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: commonAppBar(title: "系统设置"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return ProviderWidget<SettingsViewModel>(
            model: SettingsViewModel(userModel),
            onModelReady: (model) {
              userViewModel = userModel;
              settingsViewModel = model;
              model.initData();
            },
            builder: (ctx, settingModel, child) {
              return Container(
                color: AppTheme.chipBackground,
                width: getWidthPx(750),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    bodyList(),
                    userModel.hasUser
                        ? Container(
                            margin: EdgeInsets.only(
                                top: getWidthPx(50),
                                left: getWidthPx(40),
                                right: getWidthPx(40)),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.red,
                            ),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(''), // 中间用Expanded控件
                                  ),
                                  Text('注销登录账号',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.nearlyWhite)),
                                  Expanded(
                                    child: Text(''), // 中间用Expanded控件
                                  ),
                                ],
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return StatefulBuilder(
                                        builder: (ctx, setBottomSheet) {
                                          return Dialog(
                                            child: Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4)),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    isLogout
                                                        ? Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(10),
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                    "请输入账号的密码，用于验证"),
                                                                TextField(
                                                                  maxLength: 20,
                                                                  controller:
                                                                      TextEditingController(),
                                                                  keyboardType:
                                                                      TextInputType
                                                                          .visiblePassword,
                                                                  obscureText:
                                                                      true,
                                                                  decoration:
                                                                      InputDecoration(
                                                                    counterText:
                                                                        '',
                                                                    border:
                                                                        InputBorder
                                                                            .none,
                                                                    hintText:
                                                                        '请输入登录密码',
                                                                    hintStyle:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                    ),
                                                                  ),
                                                                  onChanged:
                                                                      (e) {
                                                                    if (e.length >
                                                                        20) {
                                                                      return;
                                                                    }
                                                                    var content =
                                                                        new Utf8Encoder()
                                                                            .convert(e);
                                                                    isMD5 = md5
                                                                        .convert(
                                                                            content)
                                                                        .toString();
                                                                  },
                                                                ),
                                                              ],
                                                            ),
                                                          )
                                                        : Padding(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        24,
                                                                    horizontal:
                                                                        15),
                                                            child: Text(
                                                              "你确定需要注销账号吗？注销后，账号下所有信息都会被永久清除！",
                                                              style: TextStyle(
                                                                color: rgba(
                                                                    153,
                                                                    153,
                                                                    153,
                                                                    1),
                                                                fontSize: 14,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                          ),
                                                    Container(
                                                      // padding: EdgeInsets.symmetric(vertical: 10),
                                                      decoration: BoxDecoration(
                                                          border: Border(
                                                              top: BorderSide(
                                                                  color: rgba(
                                                                      242,
                                                                      242,
                                                                      242,
                                                                      1)))),
                                                      child: Row(
                                                        children: <Widget>[
                                                          // 取消按钮
                                                          Expanded(
                                                              child: Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              border: Border(
                                                                  right: BorderSide(
                                                                      color: rgba(
                                                                          242,
                                                                          242,
                                                                          242,
                                                                          1))),
                                                            ),
                                                            child: TextButton(
                                                              child: Text(
                                                                "取消",
                                                                style: TextStyle(
                                                                    color: AppTheme
                                                                        .bg_f),
                                                              ),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                isLogout =
                                                                    false;
                                                              },
                                                            ),
                                                          )),

                                                          // 确认按钮
                                                          Expanded(
                                                            child: TextButton(
                                                              child: Text("确认"),
                                                              onPressed: () {
                                                                if (!isLogout) {
                                                                  isLogout =
                                                                      true;
                                                                  setBottomSheet(
                                                                      () {});
                                                                } else {
                                                                  if (isMD5
                                                                      .isEmpty) {
                                                                    return ToastUtil
                                                                        .showErrorToast(
                                                                            "请输入密码");
                                                                  }
                                                                  MineApi.getSingleton()
                                                                      .userToCancellation({
                                                                    "password":
                                                                        isMD5
                                                                  }).then((res) {
                                                                    if (res['code'] ==
                                                                        200) {
                                                                      ToastUtil
                                                                          .showErrorToast(
                                                                              "注销成功！期待您的下次使用");
                                                                      userViewModel
                                                                          .userLogout();
                                                                      Navigator.of(context).pushNamedAndRemoveUntil(
                                                                          RoutePaths
                                                                              .LOGIN,
                                                                          (Route route) =>
                                                                              false);
                                                                    } else {
                                                                      ToastUtil
                                                                          .showErrorToast(
                                                                              res['msg']);
                                                                    }
                                                                  });
                                                                }
                                                              },
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          );
                                        },
                                      );
                                    });
                              },
                            ))
                        : SizedBox(),
                    userModel.hasUser
                        ? Container(
                            margin: EdgeInsets.only(
                                top: getWidthPx(50),
                                left: getWidthPx(40),
                                right: getWidthPx(40)),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: AppTheme.themeBlue,
                            ),
                            child: InkWell(
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: SizedBox(), // 中间用Expanded控件
                                  ),
                                  Text('退出当前账号',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.nearlyWhite)),
                                  Expanded(
                                    child: SizedBox(), // 中间用Expanded控件
                                  ),
                                ],
                              ),
                              onTap: () {
                                ADialog.confirm(context,
                                    content: "确定要退出吗？",
                                    cancelButtonText: Text("关闭"),
                                    confirmButtonText: Text("退出"),
                                    cancelButtonPress: () {
                                  Navigator.of(context).pop();
                                }, confirmButtonPress: () {
                                  userViewModel.userLogout();
                                  MqttClientMsg.instance.disconnect();
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      RoutePaths.LOGIN, (Route route) => false);
                                });
                              },
                            ))
                        : SizedBox(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget bodyList() {
    return Column(
      children: <Widget>[
        Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: getWidthPx(20)),
            padding: EdgeInsets.only(
                left: getWidthPx(40),
                right: getWidthPx(20),
                top: getWidthPx(30),
                bottom: getWidthPx(30)),
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: const Text('隐私政策',
                        style:
                            TextStyle(fontSize: 16, color: AppTheme.dark_grey)),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black38,
                  ),
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.Privacy);
              },
            )),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: getWidthPx(2)),
          padding: EdgeInsets.only(
              left: getWidthPx(40),
              right: getWidthPx(20),
              top: getWidthPx(30),
              bottom: getWidthPx(30)),
          child: InkWell(
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text('服务协议',
                      style:
                          TextStyle(fontSize: 16, color: AppTheme.dark_grey)),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.black38,
                ),
              ],
            ),
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.UserAgreement);
            },
          ),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: getWidthPx(2)),
          padding: EdgeInsets.only(
              left: getWidthPx(40),
              right: getWidthPx(20),
              top: getWidthPx(30),
              bottom: getWidthPx(30)),
          child: InkWell(
            onTap: () {
              if (settingsViewModel.cacheStr != "0.00B") {
                showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("提示"),
                        content: Text("您确定要清除缓存吗?"),
                        actions: <Widget>[
                          TextButton(
                            child: const Text("取消"),
                            onPressed: () =>
                                Navigator.of(context).pop(), //关闭对话框
                          ),
                          TextButton(
                            child: const Text("清除"),
                            onPressed: () {
                              settingsViewModel.clearApplicationCache();
                              Navigator.of(context).pop(true); //关闭对话框
                            },
                          ),
                        ],
                      );
                    });
              }
            },
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text('清理缓存',
                      style:
                          TextStyle(fontSize: 16, color: AppTheme.dark_grey)),
                ),
                Row(
                  children: <Widget>[
                    Text(settingsViewModel.cacheStr,
                        style:
                            const TextStyle(fontSize: 16, color: Colors.green)),
                    const Icon(
                      Icons.chevron_right,
                      color: Colors.black38,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: getWidthPx(2)),
          padding: EdgeInsets.only(
              left: getWidthPx(40),
              right: getWidthPx(20),
              top: getWidthPx(30),
              bottom: getWidthPx(30)),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Text('版本号',
                    style: TextStyle(fontSize: 16, color: AppTheme.dark_grey)),
              ),
              Row(
                children: <Widget>[
                  Text((version == null ? "" : (version.version ?? "")),
                      style:
                          const TextStyle(fontSize: 16, color: Colors.green)),
                  const Icon(
                    Icons.chevron_right,
                    color: Colors.black38,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: getWidthPx(2)),
          padding: EdgeInsets.only(
              left: getWidthPx(40),
              right: getWidthPx(20),
              top: getWidthPx(30),
              bottom: getWidthPx(30)),
          child: InkWell(
            onTap: ThrottleUtil().throttle((){
              Navigator.pushNamed(context, RoutePaths.ModifyPsd,
                  arguments: {'phoneNumber':userViewModel.mobile ?? '','title':"重置密码"});
            }),
            child: Row(
              children: <Widget>[
                const Expanded(
                  child: Text('重置密码',
                      style:
                          TextStyle(fontSize: 16, color: AppTheme.dark_grey)),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: Colors.black38,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
