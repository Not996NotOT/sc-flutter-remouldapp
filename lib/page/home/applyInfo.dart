import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/page/home/vm/applyInfo_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/bottom_alert_search_list.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';
import '../../utils/global.dart';

class ApplyInfoPage extends StatefulWidget {
  final arguments;
  const ApplyInfoPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return ApplyInfoPageState();
  }
}

class ApplyInfoPageState extends BaseState<ApplyInfoPage>
    with AutomaticKeepAliveClientMixin {
  ApplyInfoModel applyInfoModel;

  UserViewModel userViewModel;

  @override
  void initState() {
    super.initState();
  }

  //引入防抖
  ThrottleUtil throttleUtil = ThrottleUtil();

  /// 选择公证区域弹窗
  Future<void> changeCountry() async {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return BottomAlertSearchList(
            holderString: "选择公证使用地区",
            selectValueCallBack: (value) {
              wjPrint("value---------$value");
              applyInfoModel.countryList.forEach((element) {
                if (element['zh'] == value) {
                  applyInfoModel.notarialUpdate(element);
                }
              });
            },
            dataSource: applyInfoModel.countryNameList,
          );
        });
  }

  /// 选择语言弹窗
  Future<void> changeLanguage() async {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return BottomAlertSearchList(
            holderString: "请选择公证译文语言",
            selectValueCallBack: (value) {
              wjPrint("value---------$value");
              applyInfoModel.languageList.forEach((element) {
                if (element['name'] == value) {
                  applyInfoModel.notarialUpdateLan(element);
                }
              });
            },
            dataSource: applyInfoModel.languageNameList,
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
    return Scaffold(
        appBar: commonAppBar(title: "填写申请信息"),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<ApplyInfoModel>(
              model: ApplyInfoModel(userModel, widget.arguments),
              onModelReady: (model) {
                applyInfoModel = model;
                userViewModel = userModel;
                model.loadData();
                model.getCountryList();
                model.getLanguageList();
                applyInfoModel.applyList.add({
                  "name": "",
                  "relationShip": "",
                  "mobile": "",
                  "idCard": "",
                  "birthday": "",
                  "gender": "1",
                  "address": "",
                  "orderId": "",
                });
                applyInfoModel.applyAgentList.add({
                  "name": userModel.userName,
                  "relationShip": "",
                  "mobile": userModel.mobile,
                  "idCard": userModel.idCard,
                  "birthday": userModel.birthday,
                  "gender": userModel.gender.toString(),
                  "address": userModel.address,
                  "orderId": "",
                  "principal": ""
                });
              },
              builder: (ctx, homeModel, child) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      _topWidget(),
                      widget.arguments["isAgent"] == 1
                          ? _helpOtherPeople()
                          : _applyByOtherPeopleInformation(0),
                      SizedBox(
                        height: getHeightPx(30),
                      ),
                      Container(
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: getHeightPx(30),
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: getWidthPx(30),
                                    right: getWidthPx(30)),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      "办理公证事项",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              height: getHeightPx(30),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: getWidthPx(30), right: getWidthPx(30)),
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: applyInfoModel
                                    .notarizationMattersList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  var item = applyInfoModel
                                      .notarizationMattersList[index];
                                  return Row(
                                    children: <Widget>[
                                      Container(
                                        margin: EdgeInsets.only(
                                          bottom: getWidthPx(10),
                                        ),
                                        child: Text(
                                          item["name"],
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: AppTheme.dark_grey),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: getHeightPx(30),
                            ),
                          ],
                        ),
                      ),
                      DebounceButton(
                        clickTap: throttleUtil.throttle(() async {
                          if (applyInfoModel.notarialInfo == null) {
                            ToastUtil.showWarningToast("请选择公证使用地区");
                          } else if (applyInfoModel.notarialInfoLan == null) {
                            ToastUtil.showWarningToast("请选择公证译文语言");
                          } else {
                            if (widget.arguments["isAgent"] == 0) {
                              //否
                              applyInfoModel.isEnable = false;
                              applyInfoModel.notifyListeners();
                              applyInfoModel.addAutoHelpList();
                            } else {
                              applyInfoModel.applyAllList = [];
                              bool isAll = true;
                              applyInfoModel.applyList.asMap().keys.map((item) {
                                if (applyInfoModel.applyList[item]["name"] ==
                                    "") {
                                  ToastUtil.showErrorToast(
                                      "第${item + 1}个申请人姓名不能为空！");
                                  isAll = false;
                                } else if (applyInfoModel.applyList[item]
                                        ["birthday"] ==
                                    "") {
                                  ToastUtil.showErrorToast(
                                      "第${item + 1}个申请人出生日期不能为空！");
                                  isAll = false;
                                } else if (applyInfoModel.applyList[item]
                                        ["mobile"] ==
                                    "") {
                                  ToastUtil.showErrorToast(
                                      "第${item + 1}个申请人手机号不能为空！");
                                  isAll = false;
                                }
//                             else if(applyInfoModel.applyList[item]["mobile"] != "" && !RegexUtil.isMobileExact(applyInfoModel.applyList[item]["mobile"])){
//                               ToastUtil.showErrorToast("第${item+1}个申请人请输入有效的手机号码！");isAll=false;
//                             }
                                else if (applyInfoModel.applyList[item]
                                        ["idCard"] ==
                                    "") {
                                  ToastUtil.showErrorToast(
                                      "第${item + 1}个申请人身份证号不能为空！");
                                  isAll = false;
                                } else if (applyInfoModel.applyList[item]
                                            ["idCard"] !=
                                        "" &&
                                    !RegexUtil.isIDCard18(applyInfoModel
                                        .applyList[item]["idCard"])) {
                                  ToastUtil.showErrorToast(
                                      "第${item + 1}个申请人请输入有效的身份证号码！");
                                  isAll = false;
                                } else if (applyInfoModel.applyList[item]
                                        ["address"] ==
                                    "") {
                                  ToastUtil.showErrorToast(
                                      "第${item + 1}个申请人家庭住址不能为空！");
                                  isAll = false;
                                }
                              }).toList();
                              if (!isAll) {
                                return;
                              }
                              applyInfoModel.applyAgentList.forEach((item) {
                                applyInfoModel.applyAllList.add(item);
                              });
                              applyInfoModel.applyList.forEach((item) {
                                applyInfoModel.applyAllList.add(item);
                              });
                              applyInfoModel.isEnable = false;
                              applyInfoModel.notifyListeners();
                              applyInfoModel.addAgentAutoHelpList();
                            }
                          }
                        }),
                        isEnable: applyInfoModel.isEnable,
                        margin: EdgeInsets.only(
                            top: getWidthPx(50),
                            left: getWidthPx(40),
                            right: getWidthPx(40)),
                        padding: EdgeInsets.all(10),
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        child: Text('下一步',
                            style: TextStyle(
                                fontSize: 16, color: AppTheme.nearlyWhite)),
                      ),
                      SizedBox(
                        height: getHeightPx(30),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ));
  }

  /// 顶部公证区域和语言
  Widget _topWidget() {
    return Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(
                  top: getHeightPx(10), bottom: getHeightPx(40)),
              width: double.maxFinite,
              child: Image.asset(
                "lib/assets/images/stepTwo.png",
                fit: BoxFit.fill,
              ),
            ),
            Container(
              height: getHeightPx(100),
              color: Colors.white,
              padding:
                  EdgeInsets.fromLTRB(getWidthPx(40), 0, getWidthPx(20), 0),
              child: InkWell(
                onTap: () {
                  if (applyInfoModel.countryList.length != 0) {
                    changeCountry();
                  }
                },
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        '公证使用地区',
                        style:
                            TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                      ),
                    ),
                    Text(
                      applyInfoModel.notarialInfo == null
                          ? '请点击选择'
                          : applyInfoModel.notarialInfo['notarialName'],
                      style: const TextStyle(
                          fontSize: 16, color: AppTheme.Text_min),
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
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                width: 0.5, //宽度
                color: Colors.black12, //边框颜色
              ))),
            ),
            Container(
              height: getHeightPx(100),
              color: Colors.white,
              padding:
                  EdgeInsets.fromLTRB(getWidthPx(40), 0, getWidthPx(20), 0),
              child: InkWell(
                onTap: () {
                  if (applyInfoModel.countryList.length != 0) {
                    changeLanguage();
                  }
                },
                child: Row(
                  children: <Widget>[
                    const Expanded(
                      child: Text(
                        '公证译文语言',
                        style:
                            TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                      ),
                    ),
                    Text(
                      applyInfoModel.notarialInfoLan == null
                          ? '请点击选择'
                          : applyInfoModel.notarialInfoLan['notarialLanguage'],
                      style: const TextStyle(
                          fontSize: 16, color: AppTheme.Text_min),
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
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                width: 0.5, //宽度
                color: Colors.black12, //边框颜色
              ))),
            ),
          ],
        ));
  }

  ///  isAgent == 1 代理人办理自主公证
  Widget _helpOtherPeople() {
    return ColoredBox(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: applyInfoModel.applyList.length,
            itemBuilder: (ctx, int index) {
              return _applyPeopleInformation(index);
            },
          ),
          _applyByOtherPeopleInformation(1)
        ],
      ),
    );
  }

  /// 申请人信息
  Widget _applyPeopleInformation(int index) {
    return Column(
      children: <Widget>[
        Container(
          height: getHeightPx(100),
          color: Color(0xfff2f5fa),
          margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
          padding: EdgeInsets.fromLTRB(
              getWidthPx(20), getWidthPx(0), getWidthPx(20), getWidthPx(0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                "申请人信息",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xff5496e0)),
              ),
              InkWell(
                onTap: () {
                  if (index == 0) {
                    if(applyInfoModel.applyList.length > 9){
                      ToastUtil.showToast(
                          "当前申请人最多可添加10个人");
                    }else{
                      applyInfoModel.applyList.add({
                        "name": "",
                        "relationShip": "",
                        "mobile": "",
                        "idCard": "",
                        "birthday": "",
                        "gender": "1",
                        "address": "",
                        "orderId": "",
                      });
                      applyInfoModel.applyAgentList.add({
                        "name": userViewModel.userName,
                        "relationShip": "",
                        "mobile": userViewModel.mobile,
                        "idCard": userViewModel.idCard,
                        "birthday": userViewModel.birthday,
                        "gender": userViewModel.gender.toString(),
                        "address": userViewModel.address,
                        "orderId": "",
                        "principal": ""
                      });
                      applyInfoModel.selectGenderList.add("男");
                      applyInfoModel.birthdayList.add("");
                      applyInfoModel.textContentApply
                          .add(TextEditingController());
                      applyInfoModel.textContentMobile
                          .add(TextEditingController());
                      applyInfoModel.textContentIdCard
                          .add(TextEditingController());
                      applyInfoModel.textContentAddress
                          .add(TextEditingController());
                    }
                  } else {
                    showDialog(
                        context:
                        context,
                        barrierDismissible:
                        false,
                        builder:
                            (context) {
                          return AlertDialog(
                            title:
                            Text(
                              "提醒",
                              style: TextStyle(
                                  fontSize:
                                  20),
                            ),
                            content:
                            Text(
                              "是否删除当前申请人信息",
                              style: TextStyle(
                                  fontSize:
                                  16,
                                  color:
                                  Colors.black45),
                            ),
                            actions: <
                                Widget>[
                              FlatButton(
                                  child:
                                  Text("否"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  }),
                              FlatButton(
                                child:
                                Text("是"),
                                onPressed:
                                    () {
                                  Navigator.of(context).pop();
                                  ToastUtil.showToast("删除成功");
                                  applyInfoModel.applyList.removeAt(index);
                                  applyInfoModel.applyAgentList.removeAt(index);
                                  applyInfoModel.textContentApply.removeAt(index);
                                  applyInfoModel.textContentMobile.removeAt(index);
                                  applyInfoModel.textContentIdCard.removeAt(index);
                                  applyInfoModel.textContentAddress.removeAt(index);
                                  applyInfoModel.selectGenderList.removeAt(index);
                                  applyInfoModel.birthdayList.removeAt(index);
                                  applyInfoModel.notifyListeners();
                                },
                              ),
                            ],
                          );
                        });
                  }
                  applyInfoModel.notifyListeners();
                },
                child: index == 0
                    ? const Icon(
                        Icons.add_circle_outline,
                        color: Color(0xff5496e0),
                        size: 20,
                      )
                    : const Icon(
                        Icons.remove_circle_outline,
                        color: Color(0xff5496e0),
                        size: 20,
                      ),
              )
            ],
          ),
        ),
        _applyPeopleItemStyle(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('姓名',
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            Expanded(
              child: TextField(
                  keyboardType: TextInputType.text,
                  maxLength: 8,
                  textAlign: TextAlign.end,
                  controller: applyInfoModel.textContentApply[index],
                  // inputFormatters: [
                  //   WhitelistingTextInputFormatter(RegExp("[a-zA-Z]|[\u4e00-\u9fa5]")), //只能输入汉字或者字母或数字
                  // ],
                  decoration: const InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    hintText: '请输入申请人姓名',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (value) {
                    applyInfoModel.applyList[index]["name"] =
                        applyInfoModel.textContentApply[index].text;
                    applyInfoModel.applyAgentList[index]["principal"] =
                        applyInfoModel.textContentApply[index].text;
//                                                    applyInfoModel.applyAgentList[index]["name"] = applyInfoModel.textContentApply[index].text;
                    applyInfoModel.notifyListeners();
                  }),
            ),
          ],
        )),
        _applyPeopleItemStyle(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text('身份证号',
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
                Expanded(
                  child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.right,
                      maxLength: 18,
                      controller: applyInfoModel.textContentIdCard[index],
                      decoration: const InputDecoration(
                        // contentPadding:
                        // EdgeInsets.only(
                        //     bottom:
                        //     getHeightPx(27)),
                        counterText: "",
                        border: InputBorder.none,
                        hintText: '请输入身份证号',
                        hintStyle: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      onChanged: (value) {
                        applyInfoModel.applyList[index]["idCard"] =
                            applyInfoModel.textContentIdCard[index].text;
                        if (applyInfoModel
                            .textContentIdCard[
                        index]
                            .text
                            .isNotEmpty &&
                            RegexUtil.isIDCard18(applyInfoModel
                                .textContentIdCard[
                            index]
                                .text)) {
                          applyInfoModel.applyList[index]
                          [
                          "birthday"] =
                              G.getBirthDayFromCardId(applyInfoModel
                                  .textContentIdCard[index]
                                  .text);

                          applyInfoModel
                              .birthdayList[index] =
                              G.getBirthDayFromCardId(applyInfoModel
                                  .textContentIdCard[index]
                                  .text);

                          applyInfoModel.applyList[index]
                          [
                          "gender"] =
                          G.getSexFromCardId(applyInfoModel
                              .textContentIdCard[index]
                              .text) == "男" ? '1' : '0' ;

                          applyInfoModel
                              .selectGenderList[index] =
                              G.getSexFromCardId(applyInfoModel
                                  .textContentIdCard[index]
                                  .text);
                        }
//                                                    applyInfoModel.applyAgentList[index]["idCard"] = applyInfoModel.textContentIdCard[index].text;
                        applyInfoModel.notifyListeners();
                      }),
                )
              ],
            )),
        _applyPeopleItemStyle(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Expanded(
              child: Text('性别',
                  style: TextStyle(fontSize: 16, color: Colors.black87)),
            ),
            DropdownButton(
                value: applyInfoModel.selectGenderList[index],
                underline: Container(
                    height: 0.0, color: Colors.green.withOpacity(0.7)),
                items: [
                  const DropdownMenuItem(
                    child: Text(
                      '男',
                      style: TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                    ),
                    value: "男",
                  ),
                  const DropdownMenuItem(
                    child: Text(
                      '女',
                      style: TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                    ),
                    value: "女",
                  ),
                ],
                onChanged: (value) {
                  applyInfoModel.selectGenderList[index] = value;
                  applyInfoModel.applyList[index]["gender"] =
                      value == "男" ? "1" : "0";
//                                                applyInfoModel.applyAgentList[index]["gender"] = value == "男" ? "1" : "0";
                  applyInfoModel.notifyListeners();
                }),
          ],
        )),
        _applyPeopleItemStyle(
            child: Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Expanded(
                child: Text('出生日期',
                    style: TextStyle(fontSize: 16, color: Colors.black87)),
              ),
              InkWell(
                onTap: () {
                  wjPrint("点击了选择出生日期");
                  _selectTimeAlert(index);
                },
                child: Text(applyInfoModel.birthdayList[index] == ""
                    ? "请点击选择日期"
                    : applyInfoModel.birthdayList[index]),
              )
            ],
          ),
        )),
        _applyPeopleItemStyle(
            child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('手机号码',
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            Expanded(
              child: TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], //只允许输入数字
                  textAlign: TextAlign.right,
                  maxLength: 11,
                  controller: applyInfoModel.textContentMobile[index],
                  decoration: const InputDecoration(
                    // contentPadding:
                    // EdgeInsets.only(
                    //     bottom:
                    //     getHeightPx(27)),
                    counterText: "",
                    border: InputBorder.none,
                    hintText: '请输入手机号',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                  onChanged: (value) {
                    applyInfoModel.applyList[index]["mobile"] =
                        applyInfoModel.textContentMobile[index].text;
//                                                    applyInfoModel.applyAgentList[index]["mobile"] = applyInfoModel.textContentMobile[index].text;
                    applyInfoModel.notifyListeners();
                  }),
            ),
          ],
        )),

        _applyPeopleItemStyle(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('家庭地址',
                style: TextStyle(fontSize: 16, color: Colors.black87)),
            TextField(
                keyboardType: TextInputType.text,
                textAlignVertical: TextAlignVertical.center,
                maxLength: 50,
                maxLines: null,
                controller: applyInfoModel.textContentAddress[index],
                decoration: const InputDecoration(
                  counterText: "",
                  border: InputBorder.none,
                  hintText: '请输入家庭住址',
                  hintStyle: TextStyle(
                    fontSize: 14,
                  ),
                ),
                onChanged: (value) {
                  applyInfoModel.applyList[index]["address"] =
                      applyInfoModel.textContentAddress[index].text;
//                                            applyInfoModel.applyAgentList[index]["address"] = applyInfoModel.textContentAddress[index].text;
                  applyInfoModel.notifyListeners();
                })
          ],
        )),
      ],
    );
  }

  /// 代理人信息 和 申请人信息展示模块复用
  Widget _applyByOtherPeopleInformation(int isAgent) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Offstage(
          offstage: isAgent == 0,
          child: Container(
            height: getHeightPx(100),
            color: Color(0xfff2f5fa),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
            padding: EdgeInsets.fromLTRB(
                getWidthPx(20), getWidthPx(00), getWidthPx(20), getWidthPx(0)),
            child: Row(
              children: <Widget>[
                const Text(
                  "代理人信息",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Color(0xff5496e0)),
                ),
              ],
            ),
          ),
        ),
        ColoredBox(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              _itemWidget(
                title: isAgent == 1 ? "姓名" : "申请人",
                subTitle: userViewModel.userName != null
                    ? userViewModel.userName
                    : "",
              ),
              _itemWidget(
                  title: "身份证号",
                  subTitle:
                  userViewModel.idCard != null ? userViewModel.idCard : ""),
              _itemWidget(
                title: "性别",
                subTitle: userViewModel.gender == 1 ? '男' : "女",
              ),
              _itemWidget(
                  title: "出生日期",
                  subTitle: userViewModel.birthday != null
                      ? userViewModel.birthday
                      : ""),
              _itemWidget(
                  title: "手机号码",
                  subTitle:
                      userViewModel.mobile != null ? userViewModel.mobile : ""),
              Padding(
                  padding: EdgeInsets.only(
                      left: getWidthPx(40),
                      right: getWidthPx(40),
                      top: getWidthPx(30),
                      bottom: getHeightPx(10)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "家庭住址",
                        style:
                            TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                      ),
                      SizedBox(
                        height: getHeightPx(20),
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              userViewModel.address != null
                                  ? userViewModel.address
                                  : "",
                              style: const TextStyle(
                                  fontSize: 16, color: AppTheme.dark_grey),
                            ),
                          )
                        ],
                      ),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(bottom: getHeightPx(10)),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  width: 0.5, //宽度
                  color: Colors.black12, //边框颜色
                ))),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 代理人信息和申请人部分item分装
  Widget _itemWidget({String title, String subTitle}) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(
                left: getWidthPx(40),
                right: getWidthPx(40),
                top: getWidthPx(30)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title ?? '',
                  style:
                      const TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                ),
                Text(
                  // userModel.birthday != null
                  //     ? userModel.birthday
                  //     : "",
                  subTitle ?? '',
                  style:
                      const TextStyle(fontSize: 16, color: AppTheme.dark_grey),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: getHeightPx(30)),
            decoration: const BoxDecoration(
                border: Border(
                    bottom: BorderSide(
              width: 0.5, //宽度
              color: Colors.black12, //边框颜色
            ))),
          ),
        ],
      );

  /// 日期选择弹框
  void _selectTimeAlert(int index) {
    DatePicker.showDatePicker(context,
        // 是否展示顶部操作按钮
        showTitleActions: true,
        minTime: DateTime(1900, 11, 31),
        maxTime: new DateTime.now(), onChanged: (date) {
      wjPrint('change $date');
    },
        // 确定事件
        onConfirm: (date) {
      applyInfoModel.birthdayList[index] = "$date".toString().substring(0, 11);
      applyInfoModel.applyList[index]["birthday"] =
          "$date".toString().substring(0, 11);

      applyInfoModel.notifyListeners();
    },
        // 当前时间
        currentTime: DateTime.now(),
        // 语言
        locale: LocaleType.zh);
  }

  /// 申请人item 样式
  Widget _applyPeopleItemStyle({Widget child}) {
    return Padding(
      padding: EdgeInsets.only(
        left: getWidthPx(50),
        right: getWidthPx(50),
        bottom: getWidthPx(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          child,
          SizedBox(
            height: getWidthPx(10),
          ),
          Divider(
            height: 0.5,
            color: Colors.black12,
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
