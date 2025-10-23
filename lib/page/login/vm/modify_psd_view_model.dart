import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/block_puzzle_captcha.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';
import 'package:notarization_station_app/utils/global.dart';

class ModifyPsdViewModel extends SingleViewStateModel {
  TextEditingController phoneC = TextEditingController();
  TextEditingController codeC = TextEditingController();
  TextEditingController psdC = TextEditingController();
  TextEditingController psdAgainC = TextEditingController();
  TextEditingController phoneO = TextEditingController();
  TextEditingController emailCodeController = TextEditingController();
  TextEditingController abroadPswC = TextEditingController();
  TextEditingController abroadPswAgainC = TextEditingController();

  String phoneNum = '';
  bool phoneBool = false;
  String psdNum1 = '';
  String psdNum2 = '';
  String codeNum = '';

  Timer countdownTimer;
  String codeCountdownStr = '获取验证码';
  int _countdownNum = 119;

  Timer abroadCountdownTimer;
  String abroadCodeCountdownStr = '获取验证码';
  int _abroadCountdownNum = 119;

  final UserViewModel userViewModel;

  ModifyPsdViewModel(this.userViewModel);

  TelAndSmsService service = locator<TelAndSmsService>();

  /// 国内用户密码脱敏展示
  bool passwordShow = false;
  bool password2Show = false;
  /// 国外用户密码脱敏展示
  bool abroadPasswordShow = false;
  bool abroadPassword2Show = false;

  void phoneBoolShow(bool v) {
    phoneBool = v;
    notifyListeners();
  }

  // 选中展示的区号
  String dropDownValue = '86';

  String dropDownValueFirst = '86';

  List phoneArea = [];

  String selectData = "手机号";

  String phoneNumber = '';

  bool isLoading = false;

  bool isCodeTap = true;

  bool isAbroadCodeTap = true;

