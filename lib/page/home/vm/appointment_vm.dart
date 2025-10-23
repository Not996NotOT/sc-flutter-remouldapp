import 'dart:async';
import 'dart:convert';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/page/home/entity/video_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../config.dart';

class AppointmentViewModel extends SingleViewStateModel with ClientCallback {
  List appointmentLists = []; //公证列表
  RefreshController refreshController = RefreshController();
  UserViewModel userModel;
  int pageNum = 1;
  String pageSize = "10";
  Timer timer2;
  bool isInform = true;
  VideoEntity orderInfo;
  String latLng = "";

  /// 获取当前ip信息
  String ipAddress = '';
  Location location;

  // 开始公证按钮状态控制
  bool isEnable = true;

  // 选中的公证处数据
  Map selectMap = {};

  AppointmentViewModel(this.userModel);

  getAppointmentLists() {
    pageNum = 1;
    var map = {
      "currentPage": pageNum.toString(),
      "pageSize": pageSize,
      "idCard": userModel.idCard,
    };
    print("..........$map");
    HomeApi.getSingleton().appointmentList(map, errorCallBack: (e) {
      setBusy(false);
    }).then((data) {
      setBusy(false);
      if (data["code"] == 200) {
        appointmentLists?.clear();
        appointmentLists = data["items"];
      }
      notifyListeners();
    });
  }

