import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/service_api/judicial_network.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/log_utils.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';

import '../../../config.dart';
import '../../../utils/common_tools.dart';

class NotaryExtractViewModel extends SingleViewStateModel {
  String unitGuid;

  String unionnotaritionid;

  String token;

  String notaryName;

  NotaryExtractViewModel({this.unitGuid, this.unionnotaritionid, this.token,this.notaryName});

  // 录屏的文件路径
  String filePath = '';

  List notaryList = [];

  bool isEnable = false;

  Timer timer;

  Timer timer1;

  Timer timer2;

  int timerTotal = 300;

  String tranTimer = "0500";

  String btnString = "开始抽取";

  int selectIndex;

  int randomIndex = 0;

  ScrollController controller = ScrollController();

  PageController pageController = PageController(initialPage: 0);

  final FixedExtentScrollController fixedExtentScrollController =
      FixedExtentScrollController();

  // 录屏文件fileID
  String screenFileId = '';

  // 当前抽取的公正处
  String selectNotary = "";

  // 选中的鉴定机构
  String selectNotaryId = '';

  int next = 0;

  bool isUpload = false;

  CancelToken cancelToken = CancelToken();
  // ScreenRecorder? screenRecorder = ScreenRecorder();;

  String formatTime(int seconds) {
    int minutes = (seconds ~/ 60);
    int remainingSeconds = seconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0'); // 保证两位数
    String secondsStr = remainingSeconds.toString().padLeft(2, '0'); // 保证两位数

    return '$minutesStr$secondsStr';
  }

  // 开始抽取
  void beginExtract() {
    btnString = '正在抽取...';
    pageController.jumpToPage(2);
    Future.delayed(const Duration(milliseconds: 300), () {
      timer1 = Timer.periodic(const Duration(microseconds: 1), (timer) {
        int index = Random().nextInt(notaryList.length + 1);
        fixedExtentScrollController.jumpToItem(index);
        // print("index-------$index");
      });
      appraiseInstitution();
    });
  }

