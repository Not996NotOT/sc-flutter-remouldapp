import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/block_puzzle_captcha.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/alert_view.dart';

class CodeViewModel extends SingleViewStateModel {
  UserViewModel userViewModel;
  TextEditingController phoneController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  CodeViewModel(this.userViewModel);

  bool loading = false;
  int countDownTime = 0;
  Timer countdownTimer;
  String codeCountdownStr = '获取验证码';
  bool codeCountDownIsEnable = true;
  int _countdownNum = 119;

  // 选中展示的区号
  String dropDownValue = '86';

  String selectData = "1";

  bool isAgree = false;

  // 是否同意协议
  void changeAgree(bool value) async{
    isAgree = value;
    if(value){
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOne", !value);
    }
    notifyListeners();
  }

  void changeDropDownValue(String value) {
    dropDownValue = value;
    G.phoneArea.forEach((element) {
      if (element['dictCode'] == value) {
        selectData = element['dictValue'];
      }
    });
    notifyListeners();
  }

  /// 倒计时
  countDown() {
    // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
    countdownTimer?.cancel();
    codeCountdownStr = '${_countdownNum--}s后重新获取';
    codeCountDownIsEnable = false;
    notifyListeners();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownNum > 0) {
        codeCountdownStr = '${_countdownNum--}s后重新获取';
      } else {
        codeCountDownIsEnable = true;
        codeCountdownStr = '获取验证码';
        _countdownNum = 119;
        countdownTimer.cancel();
        countdownTimer = null;
      }
      notifyListeners();
    });
  }

  //sendType:获取短信类型（1、注册 2、登录 3、忘记密码）
  // type: 用户类型(1 机构用户,2 普通用户),示例值(2)
  getImageCode(BuildContext myContext) {
    if (selectData == "1") {
      if (phoneController.text.isEmpty) {
        ToastUtil.showWarningToast("请输入手机号");
        return;
      }
      if (phoneController.text.length != 11) {
        ToastUtil.showWarningToast('手机号格式错误');
        return;
      }

      Map<String, dynamic> data = {
        'type': '2',
        'identy': phoneController.text,
      };
      codeCountDownIsEnable = false;
      notifyListeners();
      showDialog<Null>(
        context: myContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlockPuzzleCaptchaPage(
            onSuccess: (v,token){
              getCode(v,token);
            },
            onFail: (){
              codeCountDownIsEnable = true;
              notifyListeners();
            },
          );
        },
      );
      // showCaptchaCodeAlert(
      //     context: myContext,
      //     imageData: data,
      //     isForgetPassword: false,
      //     confirmEvent: (String code) {
      //       if (code != null && code.isNotEmpty) {
      //         getCode(code);
      //       } else {
      //         codeCountDownIsEnable = true;
      //         notifyListeners();
      //         ToastUtil.showWarningToast('请输入图形验证码');
      //       }
      //     },
      //     cancelEvent: () {
      //       codeCountDownIsEnable = true;
      //       notifyListeners();
      //     },
      //     successCallBack: (value) {
      //       if (value["code"] != 200) {
      //         codeCountDownIsEnable = true;
      //         notifyListeners();
      //       }
      //     },
      //     failCallBack: () {
      //       codeCountDownIsEnable = true;
      //       notifyListeners();
      //     },
      //     errorCallBack: (e) {
      //       codeCountDownIsEnable = true;
      //       notifyListeners();
      //     });
    }
  }

  getCode(String pointJson,String token) {
    if (selectData == '1') {
      if (phoneController.text.isEmpty) {
        ToastUtil.showWarningToast("请输入手机号");
        codeCountDownIsEnable = true;
        notifyListeners();
        return;
      }
      if (phoneController.text.length != 11) {
        ToastUtil.showWarningToast('手机号格式错误');
        codeCountDownIsEnable = true;
        notifyListeners();
        return;
      }
      if (pointJson.isEmpty) {
        ToastUtil.showWarningToast("请先验证图形验证码");
        codeCountDownIsEnable = true;
        notifyListeners();
        return;
      }

      codeCountDownIsEnable = false;
      notifyListeners();
      Map<String, String> map = {
        "areaCode": dropDownValue,
        "mobile": phoneController.text,
        "sendType": "2",
        'type': "2",
        "pointJson": pointJson,
        "token":token
      };
      AccountApi.getSingleton().getCode(map, errorCallBack: (e) {
        codeCountDownIsEnable = true;
        notifyListeners();
        ToastUtil.showWarningToast("获取失败，稍后再试！");
      }).then((data) {
        if (data != null) {
          if (data["code"] == 200) {
            ToastUtil.showSuccessToast("验证码获取成功！");
            countDown();
            G.pop();
          } else if (data['code']== 12003) {
            eventBus.fire(EventBusInstanceEvent(source: 'checkFail'));
            codeCountDownIsEnable = true;
            notifyListeners();
          } else {
            codeCountDownIsEnable = true;
            notifyListeners();
            ToastUtil.showWarningToast("${data["data"]??data["message"]}");
          }
        } else {
          codeCountDownIsEnable = true;
          notifyListeners();
          ToastUtil.showWarningToast("获取失败，稍后再试！");
        }
      });
      return;
    }
    Map<String, dynamic> map = {
      'areaCode': dropDownValue,
      "mobile": phoneController.text,
      'type': 3, // 1: register 2: resetPsd 3: login
    };
    HomeApi.getSingleton().getAbordMsgSend(map).then((data) {
      if (data != null) {
        if (data["code"] != 200) {
          ToastUtil.showWarningToast("${data["data"]??data["message"]}");
          return;
        }
        countDown();
        ToastUtil.showSuccessToast("验证码获取成功！");
      } else {
        ToastUtil.showWarningToast("获取失败，稍后再试！");
      }
    });
  }

  login(BuildContext context) {
    if (phoneController.text.isEmpty || codeController.text.isEmpty) {
      ToastUtil.showWarningToast("用户名或验证码不能为空！");
    } else if(isAgree == false){
      ToastUtil.showWarningToast("请先同意隐私协议");
    }else{
      loading = true;
      notifyListeners();
      Map<String, Object> map = {
        "smsCode": codeController.text,
        "source": "1",
        'areaCode': dropDownValue,
        'mobile': phoneController.text,
        "type": "2"
      };
      AccountApi.getSingleton().getCodeLogin(map, errorCallBack: (e) {
        loading = false;
        notifyListeners();
      }).then((data) {
        loading = false;
        notifyListeners();
        if (data["code"] != 200) {
          ToastUtil.showWarningToast(data["data"] ?? data["message"]);
          return;
        }
        SpUtil.remove("lastUserId");
        AccountApi.getSingleton().getUserInfo(
            {'roleId': data["data"]['role'][0]['roleId']},
            data["data"]['token']).then((res) {
          if (res["code"] == 200) {
            res['data']['token'] = data["data"]['token'];
            UserInfoEntity user = UserInfoEntity.fromJson(res['data']);
            userViewModel.saveUser(user);
            SpUtil.putString(Config.lastUserPhoneNumber, phoneController.text);
            G.getCurrentState().pushNamedAndRemoveUntil(
                RoutePaths.HomeIndex, (Route route) => false);
          } else {
            ToastUtil.showWarningToast("登录失败，请稍后再试");
          }
        });
        notifyListeners();
      });
    }

  }

  @override
  Future loadData() {}

  @override
  onCompleted(data) {}
}
