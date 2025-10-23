import 'package:flutter/cupertino.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/utils/global.dart';

import '../../../utils/common_tools.dart';

class AttestationViewModel extends SingleViewStateModel {
  final arguments;

  final UserViewModel userViewModel;
  TextEditingController textControllerName;
  TextEditingController textControllerIdentity;
  TextEditingController textControllerAddress;
  String textName = '';
  String textIdentity = '';
  String textAddress = '';
  List imgList = [];

  AttestationViewModel(this.userViewModel, this.arguments) {
    textControllerName = TextEditingController();
    textControllerIdentity = TextEditingController();
    textControllerAddress = TextEditingController();
  }

  bool isEnable = true;

  @override
  Future loadData() {
    if (!arguments['isAbroad']) {
      this.textControllerName.text =
          (arguments != null ? arguments["cardData"]["name"] : "");
      this.textControllerIdentity.text =
          arguments != null ? arguments["cardData"]["idCard"] : "";
      this.textControllerAddress.text =
          arguments != null ? arguments["cardData"]["address"] : "";
      if (arguments == null) {
        this.imgList = [];
      } else {
        // this.imgList.add(Config.splicingImageUrl(arguments["cardFan"]));
        this.imgList.add(Config.splicingImageUrl(arguments["cardZheng"]));
      }
    } else {
      this.textControllerName.text =
          (arguments != null ? arguments["cardData"]["name"] : "");
      this.textControllerIdentity.text =
          arguments != null ? arguments["cardData"]["idCard"] : "";
      this.textControllerAddress.text =
          arguments != null ? arguments["cardData"]["address"] : "";
      if (arguments == null) {
        this.imgList = [];
      } else {
        // this.imgList.add(Config.splicingImageUrl(arguments["cardFan"]));
        this.imgList.add(Config.splicingImageUrl(arguments["cardZheng"]));
      }
    }

//    notifyListeners();
    return null;
  }

  void confirm() async {
//     if(userViewModel.user.items.user.iDCardImg == null){
    if (this.textControllerName.text == "") {
      ToastUtil.showErrorToast("真实姓名不能为空！");
    } else if (this.textControllerIdentity.text == "") {
      ToastUtil.showErrorToast("身份证号不能为空！");
    } else if (this.textControllerAddress.text == "") {
      ToastUtil.showErrorToast("住址不能为空！");
    } else if (arguments == null) {
      ToastUtil.showErrorToast("身份证照片不能为空！");
    } else {
      isEnable = false;
      notifyListeners();
      var map = {
        //"unitGuid":userViewModel.unitGuid,
        "idCardImg": this.imgList.join(","),
        "userName": textControllerName.text,
        "idCard": textControllerIdentity.text,
        "registeAddress": textControllerAddress.text,
        "gender": arguments["cardData"]["sex"] == "男" ? 1 : 0,
        "nation": arguments["cardData"]["nation"],
        "birthday": arguments["cardData"]["birth"].toString(),
        "address": textControllerAddress.text
      };
      wjPrint(map);
      AccountApi.getSingleton().identityUser(map, errorCallBack: (e) {
        isEnable = true;
        notifyListeners();
      }).then((data) {
        isEnable = true;
        notifyListeners();
        wjPrint("返回数据：$data");
        if (data["code"] == 200) {
          ToastUtil.showSuccessToast("身份认证成功！");
          userViewModel.setUserName(textControllerName.text);
          userViewModel
              .setUserGender(arguments["cardData"]["sex"] == "男" ? 1 : 0);
          userViewModel.setUserAddress(textControllerAddress.text);
          userViewModel.setUserBirthday("${arguments["cardData"]["birth"]}");
          // userViewModel.setUserIdImg(imgList.join(","));
          userViewModel.setUseridCard(textControllerIdentity.text);
          G.pushNamed(
            RoutePaths.HomeIndex,
          );
        } else {
          ToastUtil.showErrorToast(data["data"]);
        }
      });
    }
  }

  @override
  onCompleted(data) {}
}
