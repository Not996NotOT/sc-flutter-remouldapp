import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/contractPeople_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/bottom_alert_search_list.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';

class ContractPeoplePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ContractPeoplePageState();
  }
}

class ContractPeoplePageState extends BaseState<ContractPeoplePage>
    with AutomaticKeepAliveClientMixin {
  ContractPeopleModel contractModel;

  @override
  void initState() {
    super.initState();
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
              contractModel.notarialList.forEach((element) {
                if (element.notarialName == value) {
                  contractModel.notarialUpdate(element);
                }
              });
            },
            dataSource: contractModel.notarialNameList,
          );
        });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FocusDetector(
      onFocusGained: () {
        if (contractModel != null && contractModel.isEnable) {
          contractModel.initData();
        }
      },
      child: Scaffold(
        appBar: commonAppBar(title: "合同相对方"),
        body: WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Consumer<UserViewModel>(
            builder: (ctx, userModel, child) {
              return ProviderWidget<ContractPeopleModel>(
                model: ContractPeopleModel(userModel),
                onModelReady: (model) {
                  contractModel = model;
                },
                builder: (ctx, vm, child) {
                  return Column(
                    children: <Widget>[
                      Expanded(
                        child: SingleChildScrollView(
                          child: ColoredBox(
                            color: Color(0xfff2f5fa),
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
                                            vm.city =
                                                "${msg.province} ${msg.city}";
                                            vm.adCode = "${msg.cityCode}";
                                            vm.getNotarial();
                                            vm.notifyListeners();
                                          }
                                        }, locationCode: '320100');
                                        // Result result =
                                        //     await CityPickers.showCityPicker(
                                        //   context: context,
                                        //   height: 300.0,
                                        //   locationCode: '320100',
                                        //   showType: ShowType.pc,
                                        // );
                                        // wjwjPrint("位置信息：-----$result");
                                        // if (result != null) {
                                        //   vm.city =
                                        //       "${result.provinceName} ${result.cityName}";
                                        //   vm.adCode = "${result.cityId}";
                                        //   vm.getNotarial();
                                        //   vm.notifyListeners();
                                        // }
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          const Text('当前城市',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black87)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              vm.city ?? '请点击选择',
                                              // overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: AppTheme.Text_min),
                                              textAlign: TextAlign.right,
                                            ),
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
                                          ToastUtil.showErrorToast(
                                              "该城市无可办理公证的公证处");
                                        }
                                      },
                                      child: Row(
                                        children: <Widget>[
                                          const Text('公证处',
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.black87)),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Expanded(
                                            child: Text(
                                              vm.notarialInfo == null
                                                  ? '请点击选择'
                                                  : vm.notarialInfo[
                                                          'notarialName'] ??
                                                      '',
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  color: AppTheme.Text_min),
                                              textAlign: TextAlign.right,
                                            ),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: AppTheme.Text_min,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: getHeightPx(20),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: getWidthPx(20)),
                                  child: const Text(
                                    '被邀请人信息',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xff5496e0)),
                                  ),
                                ),
                                SizedBox(
                                  height: getHeightPx(20),
                                ),
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: vm.inviteeList.length,
                                    itemBuilder: (ctx, i) {
                                      return ColoredBox(
                                        color: Colors.white,
                                        child: Column(
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.fromLTRB(
                                                  getWidthPx(20),
                                                  getWidthPx(20),
                                                  getWidthPx(20),
                                                  0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: Text(
                                                      "第${i + 1}个被邀请人信息",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 14,
                                                          color: Colors.indigo),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      if (i == 0){
                                                        if (vm.inviteeList
                                                            .length <
                                                            5) {
                                                          vm.addUserList(true);
                                                        } else {
                                                          ToastUtil.showToast("最多添加五人");
                                                        }
                                                      } else {
                                                        vm.addUserList(false,
                                                            i: i);
                                                      }
                                                    },
                                                    child: Icon(
                                                      i == 0
                                                          ? Icons
                                                              .add_circle_outline
                                                          : Icons
                                                              .remove_circle_outline,
                                                      color: Colors.indigo,
                                                      size: 26,
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
                                                        width: 1,
                                                        color: AppTheme.bg_c)),
                                              ),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: getWidthPx(10)),
                                              padding: EdgeInsets.fromLTRB(
                                                  getWidthPx(40),
                                                  getWidthPx(20),
                                                  getWidthPx(40),
                                                  getWidthPx(20)),
                                              child: Row(
                                                children: <Widget>[
                                                  const Text('账号',
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color:
                                                              Colors.black87)),
                                                  Expanded(
                                                    child: Container(
                                                      alignment:
                                                          Alignment.centerRight,
                                                      child: TextField(
                                                          keyboardType:
                                                              TextInputType
                                                                  .text,
                                                          textAlign:
                                                              TextAlign.right,
                                                          // maxLength: 11,
                                                          controller:
                                                              vm.textController[
                                                                  "name"][i],
                                                          decoration:
                                                              InputDecoration(
                                                            counterText: "",
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                '请输入被邀请人帐号或邮箱',
                                                            hintStyle:
                                                                TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          onChanged: (value) {
                                                            wjPrint(
                                                                '123654.....${vm.textController["name"][i].text}');
                                                            vm.inviteeList[i]
                                                                    .userName =
                                                                vm
                                                                    .textController[
                                                                        "name"]
                                                                        [i]
                                                                    .text;
                                                          }),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            // Container(
                                            //   height: getHeightPx(100),
                                            //   decoration: BoxDecoration(
                                            //     border: Border(
                                            //         bottom: BorderSide(
                                            //             width: 1,
                                            //             color: AppTheme.bg_c)),
                                            //   ),
                                            //   margin: EdgeInsets.symmetric(
                                            //       horizontal: getWidthPx(10)),
                                            //   padding: EdgeInsets.fromLTRB(
                                            //       getWidthPx(40),
                                            //       getWidthPx(20),
                                            //       getWidthPx(40),
                                            //       getWidthPx(20)),
                                            //   child: Row(
                                            //     children: <Widget>[
                                            //       const Text('手机号',
                                            //           style: TextStyle(
                                            //               fontSize: 16,
                                            //               color: Colors.black87)),
                                            //       Expanded(
                                            //         child: Container(
                                            //           alignment:
                                            //               Alignment.centerRight,
                                            //           child: TextField(
                                            //               keyboardType:
                                            //                   TextInputType.text,
                                            //               textAlign:
                                            //                   TextAlign.right,
                                            //               maxLength: 11,
                                            //               controller:
                                            //                   vm.textController[
                                            //                       "mobile"][i],
                                            //               decoration:
                                            //                   InputDecoration(
                                            //                 counterText: "",
                                            //                 border:
                                            //                     InputBorder.none,
                                            //                 hintText:
                                            //                     '请输入被邀请人的手机号',
                                            //                 hintStyle: TextStyle(
                                            //                   fontSize: 14,
                                            //                 ),
                                            //               ),
                                            //               onChanged: (value) {
                                            //                 wjPrint(
                                            //                     '123654.....$value');
                                            //                 vm.inviteeList[i]
                                            //                         .mobile =
                                            //                     vm
                                            //                         .textController[
                                            //                             "mobile"]
                                            //                             [i]
                                            //                         .text;
                                            //               }),
                                            //         ),
                                            //       ),
                                            //     ],
                                            //   ),
                                            // ),
                                            // Container(
                                            //   height: getHeightPx(100),
                                            //   decoration: BoxDecoration(
                                            //     border: Border(
                                            //         bottom: BorderSide(
                                            //             width: 1,
                                            //             color: AppTheme.bg_c)),
                                            //   ),
                                            //   margin: EdgeInsets.symmetric(
                                            //       horizontal: getWidthPx(10)),
                                            //   padding: EdgeInsets.fromLTRB(
                                            //       getWidthPx(40),
                                            //       getWidthPx(20),
                                            //       getWidthPx(40),
                                            //       getWidthPx(20)),
                                            //   child: Row(
                                            //     children: <Widget>[
                                            //       const Text('身份证号',
                                            //           style: TextStyle(
                                            //               fontSize: 16,
                                            //               color: Colors.black87)),
                                            //       Expanded(
                                            //         child: Container(
                                            //           alignment:
                                            //               Alignment.centerRight,
                                            //           child: TextField(
                                            //               keyboardType:
                                            //                   TextInputType.text,
                                            //               textAlign:
                                            //                   TextAlign.right,
                                            //               maxLength: 18,
                                            //               controller:
                                            //                   vm.textController[
                                            //                       "idCard"][i],
                                            //               decoration:
                                            //                   InputDecoration(
                                            //                 counterText: "",
                                            //                 border:
                                            //                     InputBorder.none,
                                            //                 hintText:
                                            //                     '请输入被邀请人的身份证号',
                                            //                 hintStyle: TextStyle(
                                            //                   fontSize: 14,
                                            //                 ),
                                            //               ),
                                            //               onChanged: (value) {
                                            //                 wjPrint(
                                            //                     '123654.....$value');
                                            //                 vm.inviteeList[i]
                                            //                         .idCard =
                                            //                     vm
                                            //                         .textController[
                                            //                             "idCard"]
                                            //                             [i]
                                            //                         .text;
                                            //               }),
                                            //         ),
                                            //       )
                                            //     ],
                                            //   ),
                                            // ),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ),
                      DebounceButton(
                        clickTap: () async {
                          if (!await Permission.camera.status.isGranted ||
                              !await Permission.speech.status.isGranted ||
                              !await Permission.storage.status.isGranted) {
                            G.showCustomToast(
                                context: context,
                                titleText: "相机、麦克风、存储权限说明：",
                                subTitleText: "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                                time: 2);
                          }
                          if (await Permission.camera.request().isGranted &&
                              await Permission.speech.request().isGranted &&
                              await Permission.storage.request().isGranted) {
                            vm.addOrder();
                          } else {
                            G.showPermissionDialog(str: "访问内部存储、语音麦克风、相机、相册权限");
                          }
                        },
                        margin: EdgeInsets.fromLTRB(
                            getWidthPx(40),
                            0,
                            getWidthPx(40),
                            getWidthPx(10) +
                                MediaQuery.of(context).padding.bottom +
                                getWidthPx(20)),
                        padding: EdgeInsets.all(10),
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        isEnable: vm.isEnable,
                        child: Text('开始公证',
                            style: TextStyle(
                                fontSize: 16, color: AppTheme.nearlyWhite)),
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
