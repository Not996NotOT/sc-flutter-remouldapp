// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
// import 'package:notarization_station_app/components/throttleUtil.dart';
// import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
// import 'package:notarization_station_app/routes/router.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
// import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
// import 'package:notarization_station_app/page/mine/vm/upload_vm.dart';
// import 'package:screen_recorder_flutter/screen_recorder_flutter.dart';
// import '../../appTheme.dart';
//
// class UploadPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return UploadPageState();
//   }
// }
//
// class UploadPageState extends BaseState<UploadPage> {
//   UserViewModel userModel;
//   UploadModel vm;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     goInit();
//   }
//
//   goInit() {
//     ScreenRecorderFlutter.init(onRecordingStarted: (started, msg) {
//       vm.hasStarted = started;
//       vm.message = msg;
//       setState(() {});
//     }, onRecodingCompleted: (path) async {
//       if (vm.hasStarted) {
//         vm.screenUrl = path;
//         AudioPlayer player = AudioPlayer();
//         Duration d = await player.setFilePath(path);
//         vm.numTime = d.inMinutes;
//         wjPrint("+++++时长${vm.numTime}");
//         player.dispose();
//         // BetterPlayerDataSource betterPlayerDataSource = BetterPlayerDataSource(
//         //     BetterPlayerDataSourceType.file,
//         //     path);
//         // vm.betterPlayerController = BetterPlayerController(
//         //     BetterPlayerConfiguration(),
//         //     betterPlayerDataSource: betterPlayerDataSource);
//         vm.fromWhere = 3;
//         vm.openAlertDialog();
//         vm.hasStarted = false;
//         setState(() {});
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     /**
//      * 当页面销毁的时候，将视频播放器也销毁
//      * 否则，当页面销毁后会继续播放视频！
//      */
//     vm.controller?.dispose();
//     vm.timerPay?.cancel();
//     vm.chewieController?.dispose();
//     vm.removeWidgetsBindingObserver();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: AppTheme.App_bar,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         title: Text(
//           "自助存证",
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//         elevation: 0,
//         leading: InkWell(
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//             size: 22,
//           ),
//           onTap: () {
//             if (vm.hasStarted) {
//               vm.stopRecording();
//             } else {
//               Navigator.of(context).pop();
//             }
//           },
//         ),
//       ),
//       body: WillPopScope(
//         onWillPop: () {
//           if (vm.hasStarted) {
//             vm.stopRecording();
//           } else {
//             Navigator.of(context).pop();
//           }
//           return Future.value(false);
//         },
//         child: Container(
//           height: getHeightPx(1334),
//           child: Consumer<UserViewModel>(
//             builder: (ctx, userModel, child) {
//               this.userModel = userModel;
//               return ProviderWidget<UploadModel>(
//                 model: UploadModel(userModel),
//                 onModelReady: (model) {
//                   vm = model;
//                   vm.initData();
//                 },
//                 builder: (ctx, vm, child) {
//                   return Column(
//                     children: <Widget>[
//                       Container(
//                         height: getHeightPx(350),
//                         width: getWidthPx(750),
//                         padding: EdgeInsets.only(
//                             left: getWidthPx(30),
//                             top: getWidthPx(60),
//                             right: getWidthPx(30),
//                             bottom: getWidthPx(40)),
//                         decoration: BoxDecoration(
//                             image: new DecorationImage(
//                                 image: new AssetImage(
//                                     "lib/assets/images/uploadBac.png"),
//                                 fit: BoxFit.fill)),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             Text(
//                               "自助存证（个人版）",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontSize: 16),
//                             ),
//                             SizedBox(
//                               height: getWidthPx(30),
//                             ),
//                             Text(
//                               "借助“互联网+区块链”技术，申请办理知识产权存证，经过算法加密后上传公证处服务器存储。",
//                               style:
//                                   TextStyle(color: Colors.white, fontSize: 14),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         height: getWidthPx(30),
//                         color: AppTheme.bg_b,
//                       ),
//                       Column(
//                         children: <Widget>[
//                           InkWell(
//                             onTap: ThrottleUtil().throttle(() {
//                               if (vm.hasStarted) {
//                                 ToastUtil.showNormalToast("正在录屏中...");
//                               } else {
//                                 vm.getImage();
//                                 vm.getOrderNum();
//                               }
//                             }),
//                             child: Container(
//                               height: getHeightPx(130),
//                               width: getWidthPx(650),
//                               margin: EdgeInsets.only(
//                                 top: getWidthPx(50),
//                                 left: getWidthPx(50),
//                                 right: getWidthPx(50),
//                               ),
//                               decoration: BoxDecoration(
//                                   image: new DecorationImage(
//                                       image: new AssetImage(
//                                           "lib/assets/images/cameraBac.png"),
//                                       fit: BoxFit.fill)),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: <Widget>[
//                                   Container(
//                                     height: getHeightPx(60),
//                                     width: getWidthPx(80),
//                                     margin:
//                                         EdgeInsets.only(left: getWidthPx(40)),
//                                     decoration: BoxDecoration(
//                                         image: new DecorationImage(
//                                             image: new AssetImage(
//                                                 "lib/assets/images/getCamera.png"),
//                                             fit: BoxFit.contain)),
//                                   ),
//                                   Spacer(),
//                                   Text(
//                                     "拍照上传",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 16),
//                                   ),
//                                   SizedBox(
//                                     width: getWidthPx(40),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           InkWell(
//                             onTap: ThrottleUtil().throttle(() {
//                               if (vm.hasStarted) {
//                                 ToastUtil.showNormalToast("正在录屏中...");
//                               } else {
//                                 vm.getVideo();
//                                 vm.getOrderNum();
//                               }
//                             }),
//                             child: Container(
//                               height: getHeightPx(130),
//                               width: getWidthPx(650),
//                               margin: EdgeInsets.only(
//                                 top: getWidthPx(50),
//                                 left: getWidthPx(50),
//                                 right: getWidthPx(50),
//                               ),
//                               decoration: BoxDecoration(
//                                   image: new DecorationImage(
//                                       image: new AssetImage(
//                                           "lib/assets/images/videoBac.png"),
//                                       fit: BoxFit.fill)),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: <Widget>[
//                                   Container(
//                                     height: getHeightPx(60),
//                                     width: getWidthPx(80),
//                                     margin:
//                                         EdgeInsets.only(left: getWidthPx(40)),
//                                     decoration: BoxDecoration(
//                                         image: new DecorationImage(
//                                             image: new AssetImage(
//                                                 "lib/assets/images/getVideo.png"),
//                                             fit: BoxFit.contain)),
//                                   ),
//                                   Spacer(),
//                                   Text(
//                                     "录像上传",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 16),
//                                   ),
//                                   SizedBox(
//                                     width: getWidthPx(40),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                           // InkWell(
//                           //   onTap: () async{
//                           //     final photos = await Permission.photos.request();
//                           //     final microphone = await Permission.microphone.request();
//                           //     final storageS = await Permission.storage.request();
//                           //     final status = await Permission.speech.request();
//                           //     final cameraS = await Permission.camera.request();
//                           //     if (photos == PermissionStatus.granted && microphone == PermissionStatus.granted && storageS == PermissionStatus.granted && status == PermissionStatus.granted && cameraS == PermissionStatus.granted) {
//                           //           if(!vm.hasStarted){
//                           //             vm.startRecording();
//                           //           }else{
//                           //             vm.stopRecording();
//                           //           }
//                           //     }
//                           //     vm.getOrderNum();
//                           //   },
//                           //   child: Container(
//                           //     height: getHeightPx(130),
//                           //     width: getWidthPx(650),
//                           //     margin: EdgeInsets.only(top: getWidthPx(50),left: getWidthPx(50),right: getWidthPx(50),),
//                           //     decoration: BoxDecoration(
//                           //         image: new DecorationImage(
//                           //             image: new AssetImage("lib/assets/images/screenBac.png"),
//                           //             fit: BoxFit.fill)
//                           //     ),
//                           //     child: Row(
//                           //       mainAxisAlignment : MainAxisAlignment.spaceAround,
//                           //       children: <Widget>[
//                           //         Container(
//                           //           height: getHeightPx(60),
//                           //           width: getWidthPx(80),
//                           //           margin: EdgeInsets.only(left: getWidthPx(40)),
//                           //           decoration: BoxDecoration(
//                           //               image: new DecorationImage(
//                           //                   image: new AssetImage("lib/assets/images/getScreen.png"),
//                           //                   fit: BoxFit.contain)
//                           //           ),
//                           //         ),
//                           //         Spacer(),
//                           //         Text(vm.hasStarted?"正在录屏（点击停止）":"录屏上传",style: TextStyle(color: Colors.white,fontSize: 16),),
//                           //         SizedBox(width: getWidthPx(40),)
//                           //       ],
//                           //     ),
//                           //   ),
//                           // ),
//                           InkWell(
//                             onTap: () {
//                               Navigator.pushNamed(context, RoutePaths.Sound);
//                             },
//                             child: Container(
//                               height: getHeightPx(130),
//                               width: getWidthPx(650),
//                               margin: EdgeInsets.only(
//                                 top: getWidthPx(50),
//                                 left: getWidthPx(50),
//                                 right: getWidthPx(50),
//                               ),
//                               decoration: BoxDecoration(
//                                   image: new DecorationImage(
//                                       image: new AssetImage(
//                                           "lib/assets/images/sounding.png"),
//                                       fit: BoxFit.fill)),
//                               child: Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceAround,
//                                 children: <Widget>[
//                                   Container(
//                                     height: getHeightPx(60),
//                                     width: getWidthPx(80),
//                                     margin:
//                                         EdgeInsets.only(left: getWidthPx(40)),
//                                     decoration: BoxDecoration(
//                                         image: new DecorationImage(
//                                             image: new AssetImage(
//                                                 "lib/assets/images/sound.png"),
//                                             fit: BoxFit.contain)),
//                                   ),
//                                   Spacer(),
//                                   Text(
//                                     "录音上传",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 16),
//                                   ),
//                                   SizedBox(
//                                     width: getWidthPx(40),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
