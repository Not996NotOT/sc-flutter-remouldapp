import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/contract_entity.dart';
import 'package:notarization_station_app/page/home/entity/invitee_info_entity.dart';
import 'package:notarization_station_app/page/home/entity/notarial_office_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

class ContractPeopleModel extends SingleViewStateModel with ClientCallback {
  UserViewModel userViewModel;
  List notarialList = [];
  // 公证处的名称列表
  List<String> notarialNameList = [];
  Map notarialInfo;
  Map<String, List<TextEditingController>> textController = new HashMap();
  Timer timer2;
  ContractEntity orderInfo;
  List<InviteeInfoEntity> inviteeList = [];
  bool isInform = true;
  String adCode = '';
  String city;
  String latLng = '';
  Location location;

  /// 开始公证按钮状态控制
  bool isEnable = true;

  /// 获取当前ip信息
  String ipAddress = '';

  ContractPeopleModel(this.userViewModel) {
    // ignore: deprecated_member_use
    textController["name"] = new List<TextEditingController>();
    // ignore: deprecated_member_use
    textController["mobile"] = new List<TextEditingController>();
    // ignore: deprecated_member_use
    textController["idCard"] = new List<TextEditingController>();
    textController["name"].add(TextEditingController());
    textController["mobile"].add(TextEditingController());
    textController["idCard"].add(TextEditingController());
    inviteeList.add(InviteeInfoEntity());
  }

  addUserList(bool isAdd, {int i}) {
    if (isAdd) {
      textController["name"].add(TextEditingController());
      textController["mobile"].add(TextEditingController());
      textController["idCard"].add(TextEditingController());
      inviteeList.add(InviteeInfoEntity());
    } else {
      textController["name"].removeAt(i);
      textController["mobile"].removeAt(i);
      textController["idCard"].removeAt(i);
      inviteeList.removeAt(i);
    }
    notifyListeners();
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    MqttClientMsg.instance.setCallback(this);
    getLocation();
    // Future.delayed(Duration.zero, () {
    //   getContract();
    // });
    return null;
  }

  notarialUpdate(info) {
    notarialInfo = {
      "notarialName": info.notarialName,
      "unitGuid": info.unitGuid
    };
    notifyListeners();
  }

