import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/page/mine/vm/real_name.dart';
import 'package:notarization_station_app/page/mine/widget/custom_camera_page.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/alert_view.dart';
import 'package:notarization_station_app/utils/bottom_alert_search_list.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../appTheme.dart';

class RealNamePage extends StatefulWidget {
  String comeFrom;

  RealNamePage({this.comeFrom});

  @override
  State<StatefulWidget> createState() {
    return RealNamePageState();
  }
}

class RealNamePageState extends BaseState<RealNamePage> {
  RealNamePageModel viewModel;
  UserViewModel userViewModel;
  String comeFrom = '';

  @override
  void initState() {
    super.initState();
    comeFrom = widget.comeFrom;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        wjPrint("是否走了该方法");
        if(comeFrom.isEmpty){
          G.pop();
        }else if (comeFrom == "isLogin"){
          G.getCurrentState().pushNamedAndRemoveUntil(
              RoutePaths.LOGIN, (router) => router == null,
              arguments: {'isMine': true});
        }else{
          userViewModel.currentIndex = 4;
          Navigator.pushNamedAndRemoveUntil(
              context, RoutePaths.HomeIndex, (route) => false);
        }

        return Future.value(false);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text("实名认证"),leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: (){
            wjPrint("是否走了该方法");
            if(comeFrom.isEmpty){
              G.pop();
            }else if (comeFrom == "isLogin"){
              userViewModel.userLogout();
              G.getCurrentState().pushNamedAndRemoveUntil(
                  RoutePaths.LOGIN, (router) => router == null,
                  arguments: {'isMine': false});
            }else{
              userViewModel.currentIndex = 4;
              Navigator.pushNamedAndRemoveUntil(
                  context, RoutePaths.HomeIndex, (route) => false);
            }

          },
        ),centerTitle: true,),
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<RealNamePageModel>(
              model: RealNamePageModel(userModel, widget.comeFrom),
              onModelReady: (model) {
                userViewModel = userModel;
                model.initData();
              },
              builder: (ctx, vm, child) {
                viewModel = vm;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 36,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: () {
                                    viewModel.changeAbordStatus(false);
                                  },
                                  child: Container(
                                    height: 36,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(vm.isAbord
                                                ? 'lib/assets/images/iden_top_grey.png'
                                                : "lib/assets/images/iden_top_light.png"))),
                                    child: Text(
                                      "大陆居民身份证",
                                      style: TextStyle(
                                          fontSize: getSp(26),
                                          color: Colors.white,
                                          fontWeight: vm.isAbord
                                              ? FontWeight.normal
                                              : FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                    onTap: () {
                                      viewModel.changeAbordStatus(true);
                                    },
                                    child: Container(
                                      height: 36,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(vm.isAbord
                                                  ? "lib/assets/images/iden_top_light.png"
                                                  : "lib/assets/images/iden_top_grey.png"))),
                                      child: Text(
                                        "其他证件类型",
                                        style: TextStyle(
                                            fontSize: getSp(26),
                                            color: Colors.white,
                                            fontWeight: vm.isAbord
                                                ? FontWeight.bold
                                                : FontWeight.normal),
                                      ),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: viewModel.pageController,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            cnIdentifyWidget(),
                            abordIdentifyWidget(),
                          ],
                        ),
                      ),
                      // SizedBox(height: 30,),
                      // Container(
                      //   width: getWidthPx(650),
                      //   child: FlatButton(
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius:
                      //         BorderRadius.all(Radius.circular(10))),
                      //     onPressed: () {
                      //       viewModel.submit();
                      //     },
                      //     color: AppTheme.themeBlue,
                      //     textColor: Colors.white,
                      //     child: Text(
                      //       '提交',
                      //       style: TextStyle(
                      //         fontSize: 15,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // 国内身份校验
  Widget cnIdentifyWidget() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          InkWell(
            onTap: () {
              // if (!viewModel.yesZheng) {
              _showDialog(true);
              // }
            },
            child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: getWidthPx(246),
                    height: getWidthPx(164),
                    margin: EdgeInsets.only(
                        top: getWidthPx(44),
                        left: getWidthPx(72),
                        bottom: getWidthPx(44)),
                    alignment: Alignment.center,
                    child: viewModel.filePath.isEmpty
                        ? Image.asset("lib/assets/images/card_zheng.png")
                        : Image.network(viewModel.filePath),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: getWidthPx(56)),
                    width: getWidthPx(312),
                    height: getWidthPx(80),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.themeBlue, width: 1.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '拍照自动识别证件信息',
                      style: TextStyle(
                          fontSize: getSp(26), color: AppTheme.themeBlue),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Column(
              children: [
                _itemOne('姓名', '请输入姓名', viewModel.textControllerName),
                _itemOne(
                    '身份证号', '请输入18位身份证号码', viewModel.textControllerIdentity),
                const SizedBox(
                  height: 48,
                ),
                _nextButton
                // GestureDetector(
                //   onTap: () {
                //     viewModel.submit();
                //   },
                //   child: Container(
                //     height: getWidthPx(90),
                //     margin: EdgeInsets.only(left: 25, right: 25, top: 48),
                //     alignment: Alignment.center,
                //     decoration: BoxDecoration(
                //       color: AppTheme.themeBlue,
                //       borderRadius: BorderRadius.circular(5.0),
                //     ),
                //     child: Text(
                //       '下一步',
                //       style:
                //           TextStyle(fontSize: getSp(30), color: Colors.white),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 国外身份校验
  Widget abordIdentifyWidget() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 20),
            color: Colors.white,
            child: Column(
              children: [
                _itemOne('姓名', '请输入姓名', viewModel.abroadNameController),
                _itemTwo('国家/地区', '请输入国家/地区', viewModel.abroadCountryController,
                    (controller) {
                  getNationType();
                }),
                _sexWidget(),
                _itemTwo('证件类型', '请选择', viewModel.cerTypeController,
                    (controller) {
                  getCerType();
                }),
                _itemOne('证件号码', '请输入证件号码', viewModel.cerNumberController),
                Offstage(
                  offstage: viewModel.abroadType == 522,
                  child:
                      _itemTwo('有效日期', '请输入有效日期', viewModel.cerTimeController,
                          (controller) {
                    chooseTime(viewModel.cerTimeController);
                  }),
                ),
                Offstage(
                  offstage: viewModel.abroadType == 522,
                  child: _itemTwo(
                      '出生日期', '请输入出生日期', viewModel.cerBirthTimeController,
                      (controller) {
                    chooseTime(viewModel.cerBirthTimeController);
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 30, bottom: 30, right: 30),
                  child: Text(
                    '''提示：\n请仔细核对输入信息，确保内容准确无误。\n如果您的证件类型不支持认证，请选择“其他”，或联系公证员协助处理。''',
                    style: TextStyle(
                        fontSize: getSp(26), color: Color(0xFFFE9800)),
                  ),
                ),
                _nextButton
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget get _nextButton => DebounceButton(
        clickTap: viewModel.isEnable
            ? () {
                if (viewModel.abroadType != 522) {
                  viewModel.submit(context);
                } else {
                  viewModel.disabledUserAccount(context);
                }
              }
            : null,
        isEnable: viewModel.isEnable,
        borderRadius: BorderRadius.circular(5.0),
        margin: EdgeInsets.only(left: 25, right: 25),
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Text(
          '下一步',
          style: TextStyle(fontSize: getSp(30), color: Colors.white),
        ),
      );

  Widget _sexWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
            text: TextSpan(
                text: '*',
                style: TextStyle(fontSize: getSp(26), color: Colors.red),
                children: [
              TextSpan(
                  text: '性别',
                  style: TextStyle(fontSize: getSp(26), color: Colors.black))
            ])),
        SizedBox(
          width: 10,
        ),
        SizedBox(
          width: getWidthPx(470),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                          value: 1,
                          groupValue: viewModel.sexValue,
                          onChanged: (value) {
                            setState(() {
                              viewModel.sexValue = value;
                            });
                          }),
                      Text('男'),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Radio(
                          value: 2,
                          groupValue: viewModel.sexValue,
                          onChanged: (value) {
                            setState(() {
                              viewModel.sexValue = value;
                            });
                          }),
                      Text('女'),
                    ],
                  ),
                  const Spacer(),
                ],
              ),
              Divider(),
            ],
          ),
        ),
        SizedBox(
          width: 30,
        )
      ],
    );
  }

  // item one
  Widget _itemOne(
      String title, String placeHolder, TextEditingController controller) {
    List<TextInputFormatter> inputFormatters = [];
    if (controller == viewModel.textControllerName ||
        controller == viewModel.abroadNameController) {
      inputFormatters.add(LengthLimitingTextInputFormatter(30));
      // inputFormatters.add(FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]|[\\u4e00-\\u9fa5]')));
    } else if (controller == viewModel.textControllerIdentity) {
      inputFormatters.add(LengthLimitingTextInputFormatter(18));
      inputFormatters
          .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]|[0-9]")));
    } else if (controller == viewModel.cerNumberController) {
      inputFormatters.add(LengthLimitingTextInputFormatter(50));
      inputFormatters
          .add(FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]|[0-9]")));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        RichText(
            text: TextSpan(
                text: '*',
                style: TextStyle(fontSize: getSp(26), color: Colors.red),
                children: [
              TextSpan(
                  text: title,
                  style: TextStyle(fontSize: getSp(26), color: Colors.black))
            ])),
        Padding(
          padding: const EdgeInsets.only(right: 30, left: 10),
          child: SizedBox(
            width: getWidthPx(470),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  style: TextStyle(fontSize: getSp(26)),
                  inputFormatters: inputFormatters,
                  decoration: InputDecoration(
                    hintText: placeHolder,
                    hintStyle: TextStyle(
                        color: Color(0xFF999999), fontSize: getSp(26)),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) {
                    if (!controller.value.isComposingRangeValid) {
                      return;
                    }
                  },
                ),
                Divider(
                  height: 1.0,
                  color: Color(0xFFD7D7D7),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  // item two
  Widget _itemTwo(String title, String placeHolder,
      TextEditingController controller, Function callBack) {
    return GestureDetector(
      onTap: () {
        callBack(controller);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
              text: TextSpan(
                  text: '*',
                  style: TextStyle(fontSize: getSp(26), color: Colors.red),
                  children: [
                TextSpan(
                    text: title,
                    style: TextStyle(fontSize: getSp(26), color: Colors.black))
              ])),
          Padding(
            padding: const EdgeInsets.only(right: 30, left: 10),
            child: SizedBox(
              width: getWidthPx(470),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: controller,
                          enabled: callBack == null,
                          style: TextStyle(fontSize: getSp(26)),
                          decoration: InputDecoration(
                            hintText: placeHolder,
                            hintStyle: TextStyle(
                                color: Color(0xFF999999), fontSize: getSp(26)),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down_sharp,
                        size: 30,
                      )
                    ],
                  ),
                  Divider(
                    height: 1.0,
                    color: Color(0xFFD7D7D7),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future getImage(bool isFront) async {
    // if(!await Permission.camera.status.isGranted || !await Permission.storage.status.isGranted){
    //   G.showCustomToast(
    //       context: G.getCurrentContext(),
    //       titleText: "相机、存储权限使用说明：",
    //       subTitleText: "用于拍摄、录制视频、文件存储等场景",
    //       time: 2
    //   );
    // }
    // if (await Permission.camera.request().isGranted &&
    //     await Permission.storage.request().isGranted) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //         builder: (context) => CustomCameraPage(
    //               isFront: isFront,
    //             )),
    //   ).then((v) {
    //     if (v != null) {
    //       print('$v');
    //       viewModel.uploadPicturesZheng(v);
    //     }
    //   });
    // } else {
    //   G.showPermissionDialog(str: "内部存储、相机权限");
    // }

    if(Platform.isIOS){
      if (await Permission.camera.request().isGranted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomCameraPage(
                isFront: isFront,
              )),
        ).then((v) {
          if (v != null) {
            print('$v');
            viewModel.uploadPicturesZheng(v);
          }
        });
      } else {
        G.showPermissionDialog(str: "访问相机权限");
      }
    }
    if(Platform.isAndroid){
      if(!await Permission.camera.status.isGranted || !await Permission.storage.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "相机、存储权限使用说明：",
            subTitleText: "用于拍摄、录制视频、文件存储等场景",
            time: 2
        );
      }
      if (await Permission.camera.request().isGranted &&
          await Permission.storage.request().isGranted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CustomCameraPage(
                isFront: isFront,
              )),
        ).then((v) {
          if (v != null) {
            print('$v');
            viewModel.uploadPicturesZheng(v);
          }
        });
      } else {
        G.showPermissionDialog(str: "访问内部存储、相机权限");
      }
    }
  }

  _showDialog(bool iszheng) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () {
                  getGallery(iszheng);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "从相册选择图片",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  getImage(iszheng);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "拍照",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(getWidthPx(20)),
                  child: Text(
                    "取消",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: getSp(36)),
                  ),
                ),
              ),
            ],
          );
        });
  }

  Future getGallery(bool isZheng) async {
    if(Platform.isAndroid){
      if(!await Permission.storage.status.isGranted){
        G.showCustomToast(
            context: G.getCurrentContext(),
            titleText: "照片及文件权限使用说明：",
            subTitleText: "用于上传照片和文件、以及设置头像等场景",
            time: 2
        );
      }
      final status = await Permission.storage.request();
      if (status == PermissionStatus.granted) {
        final pickedGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          viewModel.uploadPicturesZheng(pickedGallery.path);
        });
      }else{
        G.showPermissionDialog(str: "访问内部照片及文件权限");
      }
    }
    if(Platform.isIOS){
      if(await Permission.photos.request().isGranted){
        final pickedGallery =
        await ImagePicker.pickImage(source: ImageSource.gallery);
        setState(() {
          viewModel.uploadPicturesZheng(pickedGallery.path);
        });
      }else{
        G.showPermissionDialog(str: "访问相册权限");
      }
    }
  }

