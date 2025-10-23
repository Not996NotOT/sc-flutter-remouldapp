

import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/block_puzzle_captcha.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';
import 'package:notarization_station_app/utils/global.dart';

class BindEmailAddressViewModel extends SingleViewStateModel{

  TextEditingController emailController = TextEditingController();

  TextEditingController emailCodeController  = TextEditingController();

  Timer countdownTimer;
  String codeCountdownStr = '获取验证码';
  int _countdownNum = 119;
  String phoneNumber;

  bool isEnable = true;

  /// 倒计时
  countDown() {
    // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
    countdownTimer?.cancel();
    codeCountdownStr = '${_countdownNum--}s后重新获取';
    notifyListeners();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownNum > 0) {
        codeCountdownStr = '${_countdownNum--}s后重新获取';
      } else {
        codeCountdownStr = '获取验证码';
        _countdownNum = 119;
        countdownTimer.cancel();
        countdownTimer = null;
      }
      notifyListeners();
    });
  }

  // sendType: 获取短信类型（1、注册 2、登录 3、忘记密码）
  // 获取图像验证码接口
  void getImgCode({BuildContext myContext}) {
      showDialog<Null>(
        context: myContext,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlockPuzzleCaptchaPage(
            onSuccess: (v,token){
              getEmailCode(v,token);
            },
            onFail: (){

            },
          );
        },
      );
      // showCaptchaCodeAlert(
      //     context:myContext,
      //     imageData: data,
      //     isForgetPassword: false,
      //     confirmEvent: (String code) {
      //       if (code != null && code.isNotEmpty) {
      //         getEmailCode(code);
      //       }else{
      //         ToastUtil.showWarningToast('请输入图形验证码');
      //
      //       }
      //     },cancelEvent: (){
      //
      // },successCallBack: (successValue){
      //   if(successValue['code']==7002){
      //     G.pop();
      //
      //   }else if(successValue['code']!=200 && successValue['code']!=7002){
      //
      //   }
      // },
      //     failCallBack: (){
      //
      //     },
      //     errorCallBack: (e){
      //
      //     });

  }

  /// 获取验证码
  getEmailCode(String pointJson,String token){
  if(emailController.text == null || emailController.text.isEmpty){
      ToastUtil.showWarningToast("邮箱为空");
    }else if(!RegexUtil.isEmail(emailController.text)){
      ToastUtil.showWarningToast("邮箱错误");
    }else{
      Map<String, dynamic> map = {
        'email': emailController.text,
        "pointJson":pointJson,
        "token":token
      };
      HomeApi.getSingleton().getSendEmailCode(map, errorCallBack: (e) {
        codeCountdownStr = '获取验证码';
        notifyListeners();
      }).then((data) {
        if (data != null && data["code"] == 200) {
          ToastUtil.showSuccessToast("验证码获取成功！");
          countDown();
          G.pop();
        } else if (data != null && data['code']== 12003) {
          eventBus.fire(EventBusInstanceEvent(source: 'checkFail'));
          codeCountdownStr = '获取验证码';
          notifyListeners();
        } else  {
          codeCountdownStr = '获取验证码';
          notifyListeners();
          ToastUtil.showWarningToast(data['data'] ?? data['message']);
        }
      });
    }
  }

  /// 邮件绑定
  bindEmail(){
    if(emailController.text.isEmpty){
      ToastUtil.showWarningToast("请输入邮箱");
    }else if(!RegexUtil.isEmail(emailController.text)){
      ToastUtil.showWarningToast("请输入正确的邮箱格式");
    } else if(emailCodeController.text.isEmpty){
      ToastUtil.showWarningToast("请输入验证码");
    }else if(emailCodeController.text.length != 6){
      ToastUtil.showWarningToast("验证码格式错误");
    }else{
      isEnable = false;
      notifyListeners();
      Map<String,dynamic>map = {
        'email':emailController.text,
        'emailCode':emailCodeController.text,
        'mobile':phoneNumber
      };
      AccountApi.getSingleton().doSetEmail(map,errorCallBack: (e){
        isEnable = true;
        notifyListeners();
      }).then((value){
        isEnable = true;
        notifyListeners();
        if(value!=null){
          if(value['code']!=200){
            ToastUtil.showErrorToast(value['message']);
            return;
          }
          ToastUtil.showSuccessToast("绑定邮箱成功");
          G.pop();
        }else{
          ToastUtil.showErrorToast("绑定邮箱失败");
        }
      });
    }
  }

  @override
  Future loadData() {
    // TODO: implement loadData
    throw UnimplementedError();
  }

  @override
  onCompleted(data) {
    // TODO: implement onCompleted
    throw UnimplementedError();
  }

}