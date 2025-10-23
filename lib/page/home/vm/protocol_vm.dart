import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/home/entity/contract_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProtocolViewModel extends SingleViewStateModel {
  List appointmentLists = []; //公证列表
  RefreshController refreshController = RefreshController();
  UserViewModel userModel;
  int pageNum = 1;
  String pageSize = "10";

  // 发起事件项目
  Map selectMap = {};

  ProtocolViewModel(this.userModel);

  getAppointmentLists() {
    pageNum = 1;
    // var map = {
    //   "currentPage": pageNum.toString(),
    //   "pageSize": pageSize.toString(),
    //   "idCard": userModel.idCard,
    // };
    // print("............$map");
    HomeApi.getSingleton().multipartyNotaryList({}, errorCallBack: (e) {
      setBusy(false);
    }).then((data) {
      setBusy(false);
      if (data["code"] == 200) {
        appointmentLists?.clear();
        appointmentLists = data["data"];
      }
      notifyListeners();
    });
  }

  /// 合同发起公证
  sendContractOrder(String unitGuid,String orderNo)async{
    EasyLoading.show();
    Map<String, Object> map = {
      "channelName": unitGuid
    };
    notifyListeners();
    MineApi.getSingleton()
        .getToken(map, errorCallBack: (e) {
      selectMap = {};
      EasyLoading.dismiss();
      notifyListeners();
    })
        .then((res) {
      EasyLoading.dismiss();
      notifyListeners();
      if (res["code"] == 200) {
        MqttClientMsg.instance.subscribe(
            "/topic/hetong/${userModel.idCard}");
        Config.aPPId = res['appId'];
        Config.token = res['token'];
        print(
            "Config.aPPId-------${Config.aPPId},Config.token----${Config.token}");
        final roomId = "qtzh-$unitGuid";
        ContractEntity orderInfo = new ContractEntity();
        orderInfo.roomId = roomId;
        orderInfo.unitGuid = unitGuid;
        orderInfo.orderNo = orderNo;
        orderInfo.createDate = selectMap['createDate'];
        orderInfo.greffierName = selectMap['greffierName'];
        selectMap = {};
        G.getCurrentState().pushReplacementNamed(
            RoutePaths.ContractIng,
            arguments: orderInfo);
      }
    });
  }

  addOrder(String unitGuid, String roomId) {
    notifyListeners();
    EasyLoading.show();
    Map<String, String> map = {
      "unitGuid": unitGuid,
      "idCard": userModel.idCard
    };
    print(map);
    HomeApi.getSingleton().getProtocol(map, errorCallBack: (e) {
      EasyLoading.dismiss();
      selectMap = {};
      notifyListeners();
    }).then((res) {
      selectMap = {};
      notifyListeners();
      EasyLoading.dismiss();
      if (res['code'] == 200) {
        Map<String, Object> map1 = {"channelName": roomId};
        MineApi.getSingleton().getToken(map1, errorCallBack: (e) {}).then((e) {
          if (e["code"] == 200) {
            Config.aPPId = e['appId'];
            Config.token = e['token'];
            // SocketManage.instance.connect(userModel.idCard);
            MqttClientMsg.instance.subscribe("/topic/protocol/$roomId");
            G.getCurrentState().pushReplacementNamed(RoutePaths.ProtocolIng,
                arguments: {"roomId": roomId, "unitGuid": unitGuid});
          }
        });
      } else if (res['code'] == 11037) {
        ToastUtil.showWarningToast("请等待公证员进入，稍后再试！");
      } else {
        ToastUtil.showWarningToast(res['msg']);
      }
    });
  }

  Future loadData() async {
    setBusy(true);
  }

  refresh() async {
    pageNum = 1;
    refreshController.resetNoData();
    // var map = {
    //   "currentPage": pageNum.toString(),
    //   "pageSize": pageSize.toString(),
    //   "idCard": userModel.idCard,
    // };
    HomeApi.getSingleton().multipartyNotaryList({}, errorCallBack: (e) {
      refreshController.refreshFailed();
      setBusy(false);
    }).then((data) {
      if(data['code']==200){
        appointmentLists?.clear();
        appointmentLists = data["data"];
        refreshController.refreshCompleted();
        notifyListeners();
      }
    }).whenComplete(() {
      refreshController.refreshCompleted();
      setBusy(false);
    });
  }

  loadMore() async {
    pageNum += 1;
    // var map = {
    //   "currentPage": pageNum.toString(),
    //   "pageSize": pageSize.toString(),
    //   "idCard": userModel.idCard,
    // };
    HomeApi.getSingleton().multipartyNotaryList({}, errorCallBack: (e) {
      refreshController.loadFailed();
      pageNum -= 1;
    }).then((data) {
      if(data['code']==200){
        appointmentLists?.clear();
        appointmentLists = data["data"];
        notifyListeners();
        refreshController.loadComplete();
        // if (data["item"].isEmpty) {
        //   refreshController.loadNoData();
        // } else {
        //   refreshController.loadComplete();
        //   notifyListeners();
        // }
      }else{
        refreshController.loadNoData();
        notifyListeners();
      }

    });
  }

  @override
  onCompleted(data) {
    if (data.items == null || data.items.length == 0) {
      setEmpty();
    } else {
      data["item"].forEach((i) {
        appointmentLists.add(i);
      });
    }
  }
}
