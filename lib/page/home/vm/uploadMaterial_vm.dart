import 'dart:collection';
import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/base_framework/widget/entity/release_model.dart';
import 'package:notarization_station_app/base_framework/widget/photo_view/photo_view_gallery.dart';
import 'package:notarization_station_app/base_framework/widget/release_widget.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/home/vm/bottomsheet/uploadMaterial_bottomsheet_vm.dart';
// import 'package:notarization_station_app/page/home/vm/bottomsheet/video_bottomsheet_vm.dart';
import 'package:notarization_station_app/page/home/vm/dialog/uploadMaterial_dialog_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

class UploadMaterialModel extends SingleViewStateModel {
  final UserViewModel userViewModel;
  final arguments;
  List httpImageUrlList;
  int number;
  List orderLogs;

  String selectType = "自取";
  ReleaseCon otherList = new ReleaseCon();
  List<String> resList = [];
  List<String> idList = [];
  List<String> otherMaterialList = [];
  List huKouImgLists = [];
  List identityImgLists = [];
  List otherImgLists = [];
  String toDay;
  List notaryItems = [];
  String orderId;
  TextEditingController materialName;
  String annexFileList; //上传材料成功返回的id
  List materialIdList = [];
  List materialList = [];
  List<Asset> uploadMaterialLists = [];
  Map materialData;
  List imgIdList = []; //上传材料保存传的参数里面的图片id
  List upLoadData = []; //上传材料保存传的参数
  WebViewPlusController _controller;
  List previewImgList = []; //预览的图片数组
  double videoHeight;
  int showOneImg = 1;
  bool alreadyRead = false;
  bool clickNext = false; //点击下一步
  var jiaMiBao;
  List upMaterialList = []; //上传材料需要的数组
  Map<String, List<String>> imageMap = new HashMap();

  bool isEdite = true;
  bool isName = true;

  UploadMaterialModel(this.userViewModel, this.arguments, this.httpImageUrlList,
      this.number, this.orderLogs) {
    materialName = TextEditingController();
  }

  showSignature(String name, String idCard, String tyKeyword, String offSet,
      BuildContext context) {
    // EasyLoading.show();
    String url =
        '${Config.caUrl}?name=$name&idCard=$idCard&tyKeyword=$tyKeyword&offSet=$offSet&terminalType=flutter';
    if (Platform.isIOS) {
      url = Uri.encodeFull(
          '${Config.caUrl}?name=$name&idCard=$idCard&tyKeyword=$tyKeyword&offSet=$offSet&terminalType=flutter');
    }
    _showCustomModalBottomSheet(context, name);
    // dialog(name);
  }

