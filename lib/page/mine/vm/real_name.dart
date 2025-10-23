import 'dart:io';

import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/mine_api.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';

import '../../../appTheme.dart';

class RealNamePageModel extends SingleViewStateModel {
  UserViewModel userViewModel;

  TelAndSmsService _service = locator<TelAndSmsService>();

  // 境内
  TextEditingController textControllerName;
  TextEditingController textControllerIdentity;
//  境外
  TextEditingController abroadNameController;
  TextEditingController abroadCountryController;
  TextEditingController sexController;
  TextEditingController cerTypeController;
  TextEditingController cerNumberController;
  TextEditingController cerTimeController;
  TextEditingController cerBirthTimeController;

  PageController pageController = PageController();

  // final picker = ImagePicker();
  //身份证正面 二进制数据
  List pickedFileZheng = [];
  //身份证反面 二进制数据
  List pickedFileFan = [];

  // 国外证正面照
  List pickedAbroadFileZheng = [];

  //身份证正面 图片地址
  String filePath = '';
  String abroadFilePath = '';

  //身份证反面 图片地址
  String filePathF = '';
  bool yesAbroadZheng = false;
  bool yesZheng = false;
  bool yesFan = false;
  Map cardData = {};
  String beginTime = ''; // 境外有效期开始时间
  String endTime = ''; // 境外有效期结束时间
  // 国内国外
  bool isAbord = false;

  // 性别
  int sexValue = 1;

  // 境外身份类型
  int abroadType = 0;

  // 国外当前选择的文件类型
  String cerType = '';

  // 获取国家列表
  List<String> countryList = [];

  List allCountryDataList = [];

  // 选中的国籍
  String countryName = '';

  bool isEnable = true;

  // 标记从登录模块进入还是我的模块进入
  String comeFrom;

  RealNamePageModel(this.userViewModel, String come) {
    textControllerName = TextEditingController();
    textControllerIdentity = TextEditingController();
    abroadNameController = TextEditingController();
    abroadCountryController = TextEditingController();
    sexController = TextEditingController();
    cerTypeController = TextEditingController();
    cerNumberController = TextEditingController();
    cerBirthTimeController = TextEditingController();
    cerTimeController = TextEditingController();
    comeFrom = come;
  }

  void changeAbordStatus(bool value) {
    isAbord = value;
    pageController.animateToPage(value ? 1 : 0,
        duration: const Duration(microseconds: 200), curve: Curves.ease);
    notifyListeners();
  }

  // 选择证件类型
  void chooseCerType(value) {
    if (value.toString().contains('护照')) {
      abroadType = 414;
    } else if (value.toString().contains('港澳')) {
      abroadType = 516;
    } else if (value.toString().contains('永久居留身份证')) {
      abroadType = 553;
    } else if (value.toString().contains('台湾')) {
      abroadType = 511;
    } else {
      // 这个类型是前端自己定义的值，绑定的类型是value为其他
      abroadType = 522;
    }
    cerTypeController.text = value;
    notifyListeners();
  }

  void chooseNationType(value) {
    allCountryDataList.forEach((element) {
      if (element['dictName'] == value) {
        countryName = element['dictValue'];
      }
    });
    abroadCountryController.text = value;
    notifyListeners();
  }

  //  有效期和出生日期选择
  void changeTime(controller, date) {
    if (controller == cerTimeController) {
      cerTimeController.text = date;
    } else if (controller == cerBirthTimeController) {
      cerBirthTimeController.text = date;
    }
    notifyListeners();
  }

  @override
  Future loadData() {
    getSelectAllTop();
    notifyListeners();
    return null;
  }

