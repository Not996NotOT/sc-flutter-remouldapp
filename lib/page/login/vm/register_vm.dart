import 'dart:async';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/block_puzzle_captcha.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/event_bus_instance.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterViewModel extends SingleViewStateModel {
  TextEditingController phoneC = TextEditingController();
  TextEditingController codeC = TextEditingController();
  TextEditingController psdC = TextEditingController();
  TextEditingController psdAgainC = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController emailCodeController = TextEditingController();
  TextEditingController abroadPswC = TextEditingController();
  TextEditingController abroadPswAgainC = TextEditingController();

  bool phoneBool = false;

  int countDownTime = 0;
  Timer countdownTimer;
  String codeCountdownStr = '获取验证码';
  bool codeCountDownIsEnable = true;
  int _countdownNum = 119;

  Timer abroadCountdownTimer;
  String abroadCodeCountdownStr = '获取验证码';
  bool abroadCodeCountDownIsEnable = true;
  int _abroadCountdownNum = 119;

  // 苹果账号
  String appleId;
  //本机号码一键登录手机号
  String mobile;
  //微信授权unionId
  String unionId;

  String selectData = "手机号注册";

  TelAndSmsService service = locator<TelAndSmsService>();

  bool loading = false;

  void setSelectData(String value) {
    // codeCountdownStr = '获取验证码';
    // _countdownNum = 119;
    // isCodeTap = false;
    // countdownTimer?.cancel();
    selectData = value;
    // phoneC.clear();
    // codeC.clear();
    // psdC.clear();
    // psdAgainC.clear();
    // emailController.clear();
    // emailCondeController.clear();
    notifyListeners();
  }

  final UserViewModel userViewModel;

  RegisterViewModel(this.userViewModel);

  /// 国内密码脱密展示
  bool passwordShow = false;
  bool password2Show = false;

  /// 国外密码脱密展示
  bool abroadPasswordShow = false;
  bool abroadPassword2Show = false;
  bool isConsent = false;



  // 是否同意协议
  void changeAgree(bool value) async{
    isConsent = value;
    if(value){
      var prefs = await SharedPreferences.getInstance();
      prefs.setBool("isOne", !value);
    }
    notifyListeners();
  }

  void phoneBoolShow(bool v) {
    phoneBool = v;
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

  /// 倒计时
  abroadCountDown() {
    // Timer的第一秒倒计时是有一点延迟的，为了立刻显示效果可以添加下一行。
    abroadCountdownTimer?.cancel();
    abroadCodeCountdownStr = '${_abroadCountdownNum--}s后重新获取';
    notifyListeners();
    abroadCountdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_abroadCountdownNum > 0) {
        abroadCodeCountdownStr = '${_abroadCountdownNum--}s后重新获取';
      } else {
        abroadCodeCountdownStr = '获取验证码';
        abroadCodeCountDownIsEnable = true;
        _abroadCountdownNum = 119;
        abroadCountdownTimer.cancel();
        abroadCountdownTimer = null;
      }
      notifyListeners();
    });
  }