  getLocation() async {
    if (!await Permission.location.status.isGranted) {
      G.showCustomToast(
        context: G.getCurrentContext(),
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,
      );
    }
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Location location = await AmapLocation.instance.fetchLocation();
      wjPrint("位置信息：-----$location");
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

  addOrder(order) async {
    EasyLoading.show(status: "正在安排公证员");
    String ipDependency = '';
    DateTime now = new DateTime.now();
    if (location != null && location.country != null) {
      if (location.country == '中国') {
        ipDependency = "${location.province}/${location.city}";
      } else {
        ipDependency = location.country;
      }
    }
    MqttClientMsg.instance.setCallback(this);
    String phoneInfo = await G.phoneInfo(latLng);
    Map<String, dynamic> map = {
      "nei": phoneInfo,
      "idCard": order['idCard'],
      "name": order['userName'],
      "mobile": order['mobile'],
      "notaryPublicId": order['notaryPublicId'],
      "notaryId": order['notaryId'],
      "geoLongitude":latLng.isEmpty?'':latLng.split(',')[0],
      "geoLatitude":latLng.isEmpty?'':latLng.split(',')[1],
      "geoIp": ipAddress,
      "isDaiBan": 0,
      "terminalType": 1,
      "videolog": json.encode({
        "planDate": now.toString().substring(0, 10),
        'ipDependency': ipDependency
      }),
      "notaryForm": 2,
      "orderNo": order['orderNo']
    };
    notifyListeners();
    print(map);
    HomeApi.getSingleton().appointmentOrder(map, errorCallBack: (e) {
      EasyLoading.dismiss();
      selectMap = {};
      notifyListeners();
    }).then((res) {
      if (res != null) {
        orderInfo = JsonConvert.fromJsonAsT(res);
        if (orderInfo.code != 200) {
          EasyLoading.dismiss();
          selectMap = {};
          notifyListeners();
          return ToastUtil.showWarningToast(orderInfo.msg);
        }
        sendNotarizeRequest(
            idCard: order['notaryPublicIdCard'], notaryId: order['notaryId']);
        // if(orderInfo.unitGuid.currentState ==0){
        // }else if(orderInfo.unitGuid.currentState == 1){
        //   ToastUtil.showWarningToast('当前公证人员正在忙碌中请稍后再试！');
        // }else if(orderInfo.unitGuid.currentState == 2){
        //   ToastUtil.showWarningToast('当前公证人员已离开，请稍后再试！');
        // }else{
        //   ToastUtil.showWarningToast('当前公证人员已离线！');
        // }
        // MqttClientMsg.instance.subscribe("/topic/shiping/${userModel.idCard}");
        // timer2 = Timer(new Duration(seconds: 60), () {
        //   //如果60s内不接单
        //   cancelOrder();
        //   EasyLoading.dismiss();
        // });
      } else {
        EasyLoading.dismiss();
        selectMap = {};
        notifyListeners();
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  // 发起公证
  sendNotarizeRequest({String idCard, String notaryId}) {
    Map<String, dynamic> param = {
      'greffierIdCard': idCard,
      'notaryId': notaryId,
      'type': 1,
    };
    HomeApi.getSingleton().getVideoNotarizationWaitHandleRemind(param,
        errorCallBack: (e) {
      selectMap = {};
      EasyLoading.dismiss();
      notifyListeners();
    }).then((value) {
      if (value != null) {
        if (value['code'] != 200) {
          selectMap = {};
          EasyLoading.dismiss();
          notifyListeners();
          return ToastUtil.showWarningToast(
              value['data'] ?? value['message'] ?? value['msg']);
        }
        print('发起视频公证');
        MqttClientMsg.instance.subscribe("/topic/shiping/${userModel.idCard}");
        // addHistoryNotarial();
        timer2 = Timer(new Duration(seconds: 60), () {
          selectMap = {};
          EasyLoading.dismiss();
          notifyListeners();
          MqttClientMsg.instance
              ?.unsubscribe("topic/shiping/${userModel.idCard}");
          cancelOrder();
          print('取消视频公证');
          //如果60s内不接单
          try {
            print('视频连接超时！');
          } catch (e) {
            log("结束报错了$e");
          }
        });
      } else {
        selectMap = {};
        EasyLoading.dismiss();
        notifyListeners();
        ToastUtil.showWarningToast("请求失败，稍后再试！");
      }
    });
  }

  cancelOrder() {
    Map<String, String> map2 = {"unitGuid": orderInfo.unitGuid.unitGuid};
    HomeApi.getSingleton()
        .shutVideoOrder(map2, errorCallBack: (e) {})
        .then((res2) {
      if (res2 != null) {
        if (res2['code'] != 200) {
          return ToastUtil.showWarningToast(orderInfo.msg);
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
    selectMap = {};
    notifyListeners();
    if (topic == "shiping") {
      var orderData = json.decode(onData);
      if (orderData['code'] == 'dontWiting') {
        timer2.cancel();
        EasyLoading.dismiss();
        Map<String, Object> map = {"channelName": orderData["roomId"]};
        MineApi.getSingleton().getToken(map, errorCallBack: (e) {}).then((res) {
          if (res["code"] == 200) {
            Config.aPPId = res['appId'];
            Config.token = res['token'];
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

  Future loadData() async {
    setBusy(true);
  }

  refresh() async {
    pageNum = 1;
    refreshController.resetNoData();
    var map = {
      "currentPage": pageNum.toString(),
      "notaryForm": "2",
      "pageSize": pageSize,
      "idCard": userModel.idCard
    };
    HomeApi.getSingleton().appointmentList(map, errorCallBack: (e) {
      refreshController.refreshFailed();
      setBusy(false);
    }).then((data) {
      appointmentLists = data["items"];
      refreshController.refreshCompleted();
      notifyListeners();
    }).whenComplete(() {
      refreshController.loadComplete();
      setBusy(false);
    });
  }

  loadMore() async {
    pageNum += 1;
    var map = {
      "currentPage": pageNum.toString(),
      "pageSize": pageSize,
      "idCard": userModel.idCard,
    };
    HomeApi.getSingleton().appointmentList(map).then((data) {
      data["items"].forEach((i) {
        appointmentLists.add(i);
      });
      if (data["items"].isEmpty) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
        notifyListeners();
      }
    });
  }

  @override
  onCompleted(data) {
    if (data.items == null || data.items.length == 0) {
      setEmpty();
    } else {
      data["items"].forEach((i) {
        appointmentLists.add(i);
      });
    }
  }
}
