import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/selectPublicContent_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/bottom_alert_search_list.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';

class SelectPublicContentPage extends StatefulWidget {
  final arguments;
  const SelectPublicContentPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return SelectPublicContentState();
  }
}

class SelectPublicContentState extends BaseState<SelectPublicContentPage>
    with AutomaticKeepAliveClientMixin {
  SelectPublicContentModel selectPublicViewModel;

  @override
  void initState() {
    super.initState();
  }

  void changeLanguage() {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return BottomAlertSearchList(
            holderString: "请输入你要搜索的公证处",
            selectValueCallBack: (value) {
              wjPrint("value---------$value");
              selectPublicViewModel.notarialOfficeList.forEach((element) {
                if (element['notarialName'] == value) {
                  selectPublicViewModel.notarialUpdate(element);
                }
              });
            },
            dataSource: selectPublicViewModel.notarialOfficeNameList,
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
        if(selectPublicViewModel != null){
          selectPublicViewModel.getLocation();
          selectPublicViewModel.getNotarizationPurpose();
        }
      },
      child: Scaffold(
        appBar: commonAppBar(title: "选择公证事项"),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<SelectPublicContentModel>(
              model: SelectPublicContentModel(userModel, widget.arguments),
              onModelReady: (model) {
                selectPublicViewModel = model;
                // model.getLocation();
                // model.getNotarizationPurpose();
              },
              builder: (ctx, vm, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Container(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: getHeightPx(10),
                              ),
                              Container(
                                width: double.maxFinite,
                                child: Image.asset(
                                  "lib/assets/images/stepOne.png",
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                height: getHeightPx(40),
                              ),
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: getWidthPx(40)),
                                    child: const Text(
                                      "办理机构",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: getHeightPx(10),
                              ),
                              Container(
                                height: getHeightPx(100),
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(
                                    getWidthPx(40), 0, getWidthPx(20), 0),
                                child: InkWell(
                                  onTap: () async {
                                    AlertView.showCityPickerView(context,resultCallBack: (CityResult msg){
                                      wjPrint("showCityPickerView/位置信息：-----$msg");
                                      if (msg != null) {
                                        vm.city =
                                            "${msg.province} ${msg.city}";
                                        vm.adCode = "${msg.cityCode}";
                                        vm.getNotarialOfficeList();
                                        vm.notifyListeners();
                                        selectPublicViewModel.notarialInfo = null;
                                      }
                                    },locationCode: '320100');
                                    // Result result =
                                    //     await CityPickers.showCityPicker(
                                    //   context: context,
                                    //   height: 300.0,
                                    //   locationCode: '320100',
                                    //   showType: ShowType.pca,
                                    // );
                                    // wjPrint("位置信息：-----$result");
                                    // if (result != null) {
                                    //   vm.city =
                                    //       "${result.provinceName} ${result.cityName}";
                                    //   vm.adCode = "${result.cityId}";
                                    //   vm.getNotarialOfficeList();
                                    //   vm.notifyListeners();
                                    //   selectPublicViewModel.notarialInfo = null;
                                    // }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: const Text('当前城市',
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
                              Container(
                                height: getHeightPx(100),
                                color: Colors.white,
                                padding: EdgeInsets.fromLTRB(
                                    getWidthPx(40), 0, getWidthPx(20), 0),
                                child: InkWell(
                                  onTap: () {
                                    if (selectPublicViewModel
                                            .notarialOfficeList.length !=
                                        0) {
                                      changeLanguage();
                                    } else {
                                      ToastUtil.showErrorToast("该城市无可办理公证的公证处");
                                    }
                                  },
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: const Text(
                                          '公证处',
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: AppTheme.dark_grey),
                                        ),
                                      ),
                                      Text(
                                        selectPublicViewModel.notarialInfo == null
                                            ? '请点击选择'
                                            : selectPublicViewModel
                                                .notarialInfo['notarialName'],
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
                            ],
                          )),
                      SizedBox(
                        height: getHeightPx(30),
                      ),
                      ColoredBox(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: getWidthPx(40)),
                                  child: Text(
                                    "按公证用途分类（单选）",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: getHeightPx(30),
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: getWidthPx(30)),
                                child: Wrap(
                                  spacing: getWidthPx(10),
                                  children: selectPublicViewModel.selectDan
                                      .map((item) => ChoiceChip(
                                            selectedColor: Color.fromRGBO(
                                                111, 170, 255, 0.5),
                                            label: Text(item["name"]),
                                            selected: selectPublicViewModel
                                                    .selectIndex ==
                                                item["unitGuid"],
                                            onSelected: (v) {
                                              selectPublicViewModel.purposeName =
                                                  item["name"];
                                              selectPublicViewModel.selectIndex =
                                                  item["unitGuid"];
                                              selectPublicViewModel.selectDuo =
                                                  item["children"];
                                              selectPublicViewModel
                                                  .selectIndexDuo = [];
                                              selectPublicViewModel
                                                  .notifyListeners();
                                            },
                                          ))
                                      .toList(),
                                )),
                            SizedBox(
                              height: getHeightPx(30),
                            ),
                            Offstage(
                              offstage: selectPublicViewModel.selectIndex != ""
                                  ? false
                                  : true,
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Padding(
                                        padding:
                                            EdgeInsets.only(left: getWidthPx(40)),
                                        child: Text(
                                          "按公证事项分类（多选）",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: getHeightPx(30),
                                  ),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: getWidthPx(10)),
                                      child: Wrap(
                                        spacing: getWidthPx(10),
                                        children: selectPublicViewModel.selectDuo
                                            .map((item) => ChoiceChip(
                                                  selectedColor: Color.fromRGBO(
                                                      111, 170, 255, 0.5),
                                                  label: Text(item["name"]),
                                                  selected: selectPublicViewModel
                                                      .selectIndexDuo
                                                      .contains(item),
                                                  onSelected: (v) {
                                                    if (v) {
                                                      selectPublicViewModel
                                                          .selectIndexDuo
                                                          .add(item);
                                                    } else {
                                                      selectPublicViewModel
                                                          .selectIndexDuo
                                                          .removeWhere((f) {
                                                        return f == item;
                                                      });
                                                    }
                                                    selectPublicViewModel
                                                        .notifyListeners();
                                                  },
                                                ))
                                            .toList(),
                                      )),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: getHeightPx(30),
                      ),
                      InkWell(
                        onTap: () {
                          if (selectPublicViewModel.notarialInfo == null) {
                            ToastUtil.showWarningToast("请选择公证处");
                          } else if (selectPublicViewModel.selectIndex.length ==
                              0) {
                            ToastUtil.showWarningToast("请选择公证用途分类");
                          } else if (selectPublicViewModel
                                  .selectIndexDuo.length ==
                              0) {
                            ToastUtil.showWarningToast("请选择公证事项分类");
                          } else {
                            G.pushNamed(RoutePaths.ApplyInfo, arguments: {
                              "notarialName": selectPublicViewModel.notarialInfo,
                              "selectDan": selectPublicViewModel.selectIndex,
                              "selectDuo": selectPublicViewModel.selectIndexDuo,
                              "purposeName": selectPublicViewModel.purposeName,
                              "isAgent": widget.arguments["isAgent"]
                            });
                          }
                        },
                        child: Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(
                                top: getWidthPx(50),
                                left: getWidthPx(40),
                                right: getWidthPx(40)),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(5)),
                              color: AppTheme.themeBlue,
                            ),
                            child: Text('下一步',
                                style: TextStyle(
                                    fontSize: 16, color: AppTheme.nearlyWhite))),
                      ),
                      SizedBox(
                        height: getHeightPx(20),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