  dialog(String name) {
    // 对话框
    showDialog(
        context: G.getCurrentState().overlay.context,
        builder: (ctx) {
          print('=========================arguments: ' + arguments.toString());
          print('=========================orderId: ' +
              arguments['orderId'].toString());
          print('=========================notarizationMatters: ' +
              arguments['notarizationMatters'].toString());
          print('=========================unitGuid: ' +
              arguments['notarizationMatters'][0]['unitGuid']);
          print('=========================notaryForm: ' +
              arguments['notaryForm'].toString());
          return DemoPage(
              orderId: arguments['orderId'],
              idCard: userViewModel.idCard,
              name: name,
              unitGuid: arguments['notarizationMatters'][0]['unitGuid'],
              notarizationMatters: arguments['notarizationMatters'],
              notaryForm: number.toString());

          // return WebViewPlus(
          //   javascriptMode: JavascriptMode.unrestricted,
          //   onWebViewCreated: (controller) {
          //     controller.loadUrl(url,headers: {});
          //   },
          //   javascriptChannels: <JavascriptChannel>[
          //     JavascriptChannel(
          //         name: "share",
          //         onMessageReceived: (JavascriptMessage message) {
          //           if(message.message!=null){
          //             G.pop();

          //             Map msg =  json.decode(message.message);
          //             List arr = [];
          //             arr.add(msg['base64']);
          //             Map<String,Object> map1 = {"files": arr,"idCard":'111'};
          //             HomeApi.getSingleton().uploadImg(map1).then((res){
          //               if(res!=null){
          //                 if(res['code']==200){
          //                   log(msg['encDataFilePath'].toString());
          //                   EasyLoading.show();
          //                   jiaMiBao = jsonDecode(msg['encDataFilePath']);
          //                   doSetSignName(res['item'][0]['filePath']);
          //                   isName = false;
          //                   notifyListeners();
          //                 }
          //               }
          //             });
          //           }
          //         }
          //     ),
          //   ].toSet(),
          //   onPageFinished: (url) {
          //     EasyLoading.dismiss();
          //   },
          // );
        });
  }

// 底部弹窗签名
  Future<int> _showCustomModalBottomSheet(context, String name) async {
    return showModalBottomSheet<int>(
      enableDrag: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(20.0),
              topRight: const Radius.circular(20.0),
            ),
          ),
          // height: MediaQuery.of(context).size.height / 1.3,
          // height: 500,
          child: Column(children: [
            SizedBox(
              height: 50,
              child: Stack(
                textDirection: TextDirection.rtl,
                children: [
                  Center(
                    child: Text(
                      '签名区域',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ),
                  IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown
                        ]);
                        Navigator.of(context).pop();
                      }),
                ],
              ),
            ),
            Divider(height: 1.0),
            qmDemoPage1(
            orderId: arguments[0]['orderId'],
            idCard: userViewModel.idCard,
            name: name,
            unitGuid: arguments[0]['unitGuid'],
            notarizationMatters: arguments,
            notaryForm: number.toString())
            // qmDemoPage1(
            //     name: name,
            //     unitGuid: "code",
            //     notarizationMatters: "roomId",
            //     idCard: userViewModel.idCard,
            //     userIdCard: "idCard")
          ]),
        );
      },
    );
  }

  void doSetSignName(String path) async {
    //签字
    var map = {
      "unitGuid": arguments["orderId"],
      "signName": Config.splicingImageUrl(path),
      "encDataFilePath": jiaMiBao,
    };
    print("++++++++++++++$map");
    HomeApi.getSingleton().doSetSignName(map).then((value) {
      EasyLoading.dismiss();
      if (value["code"] == 200) {
        ToastUtil.showSuccessToast("签字成功！");
        G.pushNamed(RoutePaths.SubmitOrderList, arguments: {
          // "notarizationMatters": arguments["notarizationMatters"],
          "orderId": arguments["orderId"],
          // "notaryForm": arguments["notaryForm"]
        });
      } else {
        ToastUtil.showErrorToast(value["msg"]);
        G.pop();
      }
    });
  }

  //上传材料图片
  Future updateOtherImage(id, MultipartFile file) async {
    var res = await HomeApi.getSingleton().uploadPictures(file);
    if (res['code'] == 200) {
      if (!imageMap.containsKey(id)) {
        imageMap[id] = [];
      }
      imageMap[id].add(res["item"]['unitGuid']);
      print('imageMap-----$imageMap');
    } else {
      EasyLoading.dismiss();
      ToastUtil.showErrorToast("图片上传失败");
    }
    notifyListeners();
  }

  void getUpLoadMaterialName() async {
    setBusy(true);
    arguments.forEach((data) {
      materialIdList.add(data["notaryItemId"]);
    });

    var map = {"unitGuid": materialIdList.join(",")};
    print('arguments-------$arguments');
    HomeApi.getSingleton().getUpLoadMaterialName(map).then((value) {
      setBusy(false);
      if (value["code"] == 200) {
        print("getUpLoadMaterialName-------${value['items']}");
        value["items"].forEach((data) {
          bool isHas = false;
          materialList.forEach((element) {
            if (element['name'] == data['name']) {
              isHas = true;
            }
          });
          if (!isHas) {
            materialList.add(data);
            materialData = {
              "unitGuid": data["unitGuid"],
              "materialName": data["name"],
              "annexFileLists": [],
              "notaryItemId": data["notaryItemModelId"],
              "orderId": arguments[0]["orderId"],
            };
            upLoadData.add(materialData);
          }
        });
      }
    });
  }

  void previewFile() async {
    EasyLoading.show();
    upLoadData.forEach((element) {
      if (imageMap.containsKey(element["unitGuid"])) {
        List tempList = element['annexFileLists'];
        tempList.addAll(imageMap[element["unitGuid"]]);
        element["annexFileLists"] = tempList;
      } else {
        element["annexFileLists"] = [];
      }
    });
    var map = {
      "items": JsonUtil.encodeObj(upLoadData),
      "orderId": arguments[0]["orderId"],
    };
    print("预览参数$map");
    HomeApi.getSingleton().previewFile(map, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {
      EasyLoading.dismiss();
      if (value["code"] == 200) {
        isEdite = false;
        notifyListeners();
        ToastUtil.showSuccessToast("订单提交成功！");
        value["pdfImgPaths"].forEach((data) {
          previewImgList.add(Config.splicingImageUrl(data));
        });
        showImg();
      } else {
        ToastUtil.showErrorToast(value["msg"]);
      }
    });
  }

  showImg() {
    showDialog(
        context: G.getCurrentState().overlay.context,
        builder: (ctx) {
          return PhotoViewGalleryScreen(
              height: videoHeight,
              isBase64: false,
              onWillPop: () {
                return Future.value(false);
              },
              onTop: () {
                G.pop();
                String orderId = arguments[0]["orderId"];
                Navigator.pushNamed(ctx, RoutePaths.faceCompareIdentifyWidget,arguments: {'orderId':orderId}).then((value){
                  alreadyRead = true;
                  notifyListeners();
                });
                // alreadyRead = true;
                // notifyListeners();
              },
              images: previewImgList,
              //传入图片list
              index: 0,
              //传入当前点击的图片的index
              heroTag: "1");
        });
  }

  void setSelectType(String value) {
    selectType = value;
    notifyListeners();
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    if (httpImageUrlList != null && httpImageUrlList.isNotEmpty) {
      for (int i = 0; i < httpImageUrlList.length; i++) {
        Map<String, dynamic> temp = new Map();
        temp['name'] = httpImageUrlList[i]['materialName'];
        temp['unitGuid'] = httpImageUrlList[i]['unitGuid'];
        List tempListData = [];
        httpImageUrlList[i]['annexs'].forEach((e) {
          tempListData.add(e['unitGuid']);
        });
        materialData = {
          "unitGuid": httpImageUrlList[i]["unitGuid"],
          "materialName": httpImageUrlList[i]["materialName"],
          "annexFileLists": tempListData,
          "notaryItemId": httpImageUrlList[i]["notaryItemId"],
          "orderId": arguments[0]["orderId"],
        };
        upLoadData.add(materialData);
        if (httpImageUrlList[i]['annexs'] != null) {
          List tempList = httpImageUrlList[i]['annexs'];
          ReleaseCon releaseCon = new ReleaseCon();
          List tempImageList = [];
          // List unitGuidList = [];
          for (int j = 0; j < tempList.length; j++) {
            tempImageList.add(tempList[j]['filePath']);
            // unitGuidList.add(tempList[j]['unitGuid']);
          }
          List<ReleaseModel> releaseList = [
            ReleaseModel('', tempImageList, [])
          ];
          releaseCon.setReleaseList(releaseList);
          temp['releaseCon'] = releaseCon;
          // imageMap[httpImageUrlList[i]['notaryItemId']] = unitGuidList;
        }
        bool isHas = false;
        materialList.forEach((e) {
          if (e['name'] == temp['name']) {
            isHas = true;
          }
        });
        if (!isHas) {
          materialList.add(temp);
        }
      }
      alreadyRead = false;
      isEdite = true;
      // if(orderLogs[0]['notaryState']==31){
      //   alreadyRead = false;
      //   isEdite = true;
      // }else{
      //   alreadyRead = true;
      //   isEdite = false;
      // }
      notifyListeners();
    } else {
      getUpLoadMaterialName();
    }

    DateTime now = new DateTime.now();
    this.toDay = "${now.year}-${now.month}-${now.day}";
    this.arguments.forEach((item) {
      this.notaryItems.add(item);
    });
    return null;
  }
}
