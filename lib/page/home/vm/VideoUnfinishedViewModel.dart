import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/base_framework/view_model/view_state.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/model/OrderReenterStatusInfoModel.dart';
import 'package:notarization_station_app/model/OrderReenterStatusModel.dart';
import 'package:notarization_station_app/page/home/entity/video_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoUnfinishedViewModel extends SingleViewStateModel with ClientCallback {

  UserViewModel userViewModel;
  RefreshController refreshController = RefreshController();
  int pageNumber = 1;
  final pageSize = 10;
  List<OrderReenterStatusModel> orderStatusList = [];
  VideoEntity orderInfo = JsonConvert.fromJsonAsT(<String,dynamic>{
    'code':'',
    'msg':'',
    "unitGuid":<String,dynamic>{}
  });

  VideoUnfinishedViewModel(this.userViewModel) {
    this.userViewModel = userViewModel;
  }

  @override
  Future loadData() {

  }

  /// 重新进入房间
  void reEnterVideoRoom(OrderReenterStatusModel model){
    EasyLoading.show(status: '正在加入...');
    HomeApi.getSingleton().videoReenter(model.unitGuid,errorCallBack: (error){
      ToastUtil.showErrorToast('网络出错了，请稍后再试！');
      EasyLoading.dismiss();
    }).then((value){
      EasyLoading.dismiss();
      if(value!= null) {
        if(value['code'] == 200) {
          if(value['data'] != null) {
            MqttClientMsg.instance
                .subscribe("/topic/shiping/${userViewModel.idCard}");
            OrderReenterStatusInfoModel modelInfo = OrderReenterStatusInfoModel.fromJson(value['data']);
            orderInfo.unitGuid.createDate = modelInfo.applyDate;
            orderInfo.unitGuid.unitGuid = modelInfo.unitGuid;
            orderInfo.unitGuid.orderNo = modelInfo.orderNo;
            orderInfo.unitGuid.currentState = modelInfo.linkStatus;
            G
                .getCurrentState()
                .pushReplacementNamed(RoutePaths.VideoIng, arguments: {
              "roomId": "qtzh-${model.unitGuid}",
              "orderInfo": orderInfo,
              "greffierName": modelInfo.greffierName
            });
          }
        } else {
          ToastUtil.showErrorToast(value['msg']??value['message']??'网络出错了，请稍后再试！');
        }
      } else {
        ToastUtil.showErrorToast('网络出错了，请稍后再试！');
      }
    });
  }

  void getData(){
    EasyLoading.show();
    HomeApi.getSingleton().reenterVideoOrdersList({},errorCallBack: (error){
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      EasyLoading.dismiss();
    }).then((value){
      EasyLoading.dismiss();
      if (value != null && value['code'] ==200) {
        if (value['data'] == null || value['data'].isEmpty) {
          if(pageSize == 1) {
            state = ViewState.empty;
          } else {
            state = ViewState.idle;
          }
        } else {
          state = ViewState.idle;
          if (value['data'].isNotEmpty) {
            value['data'].forEach((e){
              OrderReenterStatusModel model = new OrderReenterStatusModel.fromJson(e);
              orderStatusList.add(model);
            });
          }
        }
      } else {
        state = ViewState.idle;
        ToastUtil.showErrorToast(value['msg']??value['message']??value['data']??'网络出错了，请稍后再试');
      }
      notifyListeners();
    });
  }

  @override
  onCompleted(data) {

  }

  @override
  void clientDataHandler(onData, topic) {

  }

}