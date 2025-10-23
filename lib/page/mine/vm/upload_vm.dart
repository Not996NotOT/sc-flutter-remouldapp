// import 'dart:async';
// import 'dart:io';
// import 'package:chewie/chewie.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_h5pay/flutter_h5pay.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:http_parser/http_parser.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
// import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
// import 'package:notarization_station_app/components/throttleUtil.dart';
// import 'package:notarization_station_app/iconfont/Icon.dart';
// import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
// import 'package:notarization_station_app/service_api/home_api.dart';
// import 'package:notarization_station_app/utils/global.dart';
// import 'package:notarization_station_app/utils/throttle_anti-shake.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// // import 'package:screen_recorder_flutter/screen_recorder_flutter.dart';
// import 'package:tobias/tobias.dart';
// import 'package:amap_location_fluttify/amap_location_fluttify.dart';
// import 'package:video_compress/video_compress.dart';
// import 'package:video_player/video_player.dart';
// import '../../../appTheme.dart';
// import 'apk_update_model.dart';
//
// class UploadModel extends SingleViewStateModel with WidgetsBindingObserver {
//   UserViewModel userViewModel;
//
//   String image = ""; //拍照上传的预览
//   String video = ""; //录像上传的预览
//   num fromWhere = 0;
//   Map uploadVideo = {};
//   String playUrl = "";
//   var imageUrl;
//   File pickedVideo;
//   String screenUrl = "";
//   int payTotal = 0;
//   String orderNum; //订单编号
//   Timer timer;
//   Timer timerPay;
//   int numPay = 1;
//   String uploadPath = ""; //上传到服务器返回的地址
//   int numTime = 0;
//   bool isPay = true;
//
//   bool hasStarted = false;
//   String message = "";
//   VideoPlayerController controller;
//   ChewieController chewieController;
//   UploadModel(this.userViewModel);
//   // 是否进行支付宝跳转
//   bool isAliPayJump = false;
//
//   @override
//   Future loadData() {
//     addWidgetsBindingObserver();
//     return null;
//   }
//
//   @override
//   onCompleted(data) {}
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     super.didChangeAppLifecycleState(state);
//     switch (state) {
//       case AppLifecycleState.resumed:
//         if (isAliPayJump && Platform.isIOS) {
//           _alipayOrderState();
//         }
//         break;
//     }
//   }
//
//   void addWidgetsBindingObserver() {
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   void removeWidgetsBindingObserver() {
//     WidgetsBinding.instance.removeObserver(this);
//   }
//
//   getVideo() async {
//     pickedVideo = await ImagePicker.pickVideo(source: ImageSource.camera);
//     print("--------------------------------${pickedVideo.path}");
//     AudioPlayer player = AudioPlayer();
//     Duration d = await player.setFilePath(pickedVideo.path);
//     numTime = d.inMinutes;
//     print("+++++时长${pickedVideo.path}");
//     player.dispose();
//     File file = new File(pickedVideo.path);
//     controller = VideoPlayerController.file(file);
//     chewieController = ChewieController(
//       videoPlayerController: controller,
//       autoPlay: false,
//       looping: true,
//     );
//     // BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//     //     BetterPlayerDataSourceType.memory,
//     //     pickedVideo.path,
//     //     bytes: bytes
//     // );
//     // betterPlayerController = BetterPlayerController(
//     //     BetterPlayerConfiguration(),
//     //     betterPlayerDataSource: betterPlayerDataSource);
//     fromWhere = 2;
//     openAlertDialog();
//     notifyListeners();
//   }
//
//   getImage() async {
//     if(Platform.isAndroid){
//       if(!await Permission.storage.status.isGranted || !await Permission.camera.status.isGranted){
//         G.showCustomToast(
//             context: G.getCurrentContext(),
//             titleText: "相机、存储权限使用说明：",
//             subTitleText: "用于拍摄、录制视频、文件存储等场景",
//             time: 2
//         );
//       }
//       if (await Permission.storage.request().isGranted && await Permission.camera.request().isGranted) {
//         imageUrl = await ImagePicker.pickImage(source: ImageSource.camera);
//         print("11111111......$imageUrl");
//         if (imageUrl != null) {
//           fromWhere = 1;
//           openAlertDialog();
//         }
//       }else{
//         G.showPermissionDialog(str: "访问内部存储、相机权限");
//       }
//     }
//     if(Platform.isIOS){
//       if(await Permission.photos.request().isGranted){
//         imageUrl = await ImagePicker.pickImage(source: ImageSource.camera);
//         print("11111111......$imageUrl");
//         if (imageUrl != null) {
//           fromWhere = 1;
//           openAlertDialog();
//         }
//       }else{
//         G.showPermissionDialog(str: "访问相册权限");
//       }
//     }
//     // ignore: deprecated_member_use
//
//   }
//
//   uploadImage(imgPath, fileSize) async {
//     //上传拍照
//     EasyLoading.show(status: "生成存证信息中");
//     if(!await Permission.location.status.isGranted){
//       G.showCustomToast(
//         context: G.getCurrentContext(),
//         titleText: "定位权限使用说明：",
//         subTitleText: "用于获取当前位置信息",
//         time: 2,);
//     }
//     if (await Permission.location.request().isGranted) {
//       Location location = await AmapLocation.instance.fetchLocation();
//       print("位置信息：-----$location");
//       var map = {
//         //"userId":userViewModel.unitGuid,
//         "userName": userViewModel.userName,
//         "imgPath": imgPath,
//         "fee": 10,
//         "address": location.address,
//         "fileSize": fileSize,
//         "obtainEvidenceDate": DateTime.now().toString().substring(0, 19),
//       };
//       print("上传----------------------------------$map");
//       HomeApi.getSingleton().addAutoOrder(map, errorCallBack: (e) {
//         EasyLoading.dismiss();
//       }).then((res) {
//         EasyLoading.dismiss();
//         if (res["code"] == 200) {
//           ToastUtil.showNormalToast("拍照上传成功！");
//           notifyListeners();
//         } else {
//           ToastUtil.showErrorToast(res["msg"]);
//         }
//       });
//     } else {
//       G.showPermissionDialog(str: "访问定位权限");
//     }
//   }
//
//   uploadVideoUrl(videoPath, fileSize) async {
//     //上传录像
//     EasyLoading.show(status: "生成存证信息中");
//     if(!await Permission.location.status.isGranted){
//       G.showCustomToast(
//         context: G.getCurrentContext(),
//         titleText: "定位权限使用说明：",
//         subTitleText: "用于获取当前位置信息",
//         time: 2,);
//     }
//     if (await Permission.location.request().isGranted) {
//       Location location = await AmapLocation.instance.fetchLocation();
//       var map = {
//         //"userId":userViewModel.unitGuid,
//         "userName": userViewModel.userName,
//         "videoPath": videoPath,
//         "fee": numTime < 2 ? 10 : (numTime + 1) * 5,
//         "address": location.address,
//         "fileSize": fileSize,
//         "obtainEvidenceDate": DateTime.now().toString().substring(0, 19),
//       };
//       print("++++++++++位置信息+++++++++++$map");
//       HomeApi.getSingleton().addAutoOrder(map, errorCallBack: (e) {
//         EasyLoading.dismiss();
//       }).then((res) {
//         EasyLoading.dismiss();
//         if (res["code"] == 200) {
//           ToastUtil.showNormalToast("录像上传成功！");
//           notifyListeners();
//         } else {
//           ToastUtil.showErrorToast(res["msg"]);
//         }
//       });
//     } else {
//       G.showPermissionDialog(str: "访问定位权限");
//     }
//   }
//
//   uploadScreenUrl(screenPath, fileSize) async {
//     //上传录屏
//     EasyLoading.show(status: "生成存证信息中");
//     if(!await Permission.location.status.isGranted){
//       G.showCustomToast(
//         context: G.getCurrentContext(),
//         titleText: "定位权限使用说明：",
//         subTitleText: "用于获取当前位置信息",
//         time: 2,);
//     }
//     if (await Permission.location.request().isGranted) {
//       Location location = await AmapLocation.instance.fetchLocation();
//       print("位置信息：-----$location");
//       var map = {
//         //"userId":userViewModel.unitGuid,
//         "userName": userViewModel.userName,
//         "screencapPath": screenPath,
//         "fee": numTime < 2 ? 10 : (numTime + 1) * 5,
//         "address": location.address,
//         "fileSize": fileSize,
//         "obtainEvidenceDate": DateTime.now().toString().substring(0, 19),
//       };
//       print("++++++++++位置信息+++++++++++$map");
//       HomeApi.getSingleton().addAutoOrder(map).then((res) {
//         EasyLoading.dismiss();
//         if (res["code"] == 200) {
//           ToastUtil.showNormalToast("录屏上传成功！");
//           notifyListeners();
//         } else {
//           ToastUtil.showErrorToast(res["msg"]);
//         }
//       });
//     } else {
//       G.showPermissionDialog(str: "访问定位权限");
//     }
//   }
//
//   openAlertDialog() async {
//     await showDialog(
//       context: G.getCurrentState().overlay.context,
//       barrierDismissible: false, //// user must tap button!
//       builder: (BuildContext context) {
//         return Dialog(
//           insetPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
//           child: Container(
//             height: 400,
//             width: double.infinity,
//             child: Column(
//               children: [
//                 Expanded(
//                   child: Padding(
//                       padding: EdgeInsets.only(top: 10),
//                       child: fromWhere == 1
//                           ? Image.file(imageUrl)
//                           : Center(
//                               child: AspectRatio(
//                                 aspectRatio: fromWhere == 3 ? 16 / 9 : 10 / 8,
//                                 child: Chewie(
//                                   controller: chewieController,
//                                 ),
//                               ),
//                             )),
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     // ignore: deprecated_member_use
//                     TextButton(
//                       child: Text(
//                         '取消',
//                         style: TextStyle(color: AppTheme.themeBlue),
//                       ),
//                       onPressed: () {
//                         G.pop();
//                         if (fromWhere != 1) {
//                           chewieController.pause();
//                         }
//                       },
//                     ),
//                     SizedBox(
//                       width: 30,
//                     ),
//                     // ignore: deprecated_member_use
//                     FlatButton(
//                       child: Text('确认',
//                           style: TextStyle(color: AppTheme.themeBlue)),
//                       onPressed: ThrottleUtil().throttle(() {
//                         G.pop();
//                         // uploadFile();
//                         if (fromWhere == 1) {
//                           goPay(1000);
//                         } else {
//                           chewieController.pause();
//                           goPay(numTime < 2 ? 1000 : (numTime + 1) * 500);
//                         }
//                       }),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//   // startRecording() async {
//   //   ScreenRecorderFlutter.startScreenRecord;
//   //   notifyListeners();
//   // }
//
//   // stopRecording() async {
//   //   ScreenRecorderFlutter.stopScreenRecord;
//   //   notifyListeners();
//   // }
//
//   goPay(int payNum) {
//     print("++++++++++支付信息+++++++++++$payNum");
//     showModalBottomSheet(
//       context: G.getCurrentState().overlay.context,
//       backgroundColor: Colors.transparent,
//       builder: (BuildContext context) {
//         return Container(
//           height: 150,
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(15),
//               topRight: Radius.circular(15),
//             ),
//           ),
//           width: double.infinity,
//           child: Column(
//             children: <Widget>[
//               InkWell(
//                 onTap: throttle(() async {
//                   EasyLoading.show();
//                   await Future.delayed(Duration(milliseconds: 1000));
//                   Map<String, dynamic> map = {
//                     "outTradeNo": orderNum,
//                     "subject": "自助存证",
//                     "fee": payNum / 100
//                   };
//                   HomeApi.getSingleton().autoAliPay(map).then((res) {
//                     EasyLoading.dismiss();
//                     if (res != null) {
//                       if (res['code'] == 200) {
//                         _alipay(res['item']);
//                       }
//                     }
//                   });
//                 }),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       border: Border(
//                           bottom: BorderSide(width: 1, color: AppTheme.bg_e))),
//                   padding: EdgeInsets.fromLTRB(30, 30, 10, 20),
//                   child: Row(
//                     children: <Widget>[
//                       aliPayIco(
//                         color: Color(0xff3CA4FB),
//                         size: 30,
//                       ),
//                       SizedBox(
//                         width: 20,
//                       ),
//                       Text('支付宝支付',
//                           style: TextStyle(
//                               fontSize: 16, color: AppTheme.dark_grey)),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: BoxDecoration(
//                     border: Border(
//                         bottom: BorderSide(width: 1, color: AppTheme.bg_e))),
//                 padding: EdgeInsets.fromLTRB(30, 20, 10, 10),
//                 child: Row(
//                   children: <Widget>[
//                     weChatIco(
//                       color: Colors.green,
//                       size: 30,
//                     ),
//                     SizedBox(
//                       width: 20,
//                     ),
//                     Expanded(
//                       child: SizedBox(
//                         height: 30,
//                         child: H5PayWidget(
//                           timeout: Duration(seconds: 30),
//                           refererScheme: Platform.isAndroid
//                               ? "https://sc.njguochu.com"
//                               : "sc.njguochu.com://",
//                           builder: (ctx, controller) {
//                             return InkWell(
//                                 onTap: throttle(() async {
//                                   EasyLoading.show();
//                                   timerPay?.cancel();
//                                   isPay = true;
//                                   await Future.delayed(
//                                       Duration(milliseconds: 1000));
//                                   Map<String, dynamic> map = {
//                                     "orderGuid": orderNum,
//                                   };
//                                   HomeApi.getSingleton()
//                                       .autoWxPay(map)
//                                       .then((res) {
//                                     EasyLoading.dismiss();
//                                     if (res != null) {
//                                       if (res['code'] == 200) {
//                                         controller
//                                             .pay(res['result']['mweb_url'],
//                                                 jumpPayResultCallback: (p) {
//                                           print("是否进行了微信支付 ->$p");
//                                           if (p == JumpPayResult.SUCCESS) {
//                                             print("进行了支付跳转,但是我不知道用户到底有没有进行支付");
//                                             timerPay = Timer.periodic(
//                                                 Duration(seconds: 5), (t) {
//                                               numPay++;
//                                               Map<String, Object> map1 = {
//                                                 "outTradeNo": orderNum
//                                               };
//                                               HomeApi.getSingleton()
//                                                   .getPay(map1)
//                                                   .then((value) {
//                                                 if (value['code'] == 200 &&
//                                                     value['item']
//                                                             ['tradeStatus'] ==
//                                                         "SUCCESS" &&
//                                                     isPay) {
//                                                   print(
//                                                       "微信支付与否-------------------------");
//                                                   isPay = false;
//                                                   G.pop();
//                                                   t.cancel();
//                                                   uploadFile();
//                                                 }
//                                               });
//                                               if (numPay > 17) {
//                                                 t.cancel();
//                                               }
//                                             });
//                                           } else if (p ==
//                                               JumpPayResult.TIMEOUT) {
//                                             print("支付跳转失败");
//                                             ToastUtil.showNormalToast("支付失败");
//                                           } else if (p == JumpPayResult.FAIL) {
//                                             print("没有安装或者不允许本应用打开微信支付");
//                                             ToastUtil.showNormalToast(
//                                                 "没有安装微信或者不允许本应用打开微信支付");
//                                           }
//                                         });
//                                       } else if (res['code'] == 500) {
//                                         ToastUtil.showNormalToast(res['msg']);
//                                       } else {
//                                         ToastUtil.showNormalToast("支付失败");
//                                       }
//                                     }
//                                   });
//                                 }),
//                                 child: Container(
//                                     width: double.infinity,
//                                     child: Text("微信支付",
//                                         style: TextStyle(
//                                             fontSize: 16,
//                                             color: AppTheme.dark_grey))));
//                           },
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   _alipay(payInfo) async {
//     EasyLoading.show(status: "付款中...");
//     isAliPayJump = true;
//     var result = await aliPay(payInfo);
//     EasyLoading.dismiss();
//     if (result['resultStatus'] == "9000") {
//       G.pop();
//       if (fromWhere == 1 || fromWhere == 2 || fromWhere == 3) {
//         uploadFile();
//       }
//     } else if (result['resultStatus'] == "6001") {}
//   }
//
//   void _alipayOrderState() {
//     print("++++++++++++++++++++++++++计数器++$numPay");
//     Map<String, Object> map1 = {"outTradeNo": orderNum};
//     EasyLoading.dismiss();
//     HomeApi.getSingleton().getAliPayState(map1).then((value) {
//       print("支付包查询订单状态成功后返回的数据------$value");
//       if (value['code'] == 200 && value['item']['code'] == "10000") {
//         isAliPayJump = false;
//         G.pop();
//         if (fromWhere == 1 || fromWhere == 2 || fromWhere == 3) {
//           uploadFile();
//         }
//         // Future.delayed(Duration.zero).then((value) => G.pushNamed(RoutePaths.HomeIndex));
//       } else {}
//     });
//     // if (numPay > 17) {
//     //   t.cancel();
//     //   numPay = 1;
//     // }
//     // });
//   }
//
//   uploadFile() async {
//     //uploadDialog();
//     if (fromWhere == 1) {
//       print("--------------------------------1");
//       EasyLoading.show(status: "正在上传...");
//       String name = imageUrl.path
//           .substring(imageUrl.path.lastIndexOf("/") + 1, imageUrl.path.length);
//       final result = await FlutterImageCompress.compressWithFile(
//         imageUrl.path,
//         minWidth: 2300, //压缩后的最小宽度
//         minHeight: 1500, //压缩后的最小高度
//         quality: 20, //压缩质量
//         rotate: 0, //旋转角度
//       );
//       MultipartFile multipartFile = MultipartFile.fromBytes(
//         result,
//         filename: name,
//         contentType: MediaType("image", "jpg"),
//       );
//       HomeApi.getSingleton().uploadPictures(multipartFile).then((data) {
//         EasyLoading.dismiss();
//         if (data["code"] == 200) {
//           uploadPath = data["item"]["filePath"];
//           uploadImage(uploadPath, data["item"]["fileSize"]);
//         }
//       });
//     } else if (fromWhere == 2) {
//       print('未处理前的视频文件大小 -> ${pickedVideo.lengthSync()}');
//       EasyLoading.show(status: "正在处理视频文件中");
//       MediaInfo mediaInfo = await VideoCompress.compressVideo(
//         pickedVideo.path,
//         quality: VideoQuality.DefaultQuality,
//         deleteOrigin: false, // It's false by default
//       );
//
//       String name = pickedVideo.path.substring(
//           pickedVideo.path.lastIndexOf("/") + 1,
//           pickedVideo.path.toString().length);
//       // Subscription _subscription =
//       //     VideoCompress.compressProgress$.subscribe((progress) async {
//       //   print('progress: $progress');
//       // if (progress == 100) {
//       // MultipartFile multipartFile = await MultipartFile.fromFile(
//       //   mediaInfo.path,
//       //   filename: name,
//       //   contentType: MediaType("video", "mp4"),
//       // );
//       // EasyLoading.show(status: "正在上传文件中");
//       // HomeApi.getSingleton().uploadPictures(multipartFile).then((data){
//       //   EasyLoading.dismiss();
//       //   if(data["code"] == 200){
//       //     uploadPath = data["item"]["filePath"];
//       //     uploadVideoUrl(uploadPath,data["item"]["fileSize"]);
//       //   }
//       // });
//       // print('压缩过后的视频文件大小 -> ${File(mediaInfo.path).lengthSync()}');
//       Map<String, dynamic> data = {"fileName": name};
//       EasyLoading.show(status: "正在上传文件中");
//       HomeApi.getSingleton().uploadPageId(data).then((value) {
//         print("-----------$value");
//         if (value != null && value['code'] == 200) {
//           getPaging(mediaInfo.path, value['data'], name);
//         } else {
//           EasyLoading.dismiss();
//           ToastUtil.showNormalToast("出错了，请重新上传！");
//         }
//       });
//       // }
//       // });
//       // _subscription.unsubscribe();
//       // print("--------------------------------${mediaInfo.path}");
//     } else {
//       String name = screenUrl.substring(
//           screenUrl.lastIndexOf("/") + 1, screenUrl.toString().length);
//       MultipartFile multipartFile = await MultipartFile.fromFile(
//         screenUrl,
//         filename: name,
//         contentType: MediaType("video", "mp4"),
//       );
//       HomeApi.getSingleton().uploadPictures(multipartFile).then((data) {
//         EasyLoading.dismiss();
//         if (data["code"] == 200) {
//           uploadPath = data["item"]["filePath"];
//           uploadScreenUrl(uploadPath, data["item"]["fileSize"]);
//         }
//       });
//     }
//   }
//
//   getOrderNum() {
//     //随机生成订单号
//     orderNum = DateTime.now().millisecondsSinceEpoch.toString();
//   }
//
//   uploadDialog() async {
//     await showDialog(
//       context: G.getCurrentState().overlay.context,
//       barrierDismissible: false, //// user must tap button!
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.transparent,
//           title: Text("上传中..."),
//           content: Consumer<ApkUpdateModel>(builder: (context, model, child) {
//             return LinearProgressIndicator(
//               value: model.uploadFile,
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
//               backgroundColor: Colors.blue,
//             );
//           }),
//           shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.all(Radius.circular(10))),
//         );
//       },
//     );
//   }
//
//   getPaging(path, uploadId, fileName) async {
//     // 读文件
//     var s = await File(path).open();
//     int x = 0;
//     int size = File(path).lengthSync();
//     int chunkSize = 5242880;
//     List<int> val;
//     int num = size % chunkSize > 0 ? 1 : 0;
//     int num1 = size ~/ chunkSize + num;
//     int num2 = 1;
//     Map info;
//     bool isTrue = true;
//     while (x < size) {
//       int _len = size - x >= chunkSize ? chunkSize : size - x;
//       bool lastChunk = size - x >= chunkSize ? false : true;
//       val = s.readSync(_len).toList();
//       x = x + _len;
//       print(
//           "2: ${val.runtimeType}-----$num1------$num2----$lastChunk,----$_len");
//       MultipartFile multipartFile = MultipartFile.fromBytes(
//         val,
//         filename: "$num2$fileName",
//       );
//       FormData formData = FormData.fromMap({
//         "multipartFile": multipartFile,
//         "uploadId": uploadId,
//         "fileName": "$fileName",
//         "fileSort": num2,
//         "fileSortCounts": num1,
//         "lastChunk": lastChunk
//       });
//       info = await HomeApi.getSingleton().uploadPart(formData);
//       if (info['code'] != 200) {
//         isTrue = false;
//         ToastUtil.showErrorToast("上传文件时出错了！");
//       }
//       num2++;
//     }
//     await s.close();
//     print("4: $info");
//     if (isTrue) {
//       uploadPath = info["data"];
//       uploadVideoUrl(info["data"], size);
//     } else {
//       EasyLoading.dismiss();
//       ToastUtil.showNormalToast("出错了，请重新上传！");
//     }
//   }
// }