// identy	邮箱地址 or 手机号码	query	true	string
// type	验证码类型（1.注册 2.登录 3.忘记密码）	query	true
  // 获取图像验证码接口
  void getImgCode({BuildContext myContext}) {
    if (selectData == "手机号注册") {
      if (phoneC.text.isEmpty) {
        ToastUtil.showWarningToast("请输入手机号");
        return;
      }
      if (phoneC.text.length != 11) {
        ToastUtil.showWarningToast('手机号格式错误');
        return;
      }
    }
    if (selectData == "邮箱注册") {
      if (phoneC.text.isEmpty) {
        ToastUtil.showWarningToast("请输入手机号");
        return;
      }
      if (emailController.text.isEmpty) {
        ToastUtil.showWarningToast("请输入邮箱");
        return;
      }
      if (!RegexUtil.isEmail(emailController.text)) {
        ToastUtil.showWarningToast("请输入正确的邮箱格式");
        return;
      }
    }
    if (selectData == "邮箱注册") {
      abroadCodeCountDownIsEnable = false;
      notifyListeners();
    } else {
      codeCountDownIsEnable = false;
      notifyListeners();
    }

    Map<String, dynamic> data = {
      'type': '1',
      'identy': selectData == "邮箱注册" ? emailController.text : phoneC.text,
    };
    showDialog<Null>(
      context: myContext,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return BlockPuzzleCaptchaPage(
          onSuccess: (v,token){
            if (selectData == "邮箱注册") {
              getAbroadEmailCode(v,token);
            } else {
              getChinaCountrySmsCode(v,token);
            }
          },
          onFail: (){
            if (selectData == "邮箱注册") {
              abroadCodeCountDownIsEnable = true;
              notifyListeners();
            } else {
              codeCountDownIsEnable = true;
              notifyListeners();
            }
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
    //         if (selectData == "邮箱注册") {
    //           getAbroadEmailCode(code);
    //         } else {
    //           getChinaCountrySmsCode(code);
    //         }
    //       } else {
    //         if (selectData == "邮箱注册") {
    //           abroadCodeCountDownIsEnable = true;
    //           notifyListeners();
    //         } else {
    //           codeCountDownIsEnable = true;
    //           notifyListeners();
    //         }
    //         ToastUtil.showWarningToast('请输入图形验证码');
    //       }
    //     },
    //     cancelEvent: () {
    //       if (selectData == "邮箱注册") {
    //         abroadCodeCountDownIsEnable = true;
    //         notifyListeners();
    //       } else {
    //         codeCountDownIsEnable = true;
    //         notifyListeners();
    //       }
    //     },
    //     successCallBack: (value) {
    //       if (value["code"] != 200) {
    //         if (selectData == "邮箱注册") {
    //           abroadCodeCountDownIsEnable = true;
    //           notifyListeners();
    //         } else {
    //           codeCountDownIsEnable = true;
    //           notifyListeners();
    //         }
    //       }
    //     },
    //     failCallBack: () {
    //       if (selectData == "邮箱注册") {
    //         abroadCodeCountDownIsEnable = true;
    //         notifyListeners();
    //       } else {
    //         codeCountDownIsEnable = true;
    //         notifyListeners();
    //       }
    //     },
    //     errorCallBack: (e) {
    //       if (selectData == "邮箱注册") {
    //         abroadCodeCountDownIsEnable = true;
    //         notifyListeners();
    //       } else {
    //         codeCountDownIsEnable = true;
    //         notifyListeners();
    //       }
    //     });
  }

  // 国内用户获取短信验证码
  getChinaCountrySmsCode(String pointJson,String token) {
    if (phoneC.text.isEmpty) {
      ToastUtil.showWarningToast("请输入手机号");
      codeCountDownIsEnable = true;
      notifyListeners();
    } else if (phoneC.text.length != 11) {
      ToastUtil.showWarningToast('手机号格式错误');
      codeCountDownIsEnable = true;
      notifyListeners();
    } else if (pointJson.isEmpty) {
      ToastUtil.showWarningToast('请先验证图形验证码');
      codeCountDownIsEnable = true;
      notifyListeners();
    } else {
      codeCountDownIsEnable = false;
      setBusy(true);
      notifyListeners();
      // if (selectData == "1") {
      Map<String, String> map = {
        "areaCode": '86',
        "mobile": phoneC.text,
        "sendType": "1",
        'type': "2",
        "pointJson": pointJson,
        "token":token
      };
      AccountApi.getSingleton().getCode(map, errorCallBack: (e) {
        codeCountdownStr = '获取验证码';
        codeCountDownIsEnable = true;
        notifyListeners();
      }).then((data) {
        if (data != null && data["code"] == 200) {
          ToastUtil.showSuccessToast("验证码获取成功！");
          countDown();
          G.pop();
        } else if (data != null && data['code']== 12003) {
          eventBus.fire(EventBusInstanceEvent(source: 'checkFail'));
          codeCountdownStr = '获取验证码';
          codeCountDownIsEnable = true;
          notifyListeners();
        } else {
          ToastUtil.showWarningToast(data['data']??data["message"]);
          codeCountdownStr = '获取验证码';
          codeCountDownIsEnable = true;
          notifyListeners();
        }
      });
    }
  }

  // 获取国外用户的邮箱验证码
  getAbroadEmailCode(String pointJson,String token) {
    if (phoneC.text.isEmpty) {
      ToastUtil.showWarningToast("请输入手机号");
      abroadCodeCountDownIsEnable = true;
      notifyListeners();
    } else if (emailController.text.isEmpty) {
      ToastUtil.showWarningToast("请输入邮箱");
      abroadCodeCountDownIsEnable = true;
      notifyListeners();
    } else if (!RegexUtil.isEmail(emailController.text)) {
      ToastUtil.showWarningToast("请输入正确的邮箱格式");
      abroadCodeCountDownIsEnable = true;
      notifyListeners();
    } else if (pointJson.isEmpty) {
      ToastUtil.showWarningToast("请先验证图形验证码");
      abroadCodeCountDownIsEnable = true;
      notifyListeners();
    } else {
      Map<String, dynamic> map = {
        'email': emailController.text,
        "pointJson":pointJson,
        "token":token
        // "mobile": phoneC.text,
        // 'type': 1, // 1: register 2: resetPsd 3: login
      };
      HomeApi.getSingleton().getSendEmailCode(map, errorCallBack: (e) {
        abroadCodeCountdownStr = '获取验证码';
        abroadCodeCountDownIsEnable = true;
        notifyListeners();
      }).then((data) {
        if (data != null && data["code"] == 200) {
          ToastUtil.showSuccessToast("验证码获取成功！");
          abroadCountDown();
          G.pop();
        } else if (data != null && data['code']== 12003) {
          eventBus.fire(EventBusInstanceEvent(source: 'checkFail'));
          abroadCodeCountdownStr = '获取验证码';
          abroadCodeCountDownIsEnable = true;
          notifyListeners();
        } else {
          abroadCodeCountdownStr = '获取验证码';
          abroadCodeCountDownIsEnable = true;
          notifyListeners();
          ToastUtil.showWarningToast(data['data'] ?? data['message']);
        }
      });
    }
  }

  amendPsw(BuildContext context) {
    if (selectData == '手机号注册') {
      if (phoneC.text.isEmpty) {
        ToastUtil.showWarningToast("请输入手机号");
      } else if (phoneC.text.length != 11) {
        ToastUtil.showWarningToast("手机号格式错误");
      } else if (codeC.text.isEmpty) {
        ToastUtil.showWarningToast("请输入验证码");
      } else if (codeC.text.length != 6) {
        ToastUtil.showWarningToast("验证码格式错误");
      } else if (psdC.text.length < 8 || psdC.text.length > 16) {
        ToastUtil.showWarningToast("密码长度为8-16位");
      } else if (!G.checkPassWord(psdC.text)) {
        ToastUtil.showWarningToast("密码必须包含大写字母、小写字母、数字、特殊字符三种及三种以上");
      } else if (psdC.text != psdAgainC.text) {
        ToastUtil.showWarningToast("两次输入的密码不一致");
      } else {
        if (!isConsent) {
          ToastUtil.showWarningToast("请阅读并同意《青桐智盒隐私政策》和《服务协议》");
        } else {
          loading = true;
          notifyListeners();
          Map<String, String> map1 = {
            "password": G.generateMd5(psdC.text),
            "confirmPassword":G.generateMd5(psdC.text),
            "mobile":"${phoneC.text}",
            'appleId':appleId,
            "unionId":unionId,
            "smsCode": codeC.text,
            "areaCode":'86'
          };
          EasyLoading.show();
          AccountApi.getSingleton().oneClickRegister(map1, errorCallBack: (e) {
            EasyLoading.dismiss();
            loading = false;
            notifyListeners();
          }).then((res) {
            EasyLoading.dismiss();
            loading = false;
            notifyListeners();
            if (res != null) {
              wjPrint("参数1：$res");
              if (res["code"] != 200) {
                ToastUtil.showWarningToast(res["data"]??res['message']);
                return;
              }
              // G.pushNamed(RoutePaths.LoginTypeFile);
              Navigator.popAndPushNamed(context, RoutePaths.LOGIN);
            } else {
              ToastUtil.showWarningToast("注册失败，稍后再试！");
            }
          });
        }
      }
    } else {
      wjPrint("phoneC.text.length ------${phoneC.text.length}");
      if (phoneC.text.isEmpty) {
        ToastUtil.showWarningToast("请输入手机号");
      } else if (emailController.text.isEmpty) {
        ToastUtil.showWarningToast("请输入邮箱");
      } else if (!RegexUtil.isEmail(emailController.text)) {
        ToastUtil.showWarningToast("邮箱格式错误");
      } else if (emailCodeController.text.isEmpty) {
        ToastUtil.showWarningToast("请输入验证码");
      } else if (emailCodeController.text.length != 6) {
        ToastUtil.showWarningToast("验证码格式错误");
      } else if (abroadPswC.text.length < 8 || abroadPswC.text.length > 16) {
        ToastUtil.showWarningToast("密码长度为8-16位");
      } else if (abroadPswC.text != abroadPswAgainC.text) {
        ToastUtil.showWarningToast("两次输入的密码不一致");
      } else if (!G.checkPassWord(abroadPswC.text)) {
        ToastUtil.showWarningToast("密码必须包含大写字母、小写字母、数字、特殊字符三种及三种以上");
      } else {
        if (!isConsent) {
          ToastUtil.showWarningToast("请阅读并同意《青桐智盒隐私政策》和《服务协议》");
        } else {
          loading = true;
          notifyListeners();
          Map<String, dynamic> params = {
            'mobile': phoneC.text,
            'password': G.generateMd5(abroadPswC.text),
            'confirmPassword':G.generateMd5(abroadPswC.text),
            'appleId':appleId,
            'unionId':unionId,
            'email': emailController.text,
            'emailCode': emailCodeController.text
          };

          EasyLoading.show();
          AccountApi.getSingleton().oneClickRegister(params, errorCallBack: (e) {
            loading = false;
            notifyListeners();
            EasyLoading.dismiss();
          }).then((value) {
            loading = false;
            notifyListeners();
            EasyLoading.dismiss();
            if(value != null){
              if(value['code'] == 200){
                Navigator.popAndPushNamed(context, RoutePaths.LOGIN);
              }else{
                ToastUtil.showWarningToast(value['message']??value['data']??'');
              }
            }else{
              ToastUtil.showErrorToast('注册失败，请稍后再试');
            }
          });
        }
      }
    }
  }

  login() {
    EasyLoading.show();
    Map<String, String> map = {
      "identityToken":appleId,
      "mobile": phoneC.text,
      "unionId": unionId,
    };
    AccountApi.getSingleton().oneClickLogin(map, errorCallBack: (e) {
      EasyLoading.dismiss();
      ToastUtil.showErrorToast('注册失败，请稍后再试');
    }).then((data) {
      if(data != null){
        if (data["code"] == 200 && data["data"]['loginInfo']['roleList'].length != 0) {
          SpUtil.remove("lastUserId");
          AccountApi.getSingleton().getUserInfo({
            'roleId': data["data"]['loginInfo']['roleList'][0]['roleId'],
            'device': 'app'
          }, data["data"]['loginInfo']['token'], errorCallBack: (e) {
            EasyLoading.dismiss();
            ToastUtil.showErrorToast('注册失败，请稍后再试');
          }).then((res) {
            if(res !=null){
              if (res["code"] == 200) {
                EasyLoading.dismiss();
                res['data']['token'] = data["data"]['loginInfo']['token'];
                UserInfoEntity user = UserInfoEntity.fromJson(res['data']);
                userViewModel.saveUser(user);
                ToastUtil.showSuccessToast("注册成功");
                G.pushNamed(RoutePaths.RealName,
                    arguments: {'comeFrom': 'isLogin'});
              } else {
                EasyLoading.dismiss();
                ToastUtil.showWarningToast(res['message']??res['data']??"");
              }
            }else{
              EasyLoading.dismiss();
              ToastUtil.showWarningToast('注册失败，请稍后再试');
            }
          });
        } else {
          EasyLoading.dismiss();
          ToastUtil.showWarningToast(data['message']??data['data']??'');
        }
      }else{
        EasyLoading.dismiss();
        ToastUtil.showWarningToast('注册失败，请稍后再试');
      }

    });
  }

  setPasswordShow() {
    selectData == '手机号注册'
        ? passwordShow = !passwordShow
        : abroadPasswordShow = !abroadPasswordShow;
    notifyListeners();
  }

  setPasswordAgainShow() {
    selectData == '手机号注册'
        ? password2Show = !password2Show
        : abroadPassword2Show = !abroadPassword2Show;
    notifyListeners();
  }

  @override
  Future loadData() {}

  @override
  onCompleted(data) {}
}