  getLocation() async {
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
          context: G.getCurrentContext(),
          titleText: "定位权限使用说明：",
          subTitleText: "用于获取当前位置信息",
          time: 2
      );
    }
    if (await Permission.location.request().isGranted) {
      location = await AmapLocation.instance.fetchLocation();
      print("位置信息：-----$location");
      if (location.province != null &&
          location.province.length > 0 &&
          location.city != null &&
          location.city.length > 0) {
        city = "${location.province} ${location.city}";
      }
      if (location.adCode != null) {
        if (location.adCode.length > 4) {
          adCode = "${location.adCode.substring(0, 4)}00";
        }
      }
      if (location.latLng.longitude != null && location.latLng.longitude != 0.0 &&
          location.latLng.latitude != null && location.latLng.latitude != 0.0) {
        latLng = "${location.latLng.longitude},${location.latLng.latitude}";
      } else {
        ipAddress = await G.getDeviceIPAddress();
      }
      notifyListeners();
      getNotarial();
    } else {
      ipAddress = await G.getDeviceIPAddress();
      G.showPermissionDialog(str: "访问定位权限");
    }
  }

  getHistoryNotarial() {
    Map<String, String> map = {
      //"userId":userViewModel.unitGuid
    };
    HomeApi.getSingleton().queryHistoryOffice(map).then((res) {
      if (res != null && res["code"] == 200) {
        notarialInfo = {
          "notarialName": res['items']['notarialName'],
          "unitGuid": res['items']['notaryId']
        };
        notifyListeners();
      }
    });
  }

  addHistoryNotarial() {
    Map<String, String> map = {
      "notaryId": notarialInfo['unitGuid'],
      // "userId":userViewModel.unitGuid,
    };
    HomeApi.getSingleton().historyNotarial(map);
  }

  // getContract() {
  //   EasyLoading.show();
  //   HomeApi.getSingleton().getContract({"idCard": userViewModel.idCard},
  //       errorCallBack: (e) {
  //     EasyLoading.dismiss();
  //   }).then((res) {
  //     print("----------------$res");
  //     EasyLoading.dismiss();
  //     if (res['item']['state'] == "200") {
  //       orderInfo = JsonConvert.fromJsonAsT(res['item']['notaryOrder']);
  //       showDialog(
  //         context: G.getCurrentState().overlay.context,
  //         builder: (context) {
  //           return AlertDialog(
  //             title: Text("合同公证提醒"),
  //             content: Text("你有个合同公证正在等待你的加入，请操作"),
  //             actions: <Widget>[
  //               // ignore: deprecated_member_use
  //               TextButton(
  //                 child: Text("确定"),
  //                 onPressed: () async {
  //                   if(!await Permission.camera.status.isGranted || !await Permission.speech.status.isGranted || !await Permission.storage.status.isGranted){
  //                     G.showCustomToast(
  //                         context: context,
  //                         titleText: "相机、麦克风、存储权限说明：",
  //                         subTitleText: "用于视频通话、语音录制、拍照、录像、文件存储等场景",
  //                         time: 2
  //                     );
  //                   }
  //                   if (await Permission.camera.request().isGranted &&
  //                       await Permission.speech.request().isGranted &&
  //                       await Permission.storage.request().isGranted) {
  //                     Navigator.of(context).pop();
  //                     Map<String, Object> map = {
  //                       "channelName": orderInfo.unitGuid
  //                     };
  //                     MineApi.getSingleton()
  //                         .getToken(map, errorCallBack: (e) {})
  //                         .then((res) {
  //                       if (res["code"] == 200) {
  //                         MqttClientMsg.instance.subscribe(
  //                             "/topic/hetong/${userViewModel.idCard}");
  //                         Config.aPPId = res['appId'];
  //                         Config.token = res['token'];
  //                         print(
  //                             "Config.aPPId-------${Config.aPPId},Config.token----${Config.token}");
  //                         orderInfo.roomId = "qtzh-${orderInfo.unitGuid}";
  //                         G.getCurrentState().pushReplacementNamed(
  //                             RoutePaths.ContractIng,
  //                             arguments: orderInfo);
  //                       }
  //                     });
  //                   } else {
  //                     G.showPermissionDialog(str: "访问内部存储、语音麦克风、相机、相册权限");
  //                   }
  //                 },
  //               ),
  //               // ignore: deprecated_member_use
  //               TextButton(
  //                 child: Text("退出"),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                   G
  //                       .getCurrentState()
  //                       .pushReplacementNamed(RoutePaths.HomeIndex);
  //                 },
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     } else {
  //       getLocation().then((value) {
  //         getNotarial();
  //         notifyListeners();
  //       });
  //     }
  //   });
  // }

  getNotarial() {
    notarialList.clear();
    notarialNameList.clear();
    EasyLoading.show();
    print(".........$adCode");
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
        NotarialOfficeEntity notarialInfo1 = JsonConvert.fromJsonAsT(res);
        if (notarialInfo1.code != 200) {
          return ToastUtil.showWarningToast(notarialInfo1.msg);
        }
        notarialList = notarialInfo1.items ?? [];

        if (notarialList.length == 0) {
          notarialNameList = [];
          ToastUtil.showNormalToast("此地区暂无公证处");
          notarialInfo = null;
        } else {
          notarialList.forEach((element) {
            notarialNameList.add(element.notarialName);
          });
        }
        notifyListeners();
      } else {
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  addOrder() async {
    if (notarialInfo == null) {
      return ToastUtil.showWarningToast("请选择公证处！");
    }
    //else if(!RegExp('^([\u4e00-\u9fa5]{1,20}|[a-zA-Z\.\s]{1,20})\$').hasMatch(textContentOne.text)){
    //       ToastUtil.showWarningToast("姓名格式不正确");
    //     }else if(textContentTwo.text.length<11||!RegExp('^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$').hasMatch(textContentTwo.text)){
    //       ToastUtil.showWarningToast("手机号不正确");
    //     }else if(!RegExp(r"\d{17}[\d|x]|\d{15}").hasMatch(textContentThree.text)){
    //       ToastUtil.showWarningToast("身份证不正确");
    //     }
    List tempAccountList = [];
    for (var i = 0; i < inviteeList.length; i++) {
      if (inviteeList[i].userName == "" || inviteeList[i].userName == null) {
        return ToastUtil.showWarningToast("请填写第${i + 1}被邀请人的账号");
      } else {
        tempAccountList.add(inviteeList[i].userName);
      }

      // else if (inviteeList[i].mobile == "" || inviteeList[i].mobile == null) {
      //   return ToastUtil.showWarningToast("请填写第${i + 1}被邀请人电话");
      // } else if (inviteeList[i].idCard == "" || inviteeList[i].idCard == null) {
      //   return ToastUtil.showWarningToast("请填写第${i + 1}被邀请人身份证");
      // }
    }

    String phoneInfo = await G.phoneInfo(latLng);
    EasyLoading.show(status: "正在安排公证员");
    DateTime now = new DateTime.now();
    String ipDependency = '';
    if (location != null && location.country != null) {
      if (location.country == '中国') {
        ipDependency = "${location.province}/${location.city}";
      } else {
        ipDependency = location.country;
      }
    }
    Map<String, String> map = {
      "nei": phoneInfo,
      //"userId": userViewModel.unitGuid,
      "name": userViewModel.userName,
      "useArea": "",
      "useLanguage": "",
      "purposeName": "",
      "notaryId": notarialInfo['unitGuid'],
      "isDaiBan": "0",
      "terminalType": "1",
      "isIos": "1",
      "notaryForm": "3",
      "description": "",
      "geoLongitude":latLng.isEmpty?'':latLng.split(',')[0],
      "geoLatitude":latLng.isEmpty?'':latLng.split(',')[1],
      "geoIp": ipAddress,
      "videolog": json.encode({
        "planDate": now.toString().substring(0, 10),
        'ipDependency': ipDependency
      }),
      "applyUsers": json.encode([
        {
          "name": userViewModel.userName,
          "gender": userViewModel.gender,
          "birthday": userViewModel.birthday,
          "idCard": userViewModel.idCard,
          "mobile": userViewModel.mobile,
        }
      ]),
      "thirdPartyAccount":json.encode(tempAccountList),
      // "thirdPartyUser": json.encode(inviteeList),
    };
    log("+++++++++$map");
    isEnable = false;
    notifyListeners();
    HomeApi.getSingleton().addOrder(map, errorCallBack: (e) {
      EasyLoading.dismiss();
      isEnable = true;
      notifyListeners();
    }).then((res) {
      if (res != null) {
        if (res['code'] != 200) {
          EasyLoading.dismiss();
          isEnable = true;
          notifyListeners();
          return ToastUtil.showWarningToast(res["msg"]);
        }
        print(".....................${res["unitGuid"]}......");
        orderInfo = JsonConvert.fromJsonAsT(res["unitGuid"]);
        sendNotarizeRequest();
      } else {
        isEnable = true;
        notifyListeners();
        EasyLoading.dismiss();
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  // 发起公证
  sendNotarizeRequest() {
    Map<String, dynamic> param = {
      'greffierIdCard': userViewModel.idCard,
      'notaryId': notarialInfo['unitGuid'],
      'type': 1,
    };
    HomeApi.getSingleton().getVideoNotarizationWaitHandleRemind(param,
        errorCallBack: (e) {
          EasyLoading.dismiss();
          isEnable = true;
          notifyListeners();
        }).then((value) {
      if (value != null) {
        if (value['code'] != 200) {
          EasyLoading.dismiss();
          isEnable = true;
          notifyListeners();
          return ToastUtil.showWarningToast(
              value['data'] ?? value['message'] ?? value['msg']);
        }
        MqttClientMsg.instance
            .subscribe("/topic/hetong/${userViewModel.idCard}");
        // addHistoryNotarial();
        timer2 = Timer(new Duration(seconds: 60), () {
          //如果60s内不接单
          try {
            MqttClientMsg.instance
                ?.unsubscribe("/topic/hetong/${userViewModel.idCard}");
          } catch (e) {
            log("结束报错了$e");
          }
          isEnable = true;
          notifyListeners();
          cancelOrder();
          EasyLoading.dismiss();
        });
      } else {
        EasyLoading.dismiss();
        isEnable = true;
        notifyListeners();
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  cancelOrder() {
    Map<String, String> map2 = {"unitGuid": orderInfo.unitGuid};
    HomeApi.getSingleton()
        .shutVideoOrder(map2, errorCallBack: (e) {})
        .then((res2) {
      if (res2 != null) {
        if (res2['code'] != 200) {
          return ToastUtil.showWarningToast("请求失败，稍后再试！");
        }
        ToastUtil.showNormalToast("公证员正在忙碌请稍后再试！");
      } else {
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  @override
  void clientDataHandler(onData, topic) {
    print('MQTT的消息...$onData....$topic');
    if (topic == "hetong") {
      var orderData = json.decode(onData);
      if (orderData['code'] == 'dontWiting') {
        timer2.cancel();
        orderInfo.roomId = orderData['roomId'];
        orderInfo.greffierName = orderData['greffierName'];
        print("orderInfo.roomId--------${orderInfo.toString()}");
        EasyLoading.dismiss();
        isEnable = true;
        notifyListeners();
        Map<String, Object> map = {"channelName": orderData["roomId"]};
        MineApi.getSingleton().getToken(map).then((res) {
          if (res["code"] == 200) {
            Config.aPPId = res['appId'];
            Config.token = res['token'];
            G.getCurrentState().pushReplacementNamed(RoutePaths.ContractIng,
                arguments: orderInfo);
          }
        });
      }
    }
  }
}
