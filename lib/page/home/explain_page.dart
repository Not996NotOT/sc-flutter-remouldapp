import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../utils/common_tools.dart';
// import 'package:wakelock/wakelock.dart';

// ignore: must_be_immutable
class ExplainPage extends StatefulWidget {
  int arguments;

  ExplainPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    wjPrint('111111');
    return ExplainPageState();
  }
}

class ExplainPageState extends BaseState<ExplainPage>
    with AutomaticKeepAliveClientMixin {
  bool _checkboxSelected = false; //维护复选框状态
  int isAgent = 0; //是否为代理  0：否，1：是

  // 开始申办按钮
  bool isEnable = true;

  @override
  void initState() {
    wjPrint('12222222');
    // Wakelock.enable();
    super.initState();
    if (widget.arguments == 1) {
      wjPrint(".............................");
      Future.delayed(Duration.zero, () {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text(
                  "请选择身份类型",
                  style: TextStyle(fontSize: 20),
                ),
                content: Text(
                  '''您是否代他人办理公证事项，如果是请选择“我是代理人”，不是则选择“我是申请人”''',
                  style: TextStyle(fontSize: 16, color: Colors.black45),
                ),
                actions: <Widget>[
                  InkWell(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border:
                              Border.all(color: AppTheme.lightText, width: 1.0),
                        ),
                        child: Text("我是代理人")),
                    onTap: () {
                      setState(() {
                        isAgent = 1;
                        Navigator.of(context).pop(); //关闭对话框
                      }); //关闭对话框
                    },
                  ),
                  InkWell(
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                          decoration: BoxDecoration(
                              color: AppTheme.themeBlue,
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "我是申请人",
                            style: TextStyle(color: Colors.white),
                          )),
                      onTap: () {
                        setState(() {
                          isAgent = 0;
                          Navigator.of(context).pop();
                        });
                      }),
                ],
              );
            });
      });
    }
  }

  @override
  void dispose() {
    wjPrint('3333333');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    wjPrint('444444444');
    super.build(context);
    wjPrint('555555');
    return Scaffold(
      appBar: commonAppBar(title: "申办流程及说明"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          wjPrint('66666');
          return Column(
            children: <Widget>[
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: getHeightPx(10),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: getWidthPx(20)),
                        child: const Text(
                          '申办流程',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: getHeightPx(10),
                      ),
                      widget.arguments == 1
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(30)),
                                  child: Image.asset(
                                    'lib/assets/images/flow_path_top.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  height: getHeightPx(10),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: getWidthPx(120),
                                          child: const Text(
                                            '选择',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getWidthPx(120),
                                          child: const Text(
                                            '公证事项',
                                            textAlign: TextAlign.center,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: getWidthPx(120),
                                          child: const Text(
                                            '填写',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                        SizedBox(
                                          width: getWidthPx(120),
                                          child: const Text(
                                            '申请信息',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      width: getWidthPx(120),
                                      child: const Text(
                                        '上传材料',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getWidthPx(120),
                                      child: const Text(
                                        '支付',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                    SizedBox(
                                      width: getWidthPx(120),
                                      child: const Text(
                                        '等待出证',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(30)),
                                  child: Image.asset(
                                    'lib/assets/images/ic_process.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  height: getHeightPx(10),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(20)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      const Text(
                                        '公证申请',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const Text(
                                        '谈话及初审',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const Text(
                                        '检查及出证',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      const Text(
                                        '公证书受领',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                      SizedBox(
                        height: getHeightPx(10),
                      ),
                      Container(
                        color: AppTheme.bg_b,
                        height: getHeightPx(30),
                      ),
                      SizedBox(
                        height: getHeightPx(10),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: getWidthPx(20)),
                        child: const Text(
                          '申办说明',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: getHeightPx(10),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: getWidthPx(30)),
                        child: const Text(
                          '    一、当事人向公证处申办公证，应如实告知所申请办理公证事项的有关情况，提供真实、合法、充分的证明材料。\n'
                          '    二、当事人在网上上传的相关证明材料的原件需要在领取公证书之日向公证处公证人员出示并核对。根据《中华人民共和国公证法》、《公证程序规则》等有关规定，当事人提供虚假证明材料骗取公证书的，将可能依法被追究民事责任、行政责任，甚至刑事责任。\n'
                          '    三、如当事人虚构、隐瞒事实，或者提供虚假证明材料；提供的证明材料不充分或者拒绝补充证明材料；申请公证的事项不真实、不合法或是拒绝按照规定支付公证费等，本处将不予办理公证。不予办理公证的，公证处将根据不予办理的原因及责任，酌情退还部分或者全部收取的公证费。',
                          style: TextStyle(fontSize: 14),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: getWidthPx(750),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: getHeightPx(50),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: getWidthPx(30)),
                      child: RichText(
                          maxLines: 2,
                          text: TextSpan(
                            text: '《在线受理服务使用规则》',
                            style: TextStyle(
                                fontSize: 14, color: AppTheme.themeBlue),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                G.pushNamed(
                                  RoutePaths.RuleDetail,
                                );
                              },
                            children: [
                              TextSpan(
                                  text: '《电子签名服务告知条款》',
                                  style: TextStyle(
                                      fontSize: 14, color: AppTheme.themeBlue),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      G.pushNamed(
                                        RoutePaths.DianziName,
                                      );
                                    })
                            ],
                          )),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: <Widget>[
                    //     InkWell(
                    //         onTap: () {
                    //           G.pushNamed(
                    //             RoutePaths.RuleDetail,
                    //           );
                    //         },
                    //         child: const Text(
                    //           '《在线受理服务使用规则》',
                    //           style: TextStyle(
                    //               fontSize: 14, color: AppTheme.themeBlue),
                    //         )),
                    //     InkWell(
                    //         onTap: () {
                    //           G.pushNamed(
                    //             RoutePaths.DianziName,
                    //           );
                    //         },
                    //         child: const Text(
                    //           '《电子签名服务告知条款》',
                    //           style: TextStyle(
                    //               fontSize: 14, color: AppTheme.themeBlue),
                    //         ))
                    //   ],
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: _checkboxSelected,
                          activeColor: AppTheme.themeBlue, //选中时的颜色
                          onChanged: (value) {
                            setState(() {
                              _checkboxSelected = value;
                            });
                          },
                        ),
                        const Text(
                          '已阅读并同意上述规则和条款',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                    DebounceButton(
                      clickTap: isEnable
                          ? () {
                              if (_checkboxSelected) {
                                switch (widget.arguments) {
                                  case 1:
                                    G.pushNamed(RoutePaths.SelectPublicContent,
                                        arguments: {"isAgent": isAgent});
                                    break;
                                  case 2:
                                    G.getCurrentState().pushReplacementNamed(
                                        RoutePaths.videoUserInformation);
                                    break;
                                  case 3:
                                    G
                                        .getCurrentState()
                                        .pushReplacementNamed(
                                        RoutePaths.Protocol);
                                    break;
                                }
                              } else {
                                // Wakelock.enable();
                                ToastUtil.showWarningToast("请确认已阅读并同意上述规则和条款");
                              }
                            }
                          : null,
                      isEnable: isEnable,
                      margin: EdgeInsets.fromLTRB(
                          getWidthPx(40),
                          0,
                          getWidthPx(40),
                          MediaQuery.of(context).padding.bottom +
                              getWidthPx(20)),
                      padding: const EdgeInsets.all(10),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      child: const Text('开始申办',
                          style: TextStyle(
                              fontSize: 16, color: AppTheme.nearlyWhite)),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