  void setSelectData(String value,
      {String phoneNumber = ''}) {
    selectData = value;
    if ("手机号" == value) {
      if (phoneNumber.isNotEmpty) {
        phoneC.text = phoneNumber;
      } else {
        phoneC.clear();
      }
    } else if ("邮箱" == value) {
      if (phoneNumber.isNotEmpty) {
        phoneC.text = phoneNumber;
      } else {
        phoneC.clear();
      }
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
    notifyListeners();
    countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdownNum > 0) {
        codeCountdownStr = '${_countdownNum--}s后重新获取';
        wjPrint('123');
      } else {
        codeCountdownStr = '获取验证码';
        isCodeTap = true;
        _countdownNum = 119;
        countdownTimer.cancel();
        countdownTimer = null;
      }
      notifyListeners();
    });
  }


  /// 倒计时
  abroadCountDown() {
    // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
    abroadCountdownTimer?.cancel();
    abroadCodeCountdownStr = '${_abroadCountdownNum--}s后重新获取';
    notifyListeners();
    abroadCountdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_abroadCountdownNum > 0) {
        abroadCodeCountdownStr = '${_abroadCountdownNum--}s后重新获取';
        wjPrint('123');
      } else {
        abroadCodeCountdownStr = '获取验证码';
        isAbroadCodeTap = true;
        _abroadCountdownNum = 119;
        abroadCountdownTimer.cancel();
        abroadCountdownTimer = null;
      }
      notifyListeners();
    });
  }

  // 获取图像验证码接口
  void getImgCode({BuildContext myContext,Function notSetEmail}) {
    if (phoneC.text.isEmpty) {
      ToastUtil.showWarningToast("请输入手机号");
    }else{
      setBusy(true);
      isAbroadCodeTap = false;
      notifyListeners();
      Map<String,dynamic> data = {
        'mobile': phoneC.text,
      };
      AccountApi.getSingleton().sendCaptchaCodeForget(data,errorCallBack: (e){
        ToastUtil.showWarningToast('获取图形验证码失败');
        isAbroadCodeTap = true;
        notifyListeners();
      }).then((value) {
        if(value !=null ){
          if(value["code"]==200){
            showDialog<Null>(
              context: myContext,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return BlockPuzzleCaptchaPage(
                  onSuccess: (v,token){
                    getSendEmailCode(notSetEmail: notSetEmail,pointJson: v,token: token);
                  },
                  onFail: (){
                    // isCodeTap = true;
                    // notifyListeners();
                  },
                );
              },
            );
            // showCaptchaCodeAlert(
            //     context:myContext,
            //     imageData: data,
            //     isForgetPassword: true,
            //     confirmEvent: (String code) {
            //       if (code != null && code.isNotEmpty) {
            //         getSendEmailCode(notSetEmail: notSetEmail,code: code);
            //       }else{
            //         ToastUtil.showWarningToast('请输入图形验证码');
            //         isAbroadCodeTap = true;
            //         notifyListeners();
            //       }
            //     },cancelEvent: (){
            //   isAbroadCodeTap = true;
            //   notifyListeners();
            // },successCallBack: (successValue){
            //   if(successValue['code']==7002){
            //     G.pop();
            //     isAbroadCodeTap = true;
            //     notifyListeners();
            //     notSetEmail();
            //   }else if(successValue['code']!=200 && successValue['code']!=7002){
            //     isAbroadCodeTap = true;
            //     notifyListeners();
            //   }
            // },
            //     failCallBack: (){
            //       isAbroadCodeTap = true;
            //       notifyListeners();
            //     },
            //     errorCallBack: (e){
            //       isAbroadCodeTap = true;
            //       notifyListeners();
            //     });
          }else if(value['code']==7002){
            isAbroadCodeTap = true;
            notifyListeners();
            notSetEmail();
          }else {
            ToastUtil.showWarningToast(data["message"]??data["data"]??"");
            isAbroadCodeTap = true;
            notifyListeners();
          }
        }else {
          isAbroadCodeTap = true;
          notifyListeners();
          ToastUtil.showErrorToast(value['message']);
        }
      });
    }
  }

  // sendType: 获取短信类型（1、注册 2、登录 3、忘记密码）
  getImageCode(BuildContext context) {
    if (phoneC.text.isEmpty) {
      ToastUtil.showWarningToast("请输入手机号");
      return;
    }
    if (phoneC.text.length != 11) {
      ToastUtil.showWarningToast("手机号格式错误");
      return;
    }
    isCodeTap = false;
            notifyListeners();
    showDialog<Null>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlockPuzzleCaptchaPage(
          onSuccess: (v,token){
            getCode(v,token);
          },
          onFail: (){
            isCodeTap = true;
            notifyListeners();
          },
        );
      },
    );
    // showCaptchaCodeAlert(
    //     context: context,
    //     imageData: data,
    //     isForgetPassword: false,
    //     confirmEvent: (String code) {
    //       if (code != null && code.isNotEmpty) {
    //         getCode(code);
    //       } else {
    //         isCodeTap = true;
    //         notifyListeners();
    //         ToastUtil.showWarningToast('请输入图形验证码');
    //       }
    //     },
    //     cancelEvent: () {
    //       isCodeTap = true;
    //       notifyListeners();
    //     },
    //     successCallBack: (value) {
    //       if (value["code"] != 200) {
    //         isCodeTap = true;
    //         notifyListeners();
    //       }
    //     },
    //     failCallBack: () {
    //       isCodeTap = true;
    //       notifyListeners();
    //     },
    //     errorCallBack: (e) {
    //       isCodeTap = true;
    //       notifyListeners();
    //     });
  }

  getCode(String pointJson,String token) {
    if (phoneC.text.isEmpty) {
      ToastUtil.showWarningToast("请输入手机号");
       isCodeTap = true;
          notifyListeners();
    } else if (phoneC.text.length != 11) {
      ToastUtil.showWarningToast("手机号格式错误");
       isCodeTap = true;
          notifyListeners();
    } else if (pointJson.isEmpty) {
      ToastUtil.showWarningToast("请先验证图形验证码");
       isCodeTap = true;
          notifyListeners();
    } else {
      setBusy(true);
      isCodeTap = false;
      notifyListeners();
      Map<String, String> map = {
        "areaCode": dropDownValue,
        "mobile": phoneC.text,
        "sendType": "3",
        'type': "2",
        "pointJson":pointJson,
        "token":token
      };
      AccountApi.getSingleton().getCode(map, errorCallBack: (e) {
        isCodeTap = true;
        notifyListeners();
      }).then((data) {
        if(data != null){
          if (data["code"] == 200) {
            ToastUtil.showSuccessToast("验证码获取成功！");
            countDown();
            G.pop();
          } else if (data['code'] == 12003) {
            isCodeTap = true;
            notifyListeners();
            eventBus.fire(EventBusInstanceEvent(source: 'checkFail'));
          } else {
            isCodeTap = true;
            notifyListeners();
            ToastUtil.showWarningToast(data['data'] ?? data['message']??'');
          }
        }else{
          isCodeTap = true;
          notifyListeners();
          ToastUtil.showWarningToast("获取验证码失败，稍后再试");
        }

      });
    }
  }

  getSendEmailCode({Function notSetEmail,String pointJson,String token}) {
    if (phoneC.text.isEmpty) {
      ToastUtil.showWarningToast("请输入账号");
    } else {
      Map<String, String> map = {
        "mobile": phoneC.text,
        "pointJson": pointJson,
        "token": token
        // "mobile": phoneC.text,
        // "sendType": "3",
      };
      AccountApi.getSingleton().sendEmailCodeByForget(map, errorCallBack: (e) {
        isAbroadCodeTap = true;
        notifyListeners();
      }).then((data) {
        if(data != null){
          if (data["code"] == 200) {
            String emailString = '';
            if (data['data'].isNotEmpty && data['data'].contains('@')) {
              emailString = data['data'].substring(0, data['data'].indexOf("@"));
              emailString = emailString.replaceRange(
                  2, emailString.length, "*" * (emailString.length - 2));
              abroadCountDown();
              G.pop();
              ToastUtil.showSuccessToast(
                  "验证码已发送到您注册时绑定的邮箱：$emailString${data['data'].substring(data['data'].indexOf("@"), data['data'].length)}，请注意查收");
            }else{
              isAbroadCodeTap = true;
              notifyListeners();
              ToastUtil.showWarningToast("邮箱格式错误或邮箱不存在，无法发送验证码");
              notSetEmail();
            }
          } else if (data != null && data["code"] == 7002) {
            isAbroadCodeTap = true;
            notifyListeners();
            notSetEmail();
          } else if (data != null && data['code'] == 12003) {
            eventBus.fire(EventBusInstanceEvent(source: 'checkFail'));
            isAbroadCodeTap = true;
            notifyListeners();
          } else {
            isAbroadCodeTap = true;
            notifyListeners();
            ToastUtil.showWarningToast(data['data'] ?? data['message']??'');
          }
        }else{
          isAbroadCodeTap = true;
          notifyListeners();
          ToastUtil.showWarningToast('获取邮箱验证码失败，稍后再试');
        }

      });
    }
  }

  //A00000€ A00000€£
  amendPsw() {
    if (selectData == "手机号") {
      if(phoneC.text.isEmpty){
        ToastUtil.showWarningToast("请输入手机号");
      }else if (phoneC.text.length != 11) {
        ToastUtil.showWarningToast("手机号格式错误");
      }else if (codeC.text.isEmpty ) {
        ToastUtil.showWarningToast("请输入验证码");
      } else if(codeC.text.length != 6){
        ToastUtil.showWarningToast("验证码格式错误");
      } else if (psdC.text.length < 8) {
        ToastUtil.showWarningToast("密码长度为8-16位");
      } else if (!G.checkPassWord(psdC.text)) {
         ToastUtil.showWarningToast("密码必须包含大写字母、小写字母、数字、特殊字符三种及三种以上");
       } else if (psdC.text != psdAgainC.text) {
        ToastUtil.showWarningToast("两次输入的密码不一致");
      }  else {
        isLoading = true;
        EasyLoading.show();
        notifyListeners();
        Map<String, String> map = {
          'areaCode':dropDownValue,
          "newPassword": G.generateMd5(psdC.text),
          "smsCode": codeC.text,
          "mobile": phoneC.text,
          "type": "2",
        };
        AccountApi.getSingleton().forgetPassword(map, errorCallBack: (e) {
          isLoading = false;
          EasyLoading.dismiss();
          notifyListeners();
        }).then((res) {
          isLoading = false;
          EasyLoading.dismiss();
          notifyListeners();
          if (res != null) {
            if (res["code"] != 200) {
              ToastUtil.showWarningToast(res["message"]??res['data']??res["msg"]??'');
              return;
            }
            userViewModel.modifyPassWord();
            ToastUtil.showOtherToast("密码修改成功");
            G.pushNamed(RoutePaths.LOGIN);
          } else {
            ToastUtil.showWarningToast("修改失败，稍后再试");
          }
        });
      }
    } else {
      if (phoneC.text.isEmpty) {
        ToastUtil.showWarningToast("请输入账号");
      } else if(emailCodeController.text.isEmpty) {
        ToastUtil.showWarningToast("请输入验证码");
      } else if(emailCodeController.text.length != 6) {
        ToastUtil.showWarningToast("验证码格式错误");
      } else if (abroadPswC.text.length < 8) {
        ToastUtil.showWarningToast("密码长度为8-16位");
      } else if (!G.checkPassWord(abroadPswC.text)) {
        ToastUtil.showWarningToast("密码必须包含大写字母、小写字母、数字、特殊字符三种及三种以上");
      } else if (abroadPswC.text != abroadPswAgainC.text) {
        ToastUtil.showWarningToast("两次输入的密码不一致");
      } else {
        Map<String, dynamic> map = {
          "emailCode": emailCodeController.text,
          "mobile": phoneC.text,
          "password": G.generateMd5(abroadPswC.text),
          'rePassword': G.generateMd5(abroadPswAgainC.text),
        };
        EasyLoading.show();
        AccountApi.getSingleton().doForgetPassword(map, errorCallBack: (e) {
          isLoading = false;
          EasyLoading.dismiss();
          notifyListeners();
        }).then((value) {
          EasyLoading.dismiss();
          if (value != null) {
            if (value["code"] != 200) {
              ToastUtil.showWarningToast(value["message"]??value['data']??"");
              return;
            }
            userViewModel.modifyPassWord();
            ToastUtil.showOtherToast("密码修改成功");
            G.pushNamed(RoutePaths.LOGIN);
          } else {
            ToastUtil.showWarningToast("修改失败，稍后再试！");
          }
        });
      }
    }
  }

  @override
  Future loadData() {
  }

  @override
  onCompleted(data) {}
}
