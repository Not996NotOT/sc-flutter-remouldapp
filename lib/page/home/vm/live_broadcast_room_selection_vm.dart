import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/room_api.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';

class LiveBroadcastRoomSelectionViewModel extends SingleViewStateModel
    with ClientCallback {
  UserViewModel userViewModel;

  LiveBroadcastRoomSelectionViewModel({this.userViewModel});

  TextEditingController nameController = new TextEditingController();

  TextEditingController cardController = new TextEditingController();

  TextEditingController tokenController = new TextEditingController();

  ThrottleUtil throttleUtil = ThrottleUtil();

  @override
  Future loadData() {
    throw UnimplementedError();
  }

  // 直播验证
  enterDirectSeeding() {
    if (nameController.text.isEmpty) {
      EasyLoading.showError('请输入您的姓名！', duration: const Duration(seconds: 1));
      return;
    }
    if (cardController.text.isEmpty) {
      EasyLoading.showError('请输入您的身份证号码！',
          duration: const Duration(seconds: 1));
      return;
    }
    if (tokenController.text.isEmpty) {
      EasyLoading.showError('请输入您的令牌！', duration: const Duration(seconds: 1));
      return;
    }
    Map<String, dynamic> map = {
      'buyerIdCard': cardController.text,
      'buyerName': nameController.text,
      'houseToken': tokenController.text,
    };
    RoomApi.checkUserWhenEnterLiveRoom(map).then((value) {
      log("返回的数据：$value");
      // G.pushNamed(RoutePaths.liveRoomAndIntroduce);
    });
  }

  @override
  onCompleted(data) {
    throw UnimplementedError();
  }

  @override
  void clientDataHandler(onData, topic) {}
}