  // 动画计时器及倒计时计时器启动
  void initAnimationTimer() {
    timer?.cancel();
    timer1?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerTotal == 0) {
        timer?.cancel();
        timer1?.cancel();
        timer2?.cancel();
        if (!isUpload) {
          FlutterScreenRecording.stopRecordScreen.then((value) {
            G.getCurrentState().pushNamedAndRemoveUntil(
                RoutePaths.judicialExpertiseList, (route) => false);
          });
        }
      } else {
        timerTotal--;
        tranTimer = formatTime(timerTotal);
        notifyListeners();
      }
    });
  }

  void resetSuccessFilterStatus() async {
    int tempCount = 3;
    timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (tempCount != 0) {
        btnString = '结束($tempCount)S';
        tempCount--;
      } else {
        isEnable = true;
        btnString = '结束';
        timer2?.cancel();
      }
      notifyListeners();
    });
  }

  //  结束摇号
  void endLottery() {
    if (btnString == '结束') {
      timer1?.cancel();
      selectIndex = notaryList.indexOf(selectNotary);
      print("--------------------$selectIndex");
      fixedExtentScrollController.jumpToItem(selectIndex);
      // btnString = "下一步";
      // next = 0;
      isEnable = false;
      updateOrderState(status: "4", lotteryStatus: 2);
      notifyListeners();
    } else if (btnString.contains("下一步")) {
      // next = 0;
      comeIntoNotaryList();
      timer2?.cancel();
    }
  }

  @override
  Future loadData() {
    getAppraiseInstitutionList();
    initAnimationTimer();
  }

  @override
  onCompleted(data) {
    throw UnimplementedError();
  }

  // 查询鉴定机构
  void getAppraiseInstitutionList() {
    Map data = {
      'enabledmark': 1,
      'deletemark': 0,
      'orderId': unitGuid,
    };
    HomeApi.getSingleton().selectAllInstitution(data, errorCallBack: (error) {
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      FlutterScreenRecording.stopRecordScreen.then((value) {
        filePath = value;
        G.getCurrentState().pushNamedAndRemoveUntil(
            RoutePaths.judicialExpertiseList, (route) => false);
      });
    }).then((value) {
      print("value------$value");
      // NotaryExtractModel model = NotaryExtractModel.fromJson(value);
      if (value != null) {
        if (value['code'] == 200 &&
            value['data'] != null &&
            value['data'].isNotEmpty) {
          notaryList.clear();
          notaryList.addAll(value['data']);
          isEnable = true;
        } else {
          FlutterScreenRecording.stopRecordScreen.then((value) {
            filePath = value;
            G.getCurrentState().pushNamedAndRemoveUntil(
                RoutePaths.judicialExpertiseList, (route) => false);
          });
          ToastUtil.showErrorToast(
              value['msg'] ?? value['message'] ?? value['data']);
        }
      } else {
        FlutterScreenRecording.stopRecordScreen.then((value) {
          filePath = value;
          G.getCurrentState().pushNamedAndRemoveUntil(
              RoutePaths.judicialExpertiseList, (route) => false);
        });
        ToastUtil.showErrorToast("网络出错了，请稍后在试！");
      }
      notifyListeners();
    });
  }

  // 更新订单状态
  void updateOrderState({String status, int lotteryStatus}) {
    isUpload = true;
    Map data = {
      'status': status,
      'unitGuid': unitGuid,
      'lotteryStatus': lotteryStatus,
      'appraisalNotaritionId': selectNotaryId,
      'appraisalNotaritionName': selectNotary,
    };
    HomeApi.getSingleton().updateOrder(data, cancelToken: cancelToken,
        errorCallBack: (error) {
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      EasyLoading.dismiss();
      isUpload = false;
      FlutterScreenRecording.stopRecordScreen.then((value) {
        filePath = value;
        G.getCurrentState().pushNamedAndRemoveUntil(
            RoutePaths.judicialExpertiseList, (route) => false);
      });
    }).then((value) async {
      if (value != null) {
        if (value['code'] == 200) {
          Future.delayed(const Duration(seconds: 2), () {
            stopRecord();
          });
        } else {
          isUpload = false;
          EasyLoading.dismiss();
          ToastUtil.showErrorToast(
              value['message'] ?? value['msg'] ?? value['data']);
          FlutterScreenRecording.stopRecordScreen.then((value) {
            filePath = value;
            G.getCurrentState().pushNamedAndRemoveUntil(
                RoutePaths.judicialExpertiseList, (route) => false);
          });
        }
      } else {
        isUpload = false;
        EasyLoading.dismiss();
        ToastUtil.showErrorToast("网络出错了，请稍后再试！");
        FlutterScreenRecording.stopRecordScreen.then((value) {
          filePath = value;
          G.getCurrentState().pushNamedAndRemoveUntil(
              RoutePaths.judicialExpertiseList, (route) => false);
        });
      }
    });
  }

  Future<bool> isolateDelay(int count) async {
    bool isValue = await Future.delayed(const Duration(seconds: 2));
    return isValue;
  }

  // 更新订单状态
  void updateOrderStateWithFile() {
    Map data = {
      'unitGuid': unitGuid,
    };
    data['screenFileId'] = screenFileId;
    HomeApi.getSingleton().updateOrder(data, cancelToken: cancelToken,
        errorCallBack: (error) {
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      EasyLoading.dismiss();
      isUpload = false;
      G.getCurrentState().pushNamedAndRemoveUntil(
          RoutePaths.judicialExpertiseList, (route) => false);
    }).then((value) {
      if (value != null) {
        if (value['code'] == 200) {
          EasyLoading.dismiss();
          int tempCount = 3;
          timer2?.cancel();
          timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
            if (tempCount != 0) {
              btnString = '下一步($tempCount)';
              tempCount--;
              isEnable = true;
            } else {
              isEnable = true;
              btnString = '下一步';
              Future.delayed(const Duration(milliseconds: 200), () {
                comeIntoNotaryList();
              });
              timer2?.cancel();
            }
            notifyListeners();
          });
        } else {
          isUpload = false;
          EasyLoading.dismiss();
          ToastUtil.showErrorToast(
              value['message'] ?? value['msg'] ?? value['data']);
          G.getCurrentState().pushNamedAndRemoveUntil(
              RoutePaths.judicialExpertiseList, (route) => false);
        }
      } else {
        isUpload = false;
        EasyLoading.dismiss();
        ToastUtil.showErrorToast("网络出错了，请稍后再试！");
        FlutterScreenRecording.stopRecordScreen.then((value) {
          filePath = value;
          G.getCurrentState().pushNamedAndRemoveUntil(
              RoutePaths.judicialExpertiseList, (route) => false);
        });
      }
    });
  }

  // 进入机构列表页
  void comeIntoNotaryList() {
    G.getCurrentState().pushNamedAndRemoveUntil(
        RoutePaths.notaryOfficeListWidget, (route) => false,
        arguments: {
          'selectNotary': selectNotary,
          'notary': notaryList,
          'unitGuid': unitGuid,
          'selectNotaryId': selectNotaryId,
          "notaryName":notaryName,
        });
  }

  // 抽取鉴定机构
  void appraiseInstitution({Function errorResult, Function successResult}) {
    isEnable = false;
    notifyListeners();
    // 该段代码只是为了让动画多执行一会
    Future.delayed(const Duration(seconds: 3), () {
      Map data = {
        'orderId': unitGuid,
        'unionnotaritionid': unionnotaritionid,
        'enabledmark': 1,
        'deletemark': 0
      };
      HomeApi.getSingleton().appraiseInstitution(data, errorCallBack: (error) {
        ToastUtil.showErrorToast("网络出错了，请稍后再试！");
        isEnable = true;
        notifyListeners();
        FlutterScreenRecording.stopRecordScreen.then((value) {
          filePath = value;
          G.getCurrentState().pushNamedAndRemoveUntil(
              RoutePaths.judicialExpertiseList, (route) => false);
        });
      }).then((value) {
        print("value------$value");
        if (value != null) {
          if (value['code'] == 200) {
            for (var element in notaryList) {
              if (element == value['data']['institutionname']) {
                selectNotary = element;
                selectNotaryId = value['data']['unitguid'];
              }
            }
            resetSuccessFilterStatus();
          } else {
            isEnable = true;
            notifyListeners();
            FlutterScreenRecording.stopRecordScreen.then((value) {
              filePath = value;
              G.getCurrentState().pushNamedAndRemoveUntil(
                  RoutePaths.judicialExpertiseList, (route) => false);
            });
            ToastUtil.showErrorToast(value['message'] ?? '');
          }
        } else {
          isEnable = true;
          notifyListeners();
          FlutterScreenRecording.stopRecordScreen.then((value) {
            filePath = value;
            G.getCurrentState().pushNamedAndRemoveUntil(
                RoutePaths.judicialExpertiseList, (route) => false);
          });
          ToastUtil.showErrorToast("网络出错了，请稍后在试！");
        }
      });
    });
  }

  // 结束录屏
  void stopRecord() async {
    if (filePath.isEmpty) {
      try {
        FlutterScreenRecording.stopRecordScreen.then((tempPath) {
          filePath = tempPath;
          if (tempPath.isNotEmpty) {
            File tempFile = File(tempPath);
            print(
                "tempFile------${tempFile.lengthSync()}------filePath------$filePath");
            LogUtils.writeDataToFilePath("录制结束时返回的文件录像相关信息：fileLength${tempFile.lengthSync()},filePath:$filePath");
            getUploadId(tempPath);
          } else {
            LogUtils.writeDataToFilePath("录制结束时文件路径为空时报错filePath:$filePath");
            ToastUtil.showToast("录制文件存储失败");
            G.getCurrentState().pushNamedAndRemoveUntil(
                RoutePaths.judicialExpertiseList, (route) => false);
          }
        });
      } catch (e) {
        LogUtils.writeDataToFilePath("录制结束时try catch报错:$e");
        ToastUtil.showToast("结束录屏时发生错误");
        G.getCurrentState().pushNamedAndRemoveUntil(
            RoutePaths.judicialExpertiseList, (route) => false);
        ExceptionTrace.captureException(exception: Exception(e),extra: {"tag":"摇号结束界面录屏提交时报错","error":e.toString()});
      }
    }
    // }else{
    //   callBack?.call();
    // }
  }

  getPaging(path, uploadId, fileName) async {
    // 读文件
    var s = await File(path).open();
    int x = 0;
    int size = File(path).lengthSync();
    int chunkSize = 5242880;
    List<int> val;
    int num = size % chunkSize > 0 ? 1 : 0;
    int num1 = size ~/ chunkSize + num;
    int num2 = 1;
    Map info;
    bool isTrue = true;
    while (x < size) {
      int _len = size - x >= chunkSize ? chunkSize : size - x;
      bool lastChunk = size - x >= chunkSize ? false : true;
      val = s.readSync(_len).toList();
      x = x + _len;
      print(
          "2: ${val.runtimeType}-----$num1------$num2----$lastChunk,----$_len");
      MultipartFile multipartFile = MultipartFile.fromBytes(
        val,
        filename: "$num2$fileName",
      );
      String sm4PublicKey = getPublicKey();
      Map<String ,dynamic> entryMap = {
        "uploadId": uploadId,
        "fileName": "$fileName",
        "fileSort": num2,
        "fileSortCounts": num1,
        "lastChunk": lastChunk
      };
      Map<String, dynamic> tempMap = {
        "multipartFile": multipartFile,
        "encryptStr": wjEncrypt(entryMap,sm4PublicKey),
      };
      FormData formData = FormData.fromMap(tempMap);
      Options options = Options(contentType: "multipart/form-data");
      options.headers["encrypt"] = encryptSM4Key(sm4PublicKey);
      final response = await JudicialNetwork.instance.post(
          "${Config.annexModule}/sys/annex/uploadPart",
          data: formData,
          options: options,
          cancelToken: cancelToken,
          errorCallBack: (e){
            ToastUtil.showNormalToast("上传出错了");
            isUpload = false;
            G.getCurrentState().pushNamedAndRemoveUntil(
                RoutePaths.judicialExpertiseList, (route) => false);
          });
      info = response.data;
      if (info['code'] != 200) {
        isTrue = false;
      }
      num2++;
    }
    await s.close();
    print("4: $info");
    if (isTrue) {
      // uploadPath = info["data"];
      createOrder(size, info["data"], fileName);
    } else {
      isUpload = false;
      EasyLoading.dismiss();
      ToastUtil.showNormalToast("出错了，请重新上传！");
      G.getCurrentState().pushNamedAndRemoveUntil(
          RoutePaths.judicialExpertiseList, (route) => false);
    }
  }
  //
  // Future uploadPart(map, {Function errorCallBack}) async {
  //   Options options = Options(contentType: "multipart/form-data");
  //   final response = await JudicialNetwork.instance.post(
  //       "${Config.annexModule}/sys/annex/uploadPart",
  //       data: map,
  //       options: options,
  //       cancelToken: cancelToken,
  //       errorCallBack: errorCallBack);
  //   return response.data;
  // }

  // 获取uploadId
  void getUploadId(String filePath) async {
    EasyLoading.show(status: "正在处理视频文件中");
    String name = filePath.substring(
        filePath.lastIndexOf("/") + 1, filePath.toString().length);
    Map<String, dynamic> data = {"fileName": name};
    EasyLoading.show(status: "录屏文件正在上传中");
    uploadPageId(data, errorCallBack: (error) {
      EasyLoading.dismiss();
      isUpload = false;
      ToastUtil.showNormalToast("文件上传出错了，请重新再试！");
      G.getCurrentState().pushNamedAndRemoveUntil(
          RoutePaths.judicialExpertiseList, (route) => false);
    }).then((value) {
      print("-----------$value");
      if (value != null && value['code'] == 200) {
        getPaging(filePath, value['data'], name);
      } else {
        isUpload = false;
        EasyLoading.dismiss();
        ToastUtil.showNormalToast("文件上传出错了，请重新再试！");
        G.getCurrentState().pushNamedAndRemoveUntil(
            RoutePaths.judicialExpertiseList, (route) => false);
      }
    });
  }

  Future uploadPageId(Map<String, dynamic> data,
      {Function errorCallBack, Options options}) async {
    final response = await JudicialNetwork.instance.get(
        "${Config.annexModule}/sys/annex/initiateMultipartUpload",
        queryParameters: data,
        options: options,
        cancelToken: cancelToken,
        errorCallBack: errorCallBack);
    return response.data;
  }

  // 插入数据
  void createOrder(int size, String urlString, String fileName) async {
    EasyLoading.show();
    // if (!cancelRequest.isPaused) {
    Map data = {
      'fileSize': size,
      'filePath': urlString,
      'fileType': 'mp4',
      // 'md5': md5Str,
      'fileName': fileName,
      'unitGuid': unitGuid,
    };
    HomeApi.getSingleton().fileInsert(data, cancelToken: cancelToken,
        errorCallBack: (error) {
      EasyLoading.dismiss();
      isUpload = false;
      ToastUtil.showErrorToast("订单提交失败，请稍后再试！");
      G.getCurrentState().pushNamedAndRemoveUntil(
          RoutePaths.judicialExpertiseList, (route) => false);
    }).then((value) {
      if (value != null) {
        if (value['code'] == 200) {
          screenFileId = value['data']['unitGuid'];
          updateOrderStateWithFile();
        } else {
          isUpload = false;
          EasyLoading.dismiss();
          ToastUtil.showErrorToast(
              value['message'] ?? value['msg'] ?? value['data']);
          G.getCurrentState().pushNamedAndRemoveUntil(
              RoutePaths.judicialExpertiseList, (route) => false);
        }
      } else {
        isUpload = false;
        EasyLoading.dismiss();
        ToastUtil.showErrorToast("订单提交失败，请稍后再试！");
        G.getCurrentState().pushNamedAndRemoveUntil(
            RoutePaths.judicialExpertiseList, (route) => false);
      }
    });

    // }
  }
}
