import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_picker/picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/notarial_office_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/bottom_alert_search_list.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/common_tools.dart';

class AddAppointmentPage extends StatefulWidget {
  @override
  _AddAppointmentPageState createState() => _AddAppointmentPageState();
}

class _AddAppointmentPageState extends BaseState<AddAppointmentPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textEditingController = TextEditingController();
  UserViewModel userInfo;
  List notarialList = [];
  // 公证处名称列表
  List<String> notarialNameList = [];

  Map notarialInfo = {};
  String timeDate = "";
  String timeQuantum = "";
  bool isNowTime = true;
  String adCode = '';
  String city;
  String latLng = '';

  bool isEnable = true;

  @override
  void initState() {
    super.initState();
  }

  Future<void> changeLanguage() async {
    // await showDialog<Map>(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return SimpleDialog(
    //         title: Text('请选择公证处'),
    //         children: notarialList.map((e) {
    //           return SimpleDialogOption(
    //             onPressed: () {
    //               notarialInfo = {
    //                 "notarialName": e.notarialName,
    //                 "unitGuid": e.unitGuid
    //               };
    //               setState(() {});
    //               Navigator.pop(context);
    //
    //             },
    //             child: Container(
    //               decoration: BoxDecoration(
    //                 border: Border(
    //                     bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
    //               ),
    //               padding: EdgeInsets.symmetric(vertical: 6),
    //               child: Text(e.notarialName),
    //             ),
    //           );
    //         }).toList(),
    //       );
    //     });

    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return BottomAlertSearchList(
            holderString: "请输入你要搜索的公证处",
            selectValueCallBack: (value) {
              wjPrint("value---------$value");
              notarialList.forEach((element) {
                if (element.notarialName == value) {
                  setState(() {
                    notarialInfo = {
                      "notarialName": element.notarialName,
                      "unitGuid": element.unitGuid
                    };
                  });
                }
              });
            },
            dataSource: notarialNameList,
          );
        });
  }

  getLocation() async {
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
        context: context,
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,);
    }
    if (await Permission.location.request().isGranted) {
      Location location = await AmapLocation.instance.fetchLocation();
      wjPrint("位置信息：-----$location");
      city = "${location.province??''} ${location.city??''}";
      adCode = "${location.adCode.substring(0, 4)}00";
      latLng = "${location.latLng.longitude},${location.latLng.latitude}";
      getNotarial();
      // getHistoryNotarial();
      setState(() {});
    } else {
      G.showPermissionDialog(str: "访问定位权限");
    }
  }

  getHistoryNotarial() {
    Map<String, String> map = {
      //"userId":userInfo.unitGuid
    };
    HomeApi.getSingleton().queryHistoryOffice(map).then((res) {
      if (res != null && res["code"] == 200) {
        notarialInfo = {
          "notarialName": res['items']['notarialName'],
          "unitGuid": res['items']['notaryId']
        };
        setState(() {});
      }
    });
  }

  addHistoryNotarial() {
    Map<String, String> map = {
      "notaryId": notarialInfo['unitGuid'],
      //"userId":userInfo.unitGuid,
    };
    HomeApi.getSingleton().historyNotarial(map);
  }

  getNotarial() {
    notarialList.clear();
    notarialNameList.clear();
    EasyLoading.show();
    Map<String, String> map = {
      "institutionType": "1",
      "cityCode": adCode,
      "origins": latLng
    };
    HomeApi.getSingleton().getNotarialOffice(map, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((res) {
      EasyLoading.dismiss();
      if (res != null) {
        NotarialOfficeEntity notarialInfor = JsonConvert.fromJsonAsT(res);
        if (notarialInfor.code != 200) {
          return ToastUtil.showWarningToast(notarialInfor.msg);
        }
        notarialList = notarialInfor.items ?? [];
        if (notarialList.length == 0) {
          notarialNameList = [];
          ToastUtil.showNormalToast("此地区暂无公证处");
          notarialInfo = null;
        } else {
          notarialList.forEach((element) {
            notarialNameList.add(element.notarialName);
          });
        }
        setState(() {});
      } else {
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  showPicker(BuildContext context) {
    Picker picker = new Picker(
      headerDecoration: BoxDecoration(
        //背景
        color: AppTheme.bg_b,
        borderRadius: BorderRadius.all(Radius.circular(4.0)),
      ),
      cancelText: "取消",
      confirmText: "确定",
      adapter: PickerDataAdapter<String>(
          pickerData: new JsonDecoder().convert(pickerData())),
      changeToFirst: true,
      textAlign: TextAlign.left,
      columnPadding: const EdgeInsets.all(15),
      onConfirm: (Picker picker, List value) {
        timeQuantum = picker.getSelectedValues()[0];
        setState(() {});
      },
    );
    picker.show(_scaffoldKey.currentState);
  }

  String pickerData() {
    String data = '''
    ["9:00-9:30","9:30-10:00","10:00-10:30","10:30-11:00","11:00-11:30","11:30-12:00","12:00-12:30","12:30-13:00","13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
    ''';
    if (isNowTime) {
      DateTime time = DateTime.now();
      if (time.hour == 9) {
        if (time.minute < 30) {
          data = '''
            ["9:30-10:00","10:00-10:30","10:30-11:00","11:00-11:30","11:30-12:00","12:00-12:30","12:30-13:00","13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        } else {
          data = '''
            ["10:00-10:30","10:30-11:00","11:00-11:30","11:30-12:00","12:00-12:30","12:30-13:00","13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        }
      } else if (time.hour == 10) {
        if (time.minute < 30) {
          data = '''
            ["10:30-11:00","11:00-11:30","11:30-12:00","12:00-12:30","12:30-13:00","13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        } else {
          data = '''
            ["11:00-11:30","11:30-12:00","12:00-12:30","12:30-13:00","13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        }
      } else if (time.hour == 11) {
        if (time.minute < 30) {
          data = '''
            ["11:30-12:00","12:00-12:30","12:30-13:00","13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        } else {
          data = '''
            ["12:00-12:30","12:30-13:00","13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        }
      } else if (time.hour == 12) {
        if (time.minute < 30) {
          data = '''
            ["12:30-13:00","13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        } else {
          data = '''
            ["13:00-13:30","13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        }
      } else if (time.hour == 13) {
        if (time.minute < 30) {
          data = '''
            ["13:30-14:00","14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        } else {
          data = '''
            ["14:00-14:30","14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        }
      } else if (time.hour == 14) {
        if (time.minute < 30) {
          data = '''
            ["14:30-15:00","15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        } else {
          data = '''
            ["15:00-15:30","15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        }
      } else if (time.hour == 15) {
        if (time.minute < 30) {
          data = '''
            ["15:30-16:00","16:00-16:30","16:30-17:00"]
          ''';
        } else {
          data = '''
            ["16:00-16:30","16:30-17:00"]
          ''';
        }
      } else if (time.hour == 16) {
        if (time.minute < 30) {
          data = '''
            ["16:30-17:00"]
          ''';
        }
      }
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () {
       getLocation();
      },
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          key: _scaffoldKey,
          appBar: commonAppBar(title: "新增预约"),
          body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
            userInfo = userModel;
            return Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(getWidthPx(30)),
                          child: Text(
                            '预约信息',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xff5496e0)),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            AlertView.showCityPickerView(context,resultCallBack: (CityResult msg){
                              wjPrint("showCityPickerView/位置信息：-----$msg");
                              if (msg != null) {
                                city = "${msg.province} ${msg.city}";
                                adCode = "${msg.cityCode}";
                                getNotarial();
                                setState(() {});
                              }
                            },locationCode: '320100');
                            // Result result = await CityPickers.showCityPicker(
                            //   context: context,
                            //   height: 300.0,
                            //   locationCode: '320100',
                            //   showType: ShowType.pc,
                            // );
                            // wjPrint("位置信息：-----$result");
                            // if (result != null) {
                            //   city = "${result.provinceName} ${result.cityName}";
                            //   adCode = "${result.cityId}";
                            //   getNotarial();
                            //   setState(() {});
                            // }
                          },
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(getWidthPx(40),
                                getWidthPx(20), getWidthPx(20), getWidthPx(20)),
                            child: Row(
                              children: [
                                const Text(
                                  "当前城市：",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                  city ?? '请点击选择',
                                  style: TextStyle(
                                      fontSize: 16, color: AppTheme.Text_min),
                                  textAlign: TextAlign.right,
                                )),
                                const Icon(
                                  Icons.chevron_right,
                                  color: AppTheme.Text_min,
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            if (notarialList.length != 0) {
                              changeLanguage();
                            } else {
                              ToastUtil.showErrorToast("该城市无可办理公证的公证处");
                            }
                          },
                          child: Container(
                            color: Colors.white,
                            padding: EdgeInsets.fromLTRB(getWidthPx(40),
                                getWidthPx(20), getWidthPx(20), getWidthPx(20)),
                            child: Row(
                              children: [
                                const Text(
                                  "选择公证处：",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                    child: Text(
                                  notarialInfo == null || notarialInfo.isEmpty
                                      ? '请点击选择'
                                      : notarialInfo['notarialName'] ?? '',
                                  style: TextStyle(
                                      fontSize: 16, color: AppTheme.Text_min),
                                  textAlign: TextAlign.right,
                                )),
                                Icon(
                                  Icons.chevron_right,
                                  color: AppTheme.Text_min,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(getWidthPx(40),
                              getWidthPx(20), getWidthPx(20), getWidthPx(20)),
                          child: Row(
                            children: <Widget>[
                              const Text("选择日期:  ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87)),
                              Expanded(
                                flex: 4,
                                child: InkWell(
                                  onTap: () {
                                    wjPrint("点击了选择日期");
                                    DatePicker.showDatePicker(context,
                                        // 是否展示顶部操作按钮
                                        showTitleActions: true,
                                        minTime: DateTime.now().isBefore(DateTime(
                                                DateTime.now().year,
                                                DateTime.now().month,
                                                DateTime.now().day,
                                                16,
                                                30))
                                            ? DateTime.now()
                                            : DateTime.now()
                                                .add(Duration(hours: 10)),
                                        onChanged: (date) {
                                      wjPrint('change $date');
                                    },
                                        // 确定事件
                                        onConfirm: (date) {
                                      timeDate =
                                          "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                                      isNowTime = date.year ==
                                              DateTime.now().year &&
                                          date.month == DateTime.now().month &&
                                          date.day == DateTime.now().day;
                                      wjPrint(
                                          "0..........${date.year == DateTime.now().year && date.month == DateTime.now().month && date.day == DateTime.now().day}");
                                      setState(() {});
                                    },
                                        // 当前时间
                                        currentTime: DateTime.now(),
                                        // 语言
                                        locale: LocaleType.zh);
                                  },
                                  child: Text(
                                    timeDate.isEmpty ? "请点击选择日期" : timeDate,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.Text_min,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppTheme.Text_min,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(getWidthPx(40),
                              getWidthPx(20), getWidthPx(20), getWidthPx(20)),
                          child: Row(
                            children: <Widget>[
                              const Text("选择时间段:  ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black87)),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (timeDate.isNotEmpty) {
                                      showPicker(context);
                                    } else {
                                      ToastUtil.showNormalToast("请选择日期！");
                                    }
                                  },
                                  child: Text(
                                    timeQuantum.isEmpty
                                        ? "请点击选择时间段"
                                        : timeQuantum,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.Text_min,
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),
                              const Icon(
                                Icons.chevron_right,
                                color: AppTheme.Text_min,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.fromLTRB(getWidthPx(40),
                              getWidthPx(20), getWidthPx(20), getWidthPx(20)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              const Padding(
                                padding: EdgeInsets.only(top: 13),
                                child: Text("备注:  ",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.black87)),
                              ),
                              Expanded(
                                child: TextFormField(
                                  decoration: const InputDecoration(
                                    hintText: "请输入备注内容",
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(
                                      fontSize: 16.0, color: Color(0xff606266)),
                                  controller: textEditingController,
                                  // cursorColor: Color(0xff00c295),
                                  scrollPadding:
                                      EdgeInsets.only(top: 0.0, bottom: 6.0),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.deny(RegExp(
                                        "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]")),
                                    LengthLimitingTextInputFormatter(200)
                                  ],
                                  minLines: 1,
                                  maxLines: 4,
                                  maxLength: 25,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(getWidthPx(20)),
                          child: const Text(
                            '申请人信息',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color(0xff5496e0)),
                          ),
                        ),
                        ColoredBox(
                          color: Colors.white,
                          child: Column(
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(
                                  border: const Border(
                                      bottom: BorderSide(
                                          width: 1, color: AppTheme.bg_c)),
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
                                    const Text('本人名字',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black87)),
                                    Expanded(
                                      child: Text(
                                        userInfo.userName == null ||
                                                userInfo.userName == ""
                                            ? "当事人"
                                            : userInfo.userName,
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.Text_min),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border: const Border(
                                      bottom: BorderSide(
                                          width: 1, color: AppTheme.bg_c)),
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
                                    const Text('身份证号',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black87)),
                                    Expanded(
                                      child: Text(
                                        userInfo.idCard ?? '',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.Text_min),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
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
                                padding: EdgeInsets.fromLTRB(
                                    getWidthPx(40),
                                    getWidthPx(20),
                                    getWidthPx(40),
                                    getWidthPx(20)),
                                child: Row(
                                  children: <Widget>[
                                    const Text('手机号码',
                                        style: TextStyle(
                                            fontSize: 16, color: Colors.black87)),
                                    Expanded(
                                      child: Text(
                                        userInfo.mobile ?? '',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: AppTheme.Text_min),
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                DebounceButton(
                  clickTap: () {
                    if (notarialInfo.isEmpty) {
                      ToastUtil.showNormalToast("请选择公证处！");
                    } else if (timeDate.isEmpty) {
                      ToastUtil.showNormalToast("请选择日期！");
                    } else if (timeQuantum.isEmpty) {
                      ToastUtil.showNormalToast("请选择时间段！");
                    } else {
                      EasyLoading.show();
                      setState(() {
                        isEnable = false;
                      });
                      Map<String, String> map = {
                        "userName": userInfo.userName,
                        "mobile": userInfo.mobile,
                        "idCard": userInfo.idCard,
                        "deviceType": "2",
                        "processingTime": "$timeDate $timeQuantum",
                        "notaryId": notarialInfo['unitGuid'],
                        "remarks": textEditingController.text
                      };
                      HomeApi.getSingleton().addAppointment(map,
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
                        if (res['code'] == 200) {
                          ToastUtil.showSuccessToast("添加成功！");
                          G.pop();
                        } else {
                          ToastUtil.showWarningToast("添加失败，稍后再试！");
                        }
                      });
                    }
                  },
                  isEnable: isEnable,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  margin: EdgeInsets.fromLTRB(getWidthPx(40), 0, getWidthPx(40),
                      getWidthPx(10) + MediaQuery.of(context).padding.bottom),
                  padding: EdgeInsets.all(10),
                  child: Text('新增预约',
                      style:
                          TextStyle(fontSize: 16, color: AppTheme.nearlyWhite)),
                )
              ],
            );
          })),
    );
  }
}