//  获取文件类型
  void getCerType() {
    AlertView.showPickerViewAlert(context, [
      '定居国外中国公民护照',
      '台湾居民来往内地通行证',
      '港澳居民来往内地通行证',
      '外国人永久居留身份证',
      '其他'
    ], (value) {
      viewModel.chooseCerType(value);
    });
  }

  //  获取国籍
  void getNationType() {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (context) {
          return BottomAlertSearchList(
            selectValueCallBack: (value) {
              viewModel.chooseNationType(value);
            },
            dataSource: viewModel.countryList,
          );
        });
    // AlertView.showPickerViewAlert(context, viewModel.countryList, (value) {
    //   viewModel.chooseNationType(value);
    // });
  }

  // 选择日期
  void chooseTime(controller) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(2300, 1, 1), onChanged: (date) {
      wjPrint('change $date');
    }, onConfirm: (date) {
      viewModel.changeTime(controller, date.toString().substring(0, 10));
    }, currentTime: DateTime.now(), locale: LocaleType.zh);
  }

  void chooseBetweenTime(controller) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1900, 1, 1),
        maxTime: DateTime(2300, 1, 1), onChanged: (date) {
      wjPrint('change $date');
    }, onConfirm: (date) {
      viewModel.changeTime(controller, date.toString().substring(0, 10));
    }, currentTime: DateTime.now(), locale: LocaleType.zh);
  }
}
