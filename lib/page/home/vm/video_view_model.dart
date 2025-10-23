import 'dart:async';
import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/generated/json/Notarial_status_model.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/notarial_office_entity.dart';
import 'package:notarization_station_app/page/home/entity/video_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoViewModel extends SingleViewStateModel with ClientCallback {
  final UserViewModel userViewModel;
  VideoViewModel(this.userViewModel);
  List notarialList = [];
  List notarialStatusList = [];
  List<String> notarialOfficeNameList = []; //公证处名称列表

  Map notarialInfo;
  VideoEntity orderInfo;
  Timer timer2;
  bool isInform = true;
  String adCode = '';
  String city;
  String latLng = '';

  Location location;

  Timer timer1;
  int second = 10;

  Timer timer3;
  int secondCount = 10;

  bool isFireRequest = false;

  /// 获取当前ip信息
  String ipAddress = '';

  NotarialStatusModel notarialStatusModel;

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    MqttClientMsg.instance.setCallback(this);
    // initRefreshData();
    return null;
  }

  // 根据位置信息获取公证处列表
  getNotarialOfficeList() async {
    Future.delayed(Duration.zero, () {
      getLocation().then((value) {
        if (city != null && city.isNotEmpty && city.length > 0) {
          getNotarial();
        }
        notifyListeners();
      });
    });
  }

  initRefreshData() {
    timer1 = Timer.periodic(const Duration(seconds: 1), (timer) {
      second--;
      if (second == 0) {
        second = 10;
        print('123132132132');
        getListNotaryStatusData();
      }
    });
  }

  void autoRefreshGetListNotaryStatusData() {
    EasyLoading.show();
    timer3 = Timer.periodic(const Duration(seconds: 1), (timer) {
      secondCount--;
      if (secondCount == 0) {
        secondCount = 10;
        timer.cancel();
        print('4564564564546464545');
      }
      EasyLoading.dismiss();
      notifyListeners();
    });

    getListNotaryStatusData();
  }

  notarialUpdate(info) {
    notarialInfo = {
      "notarialName": info.notarialName,
      "unitGuid": info.unitGuid
    };
    getListNotaryStatusData();
    timer1?.cancel();
    initRefreshData();
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
      print("高德的位置信息：-----$location");
      if (location.province != null &&
          location.province.length > 0 &&
          location.city != null &&
          location.city.length > 0) {
        city = "${location.province} ${location.city}";
      }
      if (location.adCode != null) {
        adCode = "${location.adCode.substring(0, 4)}00";
      }
      if (location.latLng.longitude != null && location.latLng.longitude != 0.0 &&
          location.latLng.latitude != null && location.latLng.latitude != 0.0) {
        latLng = "${location.latLng.longitude},${location.latLng.latitude}";
      } else {
        ipAddress = await G.getDeviceIPAddress();
      }
    } else {
      ipAddress = await G.getDeviceIPAddress();
      G.showPermissionDialog(str: "访问定位权限");
    }
  }

  // 获取公证员列表
  getListNotaryStatusData() {
    Map<String, dynamic> param = {'notaryId': notarialInfo['unitGuid']};
    HomeApi.getSingleton().getListNotaryStatus(param).then((value) {
      if (value != null && value['code'] == 200) {
        if (value['data'] != null) {
          final tempResult = value['data'];
          List tempList = [];
          tempResult.forEach((e) {
            tempList.add(NotarialStatusModel.fromJson(e));
          });
          notarialStatusList = tempList;
          if (notarialStatusModel != null) {
            wjPrint("notarialStatusModel-------${notarialStatusModel.toJson()}");
            notarialStatusList.forEach((element) {
              if (element.userName == notarialStatusModel.userName) {
                element.isVideo = false;
              }
            });
          }
        } else {
          notarialStatusList.clear();
        }
        notifyListeners();
      } else {
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  getNotarial() {
    notarialList.clear();
    notarialStatusList.clear();
    notarialOfficeNameList.clear();
    EasyLoading.show(status: "正在获取公证处列表");
    Map<String, String> map = {
      "institutionType": "1",
      "cityCode": adCode,
    };
    print(".......$map");
    if (!isFireRequest) {
      isFireRequest = true;
      try {
        HomeApi.getSingleton().getNotarialOffice(map, errorCallBack: (e) {
          EasyLoading.dismiss();
          isFireRequest = false;
        }).then((res) {
          isFireRequest = false;
          EasyLoading.dismiss();
          if (res != null) {
            NotarialOfficeEntity notarialInfo1 = JsonConvert.fromJsonAsT(res);
            if (notarialInfo1.code != 200) {
              return ToastUtil.showWarningToast(notarialInfo1.msg);
            }
            notarialList = notarialInfo1.items ?? [];
            if (notarialList != null && notarialList.isNotEmpty) {
              notarialList.forEach((element) {
                notarialOfficeNameList.add(element.notarialName);
              });
            }
            if (notarialList.length == 0) {
              ToastUtil.showNormalToast("此地区暂无公证处");
              notarialInfo = null;
              notifyListeners();
            }
          } else {
            ToastUtil.showWarningToast("请求失败，稍后再试！");
          }
        });
      } catch (e) {
        isFireRequest = false;
        EasyLoading.dismiss();
      }
    }
  }

  addOrder(
      {String cardId,
      String notaryPublicId,
      int type,
      Function success,
      Function failure}) async {
    if (notarialInfo == null) {
      return ToastUtil.showWarningToast("请选择公证处！！");
    }
    String phoneInfo = await G.phoneInfo(latLng);
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
      "notaryForm": "2",
      "description": "",
      "notaryPublicId": notaryPublicId,
      "videolog": json.encode({
        "planDate": now.toString().substring(0, 10),
        'ipDependency': ipDependency
      }),
      "geoLongitude":latLng.isEmpty?'':latLng.split(',')[0],
      "geoLatitude":latLng.isEmpty?'':latLng.split(',')[1],
      "geoIp": ipAddress,
      "applyUsers": json.encode([
        {
          "name": userViewModel.userName,
          "gender": userViewModel.gender,
          "birthday": userViewModel.birthday,
          "idCard": userViewModel.idCard,
          "mobile": userViewModel.mobile,
          "address": userViewModel.address,
        }
      ])
    };
    print('公证入参$map');
    EasyLoading.show();
    HomeApi.getSingleton().addOrder(map, errorCallBack: (e) {
      EasyLoading.dismiss();
      int index = notarialStatusList.indexOf(notarialStatusModel);
      notarialStatusList[index].isVideo = true;
      notarialStatusModel = null;
      notifyListeners();
    }).then((res) {
      EasyLoading.dismiss();
      if (res != null) {
        orderInfo = JsonConvert.fromJsonAsT(res);
        if (orderInfo.code != 200) {
          notarialStatusModel = null;
          return ToastUtil.showWarningToast(orderInfo.msg);
        }
        if (orderInfo.unitGuid.currentState == 0) {
          sendNotarizeRequest(
              cardId: cardId, type: type, success: success, failure: failure);
        } else if (orderInfo.unitGuid.currentState == 1) {
          ToastUtil.showWarningToast('当前公证人员正在忙碌中请稍后再试！');
          notarialStatusModel = null;
          changeButtonState();
        } else if (orderInfo.unitGuid.currentState == 2) {
          ToastUtil.showWarningToast('当前公证人员已离开，请稍后再试！');
          changeButtonState();
          notarialStatusModel = null;
        } else {
          ToastUtil.showWarningToast('当前公证人员已离线！');
          changeButtonState();
          notarialStatusModel = null;
        }
        getListNotaryStatusData();
        return;
      } else {
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  /// 改变按钮状态
  void changeButtonState() {
    notarialStatusList.forEach((element) {
      if (notarialStatusModel != null){
        if (element.userName == notarialStatusModel.userName) {
          element.isVideo = true;
        }
      }
    });
    notifyListeners();
  }

  // 发起公证
  sendNotarizeRequest(
      {String cardId, int type, Function success, Function failure}) {
    Map<String, dynamic> param = {
      'greffierIdCard': cardId,
      'notaryId': notarialInfo['unitGuid'],
      'type': type,
    };
    HomeApi.getSingleton().getVideoNotarizationWaitHandleRemind(param,
        errorCallBack: (e) {
      EasyLoading.dismiss();
      changeButtonState();
      notarialStatusModel = null;
    }).then((value) {
      EasyLoading.dismiss();
      if (value != null) {
        if (value['code'] != 200) {
          EasyLoading.dismiss();
          changeButtonState();
          notarialStatusModel = null;
          return ToastUtil.showWarningToast(
              value['data'] ?? value['message'] ?? value['msg']);
        }
        if (type == 1) {
          success();
          print('发起视频公证');
          MqttClientMsg.instance
              .subscribe("/topic/shiping/${userViewModel.idCard}");
          // addHistoryNotarial();
          timer2 = Timer(new Duration(seconds: 60), () {
            //如果60s内不接单
            try {
              print('视频连接超时！');
              failure();
            } catch (e) {
              log("结束报错了$e");
            }
            EasyLoading.dismiss();
          });
        }
        if (type == 2) {
          MqttClientMsg.instance
              ?.unsubscribe("/topic/shiping/${userViewModel.idCard}");
          cancelOrder();
          print('取消视频公证');
        }
      } else {
        EasyLoading.dismiss();
        changeButtonState();
        notarialStatusModel = null;
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  cancelOrder() {
    Map<String, String> map2 = {"unitGuid": orderInfo.unitGuid.unitGuid};
    HomeApi.getSingleton().shutVideoOrder(map2, errorCallBack: (e) {
      changeButtonState();
      notarialStatusModel = null;
    }).then((res2) {
      if (res2 != null) {
        if (res2['code'] != 200) {
          changeButtonState();
          notarialStatusModel = null;
          return ToastUtil.showWarningToast(orderInfo.msg);
        }
        // ToastUtil.showNormalToast("公证员正在忙碌请稍后再试！");
      } else {
        changeButtonState();
        notarialStatusModel = null;
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  @override
  void clientDataHandler(onData, topic) {
    print('MQTT的消息...$onData....$topic');
    // Wakelock.enable();
    if (topic == "shiping") {
      var orderData = json.decode(onData);
      if (orderData['code'] == 'dontWiting' && isInform) {
        isInform = false;
        timer2.cancel();
        EasyLoading.dismiss();
        // MqttClientMsg.instance.postMessage("我是我",".topic.shiping.collect");
        Map<String, Object> map = {"channelName": orderData["roomId"]};
        MineApi.getSingleton().getToken(map).then((res) {
          if (res["code"] == 200) {
            Config.aPPId = res['appId'];
            Config.token = res['token'];
            // 直播
            timer1?.cancel();
            notarialStatusModel = null;
            G
                .getCurrentState()
                .pushReplacementNamed(RoutePaths.VideoIng, arguments: {
              "roomId": orderData["roomId"],
              "orderInfo": orderInfo,
              "greffierName": orderData["greffierName"]
            });
          }
        });
      }
    }
  }
}