  void uploadPicturesZheng(String path) async {
    Image image = Image.file(File.fromUri(Uri.parse(path)));
    // 预先获取图片信息
    image.image
        .resolve(ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) async {
      int width = info.image.width;
      int height = info.image.height;
      final result = await FlutterImageCompress.compressWithFile(
        path,
        minWidth: 2300, //压缩后的最小宽度
        minHeight: 1500, //压缩后的最小高度
        quality: 20, //压缩质量
        rotate: width < height ? 90 : 0, //旋转角度
      );
      pickedFileZheng = result;
      EasyLoading.show();
      AccountApi.getSingleton().upperFile(path, errorCallBack: (e) {
        EasyLoading.dismiss();
      }).then((res) {
        wjPrint(res);
        if (res["code"] == 200) {
          if (res['item']['filePath'] == null ||
              res['item']['filePath'].toString().isEmpty) {
            EasyLoading.dismiss();
            ToastUtil.showErrorToast('证件上传失败，请稍后再试！');
            return;
          }
          if (!isAbord) {
            filePath = res["item"]["filePath"];
            setCardZheng();
          }
          // else {
          // abroadFilePath = res["item"]["filePath"];
          // getOcrDiscern();
          // }
          notifyListeners();
        } else {
          ToastUtil.showErrorToast("${res['msg']}");
        }
      });
    }));
  }

  // // 境外证件识别
  // void getOcrDiscern(){
  //   Map<String,dynamic> param = {
  //     'filePath':abroadFilePath,
  //     'ocrType':abroadType
  //   };
  //   HomeApi.getSingleton().ocrDiscern(param).then((value){
  //     if(value!=null){
  //       EasyLoading.dismiss();
  //       if(value['code']!=200){
  //         ToastUtil.showErrorToast(value['message']??value['msg']??value['data']);
  //         return;
  //       }
  //       yesAbroadZheng = true;
  //       abroadNameController.text =  value['data']['name']; // RegExp(r"^[\u4E00-\u9FA5A-Za-z0-9_]+$").hasMatch(value['data']['name']);
  //       abroadCountryController.text = value['data']['nationality'];
  //       if(value['data']['gender'] !=null){
  //         if(value['data']['gender'].toString().contains('男')){
  //           sexController.text = '男';
  //         }else if(value['data']['gender'].toString().contains('女')){
  //           sexController.text = '女';
  //         }
  //       }else{
  //         sexController.text = '';
  //       }
  //
  //       if(!RegExp(RegexUtil.regexZh).hasMatch(value['data']['cardNum'])){
  //         cerNumberController.text = value['data']['cardNum'];
  //       }
  //       cerTimeController.text = value['data']['validDate'];
  //       cerBirthTimeController.text = value['data']['birthday'];
  //     }else{
  //       ToastUtil.showErrorToast('网络出错了，请稍后再试...');
  //     }
  //   });
  // }

  // 国内身份证件识别
  void setCardZheng() async {
    var map = {
      // "userId":userViewModel.unitGuid,
      "filepath": filePath,
      "type": "1"
    };
    AccountApi.getSingleton().upperCard(map, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((data) {
      EasyLoading.dismiss();
      wjPrint("返回数据:$data");
      if (data["item"]["map"] == null ||
          data["item"]["map"].isEmpty ||
          data["item"]["map"]["office"] == "" ||
          data["item"]["map"]["invalid"] == "" ||
          data["item"]["map"]["issue"] == "") {
        if (!isAbord) {
          ToastUtil.showErrorToast("请上传身份证头像面！");
          yesZheng = false;
        } else {
          ToastUtil.showErrorToast("请上传证件头像面！");
          yesAbroadZheng = false;
        }
      } else {
        if (!isAbord) {
          ToastUtil.showSuccessToast("身份证头像面上传成功！");
          cardData = data["item"]["map"];
          textControllerName.text = cardData['name'];
          textControllerIdentity.text = cardData['idCard'];
          yesZheng = true;
        } else {
          ToastUtil.showSuccessToast("证件头像面上传成功！");
          // cardData = data["item"]["map"];
          // textControllerName.text = cardData['name'];
          // textControllerIdentity.text = cardData['idCard'];
          yesAbroadZheng = true;
        }
      }
      notifyListeners();
    });
  }

  void getSelectAllTop() async {
    HomeApi.getSingleton().getSelectAllTop({'keyword': '国籍'},
        errorCallBack: (e) {
    }).then((value) {
      if (value["code"] == 200) {
        if (value['data'] != null) {
          getCountryDataList(value['data'][0]['unitGuid']);
        }
      }
    });
  }

  // 获取国家信息数据
  getCountryDataList(String parentId) async {
    HomeApi.getSingleton().getByParentId({'parentId': parentId},
        errorCallBack: (e) {
        }).then((value) {
      wjPrint("getCountryDataList-----$value");
      if (value['code'] == 200 && value['data'] != null) {
        allCountryDataList = value['data'];
        allCountryDataList.forEach((element) {
          countryList.add(element['dictName']);
        });
      }
      notifyListeners();
    });
  }

  void submit(context) async {
    if (!isAbord) {
      // if (yesZheng == false) {
      //   wjPrint("没有正面");
      //   ToastUtil.showErrorToast("请重新上传身份证头像面！");
      // } else if (yesZheng == true) {
      //   if (textControllerName.text.isEmpty) {
      //     ToastUtil.showErrorToast('请输入姓名');
      //     return;
      //   }
      //   if (textControllerIdentity.text.isEmpty ||
      //       !RegExp(RegexUtil.regexIdCard18)
      //           .hasMatch(textControllerIdentity.text)) {
      //     ToastUtil.showErrorToast('请输入正确的身份证号吗！');
      //     return;
      //   }
      //   isEnable = false;
      //   notifyListeners();
      //   Navigator.pushNamed(context, RoutePaths.faceCompare, arguments: {
      //     'isAbroad': isAbord,
      //     'filePath': filePath,
      //     'cardData': cardData
      //   }).then((value) {
      //     isEnable = true;
      //     notifyListeners();
      //   });
      // } else {
      //   ToastUtil.showErrorToast("请上传身份证头像面！");
      // }
      if (textControllerName.text.isEmpty) {
        ToastUtil.showErrorToast('请输入姓名');
        return;
      }
      if (textControllerIdentity.text.isEmpty ||
          !RegExp(RegexUtil.regexIdCard18)
              .hasMatch(textControllerIdentity.text)) {
        ToastUtil.showErrorToast('请输入正确的身份证号码！');
        return;
      }
      isEnable = false;
      notifyListeners();
      Navigator.pushNamed(context, RoutePaths.faceCompare, arguments: {
        'isAbroad': isAbord,
        'comeFrom': comeFrom,
        'filePath': filePath,
        'cardData': yesZheng
            ? cardData
            : {
                'name': textControllerName.text,
                'sex': G.getGender(textControllerIdentity.text),
                'birth': G.getBirthday(textControllerIdentity.text),
                'idCard': textControllerIdentity.text,
                'certificateType': abroadType,
                'idCardImg': filePath,
                'registeAddress': ''
              }
      }).then((value) {
        isEnable = true;
        notifyListeners();
      });
    } else {
      if (abroadNameController.text.isEmpty) {
        ToastUtil.showWarningToast('请输入姓名');
        return;
      }
      if (abroadCountryController.text.isEmpty) {
        ToastUtil.showWarningToast('请选择国家/地区');
        return;
      }
      if (cerTypeController.text.isEmpty) {
        ToastUtil.showWarningToast('请选择证件类型');
        return;
      }
      if (cerNumberController.text.isEmpty) {
        ToastUtil.showWarningToast('请输入证件号码');
        return;
      }
      if (abroadType != 522) {
        if (cerTimeController.text.isEmpty) {
          ToastUtil.showWarningToast('请选择有效日期');
          return;
        }
        if (cerBirthTimeController.text.isEmpty) {
          ToastUtil.showWarningToast('请选择出生日期');
          return;
        }
      }

      Navigator.pushNamed(context, RoutePaths.faceCompare, arguments: {
        'isAbroad': isAbord,
        'comeFrom': comeFrom,
        "cardData": {
          'name': abroadNameController.text,
          'sex': sexValue == 1 ? '男' : '女',
          'birth': cerBirthTimeController.text,
          'idCard': cerNumberController.text,
          'certificateType': abroadType,
          'idCardImg': abroadFilePath,
          'address': '',
          'registeAddress': '',
          'nation': countryName,
          'endTime': cerTimeController.text,
        },
        'filePath': "",
        // "cardFan": filePathF,
      }).then((value) {
        isEnable = true;
        notifyListeners();
      });
    }
  }

  upDataUserInformation() {
    var map = {
      //"unitGuid":userViewModel.unitGuid,
      "idCardImg": abroadFilePath,
      "userName": abroadNameController.text,
      "idCard": cerNumberController.text,
      "registeAddress": '',
      "gender": sexValue,
      "nation": countryName,
      "birthday": '',
      "address": ''
    };
    wjPrint(map);
    AccountApi.getSingleton()
        .identityUser(map, errorCallBack: (e) {})
        .then((data) {
      if (data["code"] == 200) {
        // ToastUtil.showSuccessToast("身份认证成功！");
        // userViewModel.setUserName(abroadNameController.text);
        // userViewModel.setUserGender(sexValue);
        // userViewModel.setUserAddress('');
        // userViewModel.setUserBirthday("");
        // // userViewModel.setUserIdImg(imgList.join(","));
        // userViewModel.setUseridCard(cerNumberController.text);
      } else {
        ToastUtil.showErrorToast(data["data"]);
      }
    });
  }

  // 用户账号禁用
  disabledUserAccount(BuildContext context) {
    if (abroadNameController.text.isEmpty) {
      ToastUtil.showWarningToast('请输入姓名');
      return;
    }
    if (abroadCountryController.text.isEmpty) {
      ToastUtil.showWarningToast('请选择国家/地区');
      return;
    }
    if (cerTypeController.text.isEmpty) {
      ToastUtil.showWarningToast('请选择证件类型');
      return;
    }
    if (cerNumberController.text.isEmpty) {
      ToastUtil.showWarningToast('请输入证件号码');
      return;
    }
    MineApi.getSingleton().disableByLoginName(
        {'loginName': userViewModel.mobile}, errorCallBack: (e) {
      wjPrint('账号禁用成功----$e');
    }).then((value) {
      if (value['code'] == 200) {
        wjPrint('账号禁用成功');
        upDataUserInformation();
        userViewModel.userLogout(isShow: false);
        callPhoneEvent(context);
      } else {
        wjPrint("账号禁用失败！");
      }
    });
  }

  @override
  onCompleted(data) {}

  /// 拨打电话弹框
  void callPhoneEvent(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 30),
              decoration: BoxDecoration(
                  color: AppTheme.white,
                  borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('''
      因您提供的证件信息无法自动识别验证，需要通过人工审核才能完成实名认证。

      可联系公证员协助处理，或使用大陆手机号联系4008001820进行咨询。'''),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            G.pop();
                            exit(0);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppTheme.themeBlue, width: 1),
                            ),
                            child: Text(
                              '  退出  ',
                              style: TextStyle(color: AppTheme.themeBlue),
                            ),
                          )),
                      TextButton(
                          onPressed: () {
                            G.pop();
                            FocusScope.of(context).requestFocus(FocusNode());
                            Future.delayed(Duration(milliseconds: 500), () {
                              _service.call("4008001820");
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            decoration: BoxDecoration(
                              color: AppTheme.themeBlue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '立即拨打',
                              style: TextStyle(color: AppTheme.white),
                            ),
                          )),
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }
}
