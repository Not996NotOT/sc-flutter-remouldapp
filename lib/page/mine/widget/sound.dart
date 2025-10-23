// import 'dart:async';
// import 'dart:io';
// import 'package:amap_location_fluttify/amap_location_fluttify.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_h5pay/flutter_h5pay.dart';
// import 'package:flutter_sound/flutter_sound.dart';
// import 'package:notarization_station_app/appTheme.dart';
// import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
// import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
// import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
// import 'package:notarization_station_app/iconfont/Icon.dart';
// import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
// import 'package:notarization_station_app/service_api/home_api.dart';
// import 'package:notarization_station_app/utils/global.dart';
// import 'package:notarization_station_app/utils/throttle_anti-shake.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart' show DateFormat;
// import 'package:intl/date_symbol_data_local.dart';
// import 'package:provider/provider.dart';
// import 'package:tobias/tobias.dart';
// import 'package:http_parser/http_parser.dart';
//
// enum RecordPlayState { record, recording, play, playing, pause }
//
// class RecordPage extends StatefulWidget {
//   RecordPage({Key key}) : super(key: key);
//
//   @override
//   _RecordPageState createState() => _RecordPageState();
// }
//
// class _RecordPageState extends BaseState<RecordPage>
//     with WidgetsBindingObserver {
//   RecordPlayState _state = RecordPlayState.record;
//
//   StreamSubscription _recorderSubscription;
//   StreamSubscription _playerSubscription;
//
//   // StreamSubscription _dbPeakSubscription;
//   FlutterSoundRecorder flutterSound;
//   String _recorderTxt = '00:00:00';
//   // String _playerTxt = '00:00:00';
//
//   double _dbLevel = 0.0;
//   FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
//   FlutterSoundPlayer playerModule = FlutterSoundPlayer();
//
//   var _path = "";
//   var _duration = 0.0;
//   int _maxLength = 59;
//
//   Timer timerPay;
//   int numPay = 1;
//   String orderNum;
//   int numTime = 0;
//   UserViewModel userModel;
//
//   // 是否进行支付宝跳转
//   bool isAliPayJump = false;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     init();
//   }
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
//       case AppLifecycleState.paused:
//         _stopRecorder();
//         break;
//     }
//   }
//
//   Future<void> _initializeExample(bool withUI) async {
//     await playerModule.closeAudioSession();
//     await playerModule.openAudioSession(
//         focus: AudioFocus.requestFocusTransient,
//         category: SessionCategory.playAndRecord,
//         mode: SessionMode.modeDefault,
//         device: AudioDevice.speaker);
//     await playerModule.setSubscriptionDuration(Duration(milliseconds: 30));
//     await recorderModule.setSubscriptionDuration(Duration(milliseconds: 30));
//     initializeDateFormatting();
//   }
//
//   Future<void> init() async {
//     recorderModule.openAudioSession(
//         focus: AudioFocus.requestFocusTransient,
//         category: SessionCategory.playAndRecord,
//         mode: SessionMode.modeDefault,
//         device: AudioDevice.speaker);
//     await _initializeExample(false);
//     if (Platform.isAndroid) {
//       // copyAssets();
//     }
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     WidgetsBinding.instance.removeObserver(this);
//     _cancelRecorderSubscriptions();
//     _cancelPlayerSubscriptions();
//     _releaseFlauto();
//     timerPay?.cancel();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//           child: Icon(
//             Icons.arrow_back_ios,
//             color: Colors.white,
//             size: 22,
//           ),
//           onTap: () {
//             if (_state == RecordPlayState.record) {
//               G.pop();
//             } else {
//               ADialog.confirm(context,
//                   content: "是否确认退出？（退出将不会保存）",
//                   cancelButtonText: Text("取消"),
//                   confirmButtonText: Text("确认"), cancelButtonPress: () {
//                 Navigator.of(context).pop();
//               }, confirmButtonPress: () {
//                 print("123456");
//                 Navigator.of(context).pop();
//                 Navigator.of(context).pop();
//               });
//             }
//           },
//         ),
//         backgroundColor: Color(0xFF0C141F),
//         centerTitle: true,
//         title: Text(
//           "录音上传",
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//       ),
//       backgroundColor: Color(0xFF0C141F),
//       body: WillPopScope(
//         onWillPop: () {
//           if (_state == RecordPlayState.record) {
//             G.pop();
//           } else {
//             ADialog.confirm(context,
//                 content: "是否确认退出？（退出将不会保存）",
//                 cancelButtonText: Text("取消"),
//                 confirmButtonText: Text("确认"), cancelButtonPress: () {
//               Navigator.of(context).pop();
//             }, confirmButtonPress: () {
//               print("123456");
//               Navigator.of(context).pop();
//               Navigator.of(context).pop();
//             });
//           }
//           return Future.value(false);
//         },
//         child: Consumer<UserViewModel>(
//           builder: (ctx, userModel, child) {
//             this.userModel = userModel;
//             return Stack(
//               fit: StackFit.expand,
//               children: [
//                 Positioned(
//                   top: 0,
//                   left: 0,
//                   right: 0,
//                   child: Column(
//                     children: [
//                       Container(
//                           width: double.maxFinite,
//                           height: 200,
//                           alignment: Alignment.center,
//                           child: Text(_recorderTxt,
//                               style: TextStyle(
//                                   fontSize: 36, color: Colors.white))),
//                       CustomPaint(
//                           size: Size(double.maxFinite, 100),
//                           painter: LCPainter(
//                               amplitude: _dbLevel / 2,
//                               number: 30 - _dbLevel ~/ 20)),
//                     ],
//                   ),
//                 ),
//                 Positioned(
//                     left: 15,
//                     right: 15,
//                     bottom: MediaQuery.of(context).padding.bottom + 15,
//                     child: _actionShow())
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget _actionShow() {
//     var _width = 300;
//     var _height = _width * 0.8;
//     return Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(8),
//           color: Color(0xFF1A283B),
//         ),
//         height: _height,
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
//           SizedBox(height: 15),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Offstage(
//                 offstage: _state == RecordPlayState.play ||
//                         _state == RecordPlayState.playing
//                     ? false
//                     : true,
//                 child: InkWell(
//                     onTap: () {
//                       setState(() async {
//                         _state = RecordPlayState.record;
//                         _path = "";
//                         _recorderTxt = "00:00:00";
//                         _dbLevel = 0.0;
//                         await _stopPlayer();
//                         _state = RecordPlayState.record;
//                       });
//                     },
//                     child: Container(
//                         width: _width / 4,
//                         margin: EdgeInsets.symmetric(horizontal: 12),
//                         alignment: Alignment.center,
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.stop_circle_outlined,
//                               color: Colors.white,
//                               size: 50,
//                             ),
//                             Text(
//                               "重新录制",
//                               style:
//                                   TextStyle(fontSize: 15, color: Colors.white),
//                             ),
//                           ],
//                         )))),
//             Offstage(
//                 offstage: _state == RecordPlayState.recording ||
//                         _state == RecordPlayState.pause
//                     ? false
//                     : true,
//                 child: InkWell(
//                     onTap: () {
//                       _stopRecorder();
//                     },
//                     child: Container(
//                       width: _width / 4,
//                       margin: EdgeInsets.symmetric(horizontal: 12),
//                       alignment: Alignment.center,
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.stop_circle_outlined,
//                             color: Colors.red,
//                             size: 50,
//                           ),
//                           Text(
//                             "结束录音",
//                             style: TextStyle(fontSize: 15, color: Colors.white),
//                           )
//                         ],
//                       ),
//                     ))),
//             InkWell(
//                 onTap: () {
//                   print("............$_state");
//                   if (_state == RecordPlayState.record) {
//                     _startRecorder();
//                   } else if (_state == RecordPlayState.recording ||
//                       _state == RecordPlayState.pause) {
//                     // _stopRecorder();
//                     _pauseRestartRecorder();
//                   } else if (_state == RecordPlayState.play) {
//                     _startPlayer();
//                   } else if (_state == RecordPlayState.playing) {
//                     _pauseResumePlayer();
//                   }
//                 },
//                 child: Container(
//                     width: _width / 4,
//                     margin: EdgeInsets.symmetric(horizontal: 12),
//                     alignment: Alignment.center,
//                     child: Column(
//                       children: [
//                         Icon(
//                           _state == RecordPlayState.record
//                               ? Icons.not_started_outlined
//                               : _state == RecordPlayState.recording
//                                   ? Icons.pause_circle_filled
//                                   : _state == RecordPlayState.play
//                                       ? Icons.not_started
//                                       : Icons.play_arrow,
//                           color: Colors.white,
//                           size: 50,
//                         ),
//                         Text(
//                           _state == RecordPlayState.record
//                               ? "开始录音"
//                               : _state == RecordPlayState.recording
//                                   ? "暂停录音"
//                                   : _state == RecordPlayState.pause
//                                       ? "继续录音"
//                                       : _state == RecordPlayState.play
//                                           ? "播放录音"
//                                           : "暂停播放",
//                           style: TextStyle(fontSize: 15, color: Colors.white),
//                         ),
//                       ],
//                     ))),
//             Offstage(
//                 offstage: _state == RecordPlayState.play ||
//                         _state == RecordPlayState.playing
//                     ? false
//                     : true,
//                 child: InkWell(
//                     onTap: () {
//                       showDialog(
//                         context: G.getCurrentState().overlay.context,
//                         barrierDismissible: false, //// user must tap button!
//                         builder: (BuildContext context) {
//                           return WillPopScope(
//                             onWillPop: () {
//                               return Future.value(true);
//                             },
//                             child: AlertDialog(
//                               backgroundColor: Colors.white,
//                               content: Text("你确定要上传此次录音吗？"),
//                               contentPadding:
//                                   EdgeInsets.only(left: 10, right: 10, top: 10),
//                               actions: <Widget>[
//                                 // ignore: deprecated_member_use
//                                 MaterialButton(
//                                   child: Text('取消'),
//                                   onPressed: () {
//                                     G.pop();
//                                   },
//                                 ),
//                                 // ignore: deprecated_member_use
//                                 MaterialButton(
//                                   child: Text('确认'),
//                                   onPressed: () {
//                                     G.pop();
//                                     goPay();
//                                   },
//                                 ),
//                               ],
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     child: Container(
//                         width: _width / 4,
//                         margin: EdgeInsets.symmetric(horizontal: 12),
//                         alignment: Alignment.center,
//                         child: Column(
//                           children: [
//                             Icon(
//                               Icons.check_circle_rounded,
//                               color: Colors.white,
//                               size: 50,
//                             ),
//                             Text(
//                               "完成录音",
//                               style:
//                                   TextStyle(fontSize: 15, color: Colors.white),
//                             ),
//                           ],
//                         )))),
//           ])
//         ]));
//   }
//
//   /// 开始录音
//   _startRecorder() async {
//     try {
//       PermissionStatus status = await Permission.microphone.request();
//       if (status != PermissionStatus.granted) {
//         EasyLoading.showToast("未获取到麦克风权限");
//         throw RecordingPermissionException("未获取到麦克风权限");
//       }
//       print('===>  获取了权限');
//       Directory tempDir = await getTemporaryDirectory();
//       var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       String path = '${tempDir.path}-$time.mp4';
//       print('===>  获取了地址$path---${tempDir.path}');
//       print('===>  准备开始录音');
//       await recorderModule.startRecorder(
//         toFile: path,
//         codec: Codec.aacMP4,
//         bitRate: 8000,
//         sampleRate: 8000,
//       );
//       print('===>  开始录音');
//
//       /// 监听录音
//       _recorderSubscription = recorderModule.onProgress.listen((e) {
//         if (e != null && e.duration != null) {
//           DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//               e.duration.inMilliseconds,
//               isUtc: true);
//           String txt = DateFormat('HH:mm:ss', 'en_GB').format(date);
//
//           // if (date.minute >= _maxLength) {
//           //   _stopRecorder();
//           // }
//           setState(() {
//             _recorderTxt = txt.substring(0, 8);
//             _dbLevel = e.decibels;
//           });
//         }
//       });
//       setState(() {
//         _state = RecordPlayState.recording;
//         _path = path;
//         print("path == $path");
//       });
//     } catch (err) {
//       print("......出错了$err");
//       setState(() {
//         _stopRecorder();
//         _state = RecordPlayState.record;
//         _cancelRecorderSubscriptions();
//       });
//     }
//   }
//
//   /// 结束录音
//   _stopRecorder() async {
//     try {
//       await recorderModule.stopRecorder();
//       print('stopRecorder');
//       _cancelRecorderSubscriptions();
//       _getDuration();
//     } catch (err) {
//       print('stopRecorder error: $err');
//     }
//     setState(() {
//       _dbLevel = 0.0;
//       _state = RecordPlayState.play;
//     });
//   }
//
//   /// 暂停/重新录音
//   _pauseRestartRecorder() async {
//     try {
//       print('------${playerModule.isPaused}');
//       if (recorderModule.isPaused) {
//         await recorderModule.resumeRecorder();
//         _state = RecordPlayState.recording;
//         print('重新开始录音');
//       } else {
//         await recorderModule.pauseRecorder();
//         _state = RecordPlayState.pause;
//         print('暂停录音');
//       }
//     } catch (err) {
//       print('暂停录音 error: $err');
//     }
//     setState(() {});
//   }
//
//   /// 取消录音监听
//   void _cancelRecorderSubscriptions() {
//     if (_recorderSubscription != null) {
//       _recorderSubscription.cancel();
//       _recorderSubscription = null;
//     }
//   }
//
//   /// 取消播放监听
//   void _cancelPlayerSubscriptions() {
//     if (_playerSubscription != null) {
//       _playerSubscription.cancel();
//       _playerSubscription = null;
//     }
//   }
//
//   /// 释放录音和播放
//   Future<void> _releaseFlauto() async {
//     try {
//       await playerModule.closeAudioSession();
//       await recorderModule.closeAudioSession();
//     } catch (e) {
//       print('Released unsuccessful');
//       print(e);
//     }
//   }
//
//   /// 获取录音文件秒数
//   Future<void> _getDuration() async {
//     Duration d = await flutterSoundHelper.duration(_path);
//     // _duration = d != null ? d.inMilliseconds / 1000.0 : 0.00;
//     // print("_duration==>${d.inMinutes}");
//     numTime = d?.inMinutes;
//     int minutes = d?.inMinutes;
//     int hours = d?.inHours;
//     var seconds = d.inSeconds % 60;
//     var millSecond = d.inMilliseconds % 1000 ~/ 10;
//     _recorderTxt = "";
//     if (hours > 9) {
//       _recorderTxt = _recorderTxt + "$hours";
//     } else {
//       _recorderTxt = _recorderTxt + "0$hours";
//     }
//     if (minutes > 9) {
//       _recorderTxt = _recorderTxt + ":$minutes";
//     } else {
//       _recorderTxt = _recorderTxt + ":0$minutes";
//     }
//
//     if (seconds > 9) {
//       _recorderTxt = _recorderTxt + ":$seconds";
//     } else {
//       _recorderTxt = _recorderTxt + ":0$seconds";
//     }
//     setState(() {});
//   }
//
//   /// 开始播放
//   Future<void> _startPlayer() async {
//     try {
//       if (await _fileExists(_path)) {
//         await playerModule.startPlayer(
//             fromURI: _path,
//             codec: Codec.aacADTS,
//             whenFinished: () {
//               print('==> 结束播放');
//               _stopPlayer();
//               setState(() {});
//             });
//       } else {
//         EasyLoading.showToast("未找到文件路径");
//         throw RecordingPermissionException("未找到文件路径");
//       }
//
//       _cancelPlayerSubscriptions();
//       _playerSubscription = playerModule.onProgress.listen((e) {
//         if (e != null) {
//           // print("${e.duration} -- ${e.position} -- ${e.duration.inMilliseconds} -- ${e.position.inMilliseconds}");
//           // DateTime date = new DateTime.fromMillisecondsSinceEpoch(
//           //     e.position.inMilliseconds,
//           //     isUtc: true);
//           // String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
//
//           // this.setState(() {
//
//           // this._playerTxt = txt.substring(0, 8);
//           // });
//         }
//       });
//       setState(() {
//         _state = RecordPlayState.playing;
//       });
//       print('===> 开始播放');
//     } catch (err) {
//       print('==> 错误: $err');
//     }
//     setState(() {});
//   }
//
//   /// 结束播放
//   Future<void> _stopPlayer() async {
//     try {
//       await playerModule.stopPlayer();
//       print('===> 结束播放');
//       _cancelPlayerSubscriptions();
//     } catch (err) {
//       print('==> 错误: $err');
//     }
//     setState(() {
//       _state = RecordPlayState.play;
//     });
//   }
//
//   /// 暂停/继续播放
//   void _pauseResumePlayer() {
//     if (playerModule.isPlaying) {
//       playerModule.pausePlayer();
//       _state = RecordPlayState.play;
//       print('===> 暂停播放');
//     } else {
//       playerModule.resumePlayer();
//       _state = RecordPlayState.playing;
//       print('===> 继续播放');
//     }
//     setState(() {});
//   }
//
//   /// 判断文件是否存在
//   Future<bool> _fileExists(String path) async {
//     return await File(path).exists();
//   }
//
//   ///支付
//   goPay() {
//     orderNum = DateTime.now().millisecondsSinceEpoch.toString();
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
//                   Map<String, Object> map = {
//                     "outTradeNo": orderNum,
//                     "subject": "自助存证",
//                     "fee": numTime < 2 ? 10 : (numTime + 1) * 5
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
//                                   await Future.delayed(
//                                       Duration(milliseconds: 1000));
//                                   Map<String, Object> map = {
//                                     "orderGuid": orderNum,
//                                     "totalPic":
//                                         numTime < 2 ? 1000 : (numTime + 1) * 500
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
//                                           EasyLoading.show();
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
//                                                 EasyLoading.dismiss();
//                                                 if (value['code'] == 200 &&
//                                                     value['item']
//                                                             ['tradeStatus'] ==
//                                                         "SUCCESS") {
//                                                   print(
//                                                       "微信支付与否-------------------------");
//                                                   uploadFile();
//                                                   t.cancel();
//                                                 }
//                                               });
//                                               if (numPay > 17) {
//                                                 EasyLoading.dismiss();
//                                                 t.cancel();
//                                               }
//                                             });
//                                           } else if (p ==
//                                               JumpPayResult.TIMEOUT) {
//                                             ToastUtil.showNormalToast("支付失败");
//                                           } else if (p == JumpPayResult.FAIL) {
//                                             ToastUtil.showNormalToast(
//                                                 "没有安装微信或者不允许本应用打开微信支付");
//                                           }
//                                           G.pop();
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
//   ///支付宝支付
//   _alipay(payInfo) async {
//     G.pop();
//     EasyLoading.show(status: "付款中...");
//     isAliPayJump = true;
//     var result = await aliPay(payInfo);
//     EasyLoading.dismiss();
//     if (result['resultStatus'] == "9000") {
//       // if(fromWhere == 1 || fromWhere == 2 || fromWhere == 3){
//       uploadFile();
//       // }
//     } else if (result['resultStatus'] == "6001") {
//       ToastUtil.showNormalToast("支付失败");
//     }
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
//         uploadFile();
//         // Future.delayed(Duration.zero).then((value) => G.pushNamed(RoutePaths.HomeIndex));
//       } else {
//         ToastUtil.showNormalToast("支付失败");
//       }
//     });
//     // if (numPay > 17) {
//     //   t.cancel();
//     //   numPay = 1;
//     // }
//     // });
//   }
//
//   uploadFile() async {
//     EasyLoading.show(status: "正在上传...");
//     String name =
//         _path.substring(_path.lastIndexOf("/") + 1, _path.toString().length);
//     print("上传服务器--------------------$_path---------------------------$name");
//     MultipartFile multipartFile = await MultipartFile.fromFile(
//       _path,
//       filename: name,
//       contentType: MediaType("audio", "mpeg"),
//     );
//     HomeApi.getSingleton().uploadPictures(multipartFile).then((data) async {
//       if (data["code"] == 200) {
//         final status = await Permission.location.request();
//         if (status == PermissionStatus.granted) {
//           Location location = await AmapLocation.instance.fetchLocation();
//           print("位置信息：-----$location");
//           var map = {
//             //"userId": userModel.unitGuid,
//             "userName": userModel.userName,
//             "soundRecording": data["item"]["filePath"],
//             "fee": numTime < 2 ? 10 : (numTime + 1) * 5,
//             "address": location.address,
//             "fileSize": data["item"]["fileSize"],
//             "obtainEvidenceDate": DateTime.now().toString().substring(0, 19),
//           };
//           print("++++++++++位置信息+++++++++++$map");
//           HomeApi.getSingleton().addAutoOrder(map).then((res) {
//             EasyLoading.dismiss();
//             if (res["code"] == 200) {
//               ToastUtil.showNormalToast("录音上传成功！");
//               setState(() async {
//                 _state = RecordPlayState.record;
//                 _path = "";
//                 _recorderTxt = "00:00:00";
//                 await _stopPlayer();
//                 _state = RecordPlayState.record;
//               });
//             } else {
//               ToastUtil.showErrorToast(res["msg"]);
//             }
//           });
//         } else {
//           ToastUtil.showErrorToast("请允许应用获得手机权限");
//         }
//       } else {
//         EasyLoading.dismiss();
//       }
//     });
//   }
// }
//
// class LCPainter extends CustomPainter {
//   final double amplitude;
//   final int number;
//   LCPainter({this.amplitude = 100.0, this.number = 20});
//   @override
//   void paint(Canvas canvas, Size size) {
//     var centerY = 0.0;
//     var width = G.getCurrentContext().size.width / number;
//
//     for (var a = 0; a < 4; a++) {
//       var path = Path();
//       path.moveTo(0.0, centerY);
//       var i = 0;
//       while (i < number) {
//         path.cubicTo(width * i, centerY, width * (i + 1),
//             centerY + amplitude - a * (30), width * (i + 2), centerY);
//         path.cubicTo(width * (i + 2), centerY, width * (i + 3),
//             centerY - amplitude + a * (30), width * (i + 4), centerY);
//         i = i + 4;
//       }
//       canvas.drawPath(
//           path,
//           Paint()
//             ..color = a == 0 ? Colors.blueAccent : Colors.blueGrey.withAlpha(50)
//             ..strokeWidth = a == 0 ? 3.0 : 2.0
//             ..maskFilter = MaskFilter.blur(
//               BlurStyle.solid,
//               5,
//             )
//             ..style = PaintingStyle.stroke);
//     }
//   }
//
//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
