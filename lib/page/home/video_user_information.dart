/// FileName video_user_information
///
/// @Author WeJeson
/// @Date 2023/2/7 09:41
///
/// @Description 视频公证申请人信息界面
///
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/generated/json/base/json_convert_content.dart';
import 'package:notarization_station_app/model/OrderReenterStatusInfoModel.dart';
import 'package:notarization_station_app/model/OrderReenterStatusModel.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/page/home/entity/video_entity.dart';
import 'package:notarization_station_app/socket/mqtt_client.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../appTheme.dart';

class VideoUserInformation extends StatefulWidget {
  const VideoUserInformation({Key key}) : super(key: key);

  @override
  State<VideoUserInformation> createState() => _VideoUserInformationState();
}

class _VideoUserInformationState extends BaseState<VideoUserInformation> {


  List<OrderReenterStatusModel> orderStatusList = [];

  UserViewModel userViewModel;

  VideoEntity orderInfo = JsonConvert.fromJsonAsT(<String,dynamic>{
    'code':'',
    'msg':'',
    "unitGuid":<String,dynamic>{}
  });


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void loadData(){
    EasyLoading.show();
    HomeApi.getSingleton().reenterVideoOrdersList({},errorCallBack: (error){
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      EasyLoading.dismiss();
    }).then((value){
      EasyLoading.dismiss();
      orderStatusList.clear();
      if(value != null) {
        if(value['code'] == 200) {
          if (value['data'] != null && value['data'].isNotEmpty ){
            value['data'].forEach((e){
              OrderReenterStatusModel model = new OrderReenterStatusModel.fromJson(e);
              orderStatusList.add(model);
            });
          }
          if(orderStatusList.isEmpty) {
            G
                .getCurrentState()
                .pushReplacementNamed(RoutePaths.VideoNotarize);
          } else {
            if(orderStatusList.length == 1){
              enterVideoRoomAlert(orderStatusList[0]);
            } else {
              G.getCurrentState().pushNamed(RoutePaths.videoUnfinished,arguments: {
                "comeFrom":'video'
              });
            }
          }

        } else {
          ToastUtil.showErrorToast(value['msg']??value['message']??'网络出错了，请稍后再试！');
        }
      } else {
        G
            .getCurrentState()
            .pushReplacementNamed(RoutePaths.VideoNotarize);
      }
    });

  }

  /// 重新进入房间
  void reEnterVideoRoom(OrderReenterStatusModel model){
    EasyLoading.show(status: '正在加入...');
    HomeApi.getSingleton().videoReenter(model.unitGuid,errorCallBack: (error){
      ToastUtil.showErrorToast('网络出错了，请稍后再试！');
      EasyLoading.dismiss();
    }).then((value){
      EasyLoading.dismiss();
      if(value!= null) {
        if(value['code'] == 200) {
          if(value['data'] != null) {
            MqttClientMsg.instance
                .subscribe("/topic/shiping/${userViewModel.idCard}");
            OrderReenterStatusInfoModel modelInfo = OrderReenterStatusInfoModel.fromJson(value['data']);
            orderInfo.unitGuid.createDate = modelInfo.applyDate;
            orderInfo.unitGuid.unitGuid = modelInfo.unitGuid;
            orderInfo.unitGuid.orderNo = modelInfo.orderNo;
            orderInfo.unitGuid.currentState = modelInfo.linkStatus;
            G
                .getCurrentState()
                .pushReplacementNamed(RoutePaths.VideoIng, arguments: {
              "roomId": "qtzh-${model.unitGuid}",
              "orderInfo": orderInfo,
              "greffierName": modelInfo.greffierName
            });
          }
        } else {
          ToastUtil.showErrorToast(value['msg']??value['message']??'网络出错了，请稍后再试！');
        }
      } else {
        ToastUtil.showErrorToast('网络出错了，请稍后再试！');
      }
    });
  }

  void enterVideoRoomAlert(OrderReenterStatusModel model){
    showDialog(
        context: G.getCurrentState().overlay.context,
        builder: (context) {
          return Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.all(Radius.circular(10))
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top:30),
                    child: Text("提示",style: TextStyle(fontSize: 17,color: AppTheme.textBlack,fontWeight: FontWeight.bold)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                    child: Text("你有个视频公证正在等待你的加入，请操作",style: TextStyle(color: AppTheme.deactivatedText,fontSize: 16,height: 1.5),textAlign: TextAlign.center),
                  ),
                 Container(height: 1,color: AppTheme.bg_b,),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextButton(
                            child: Text("新增",style: TextStyle(color: AppTheme.textBlack)),
                            onPressed: (){
                              Navigator.of(context).pop();
                              G
                                  .getCurrentState()
                                  .pushReplacementNamed(RoutePaths.VideoNotarize);
                            },
                          ),
                        ),
                        VerticalDivider(indent: 0,endIndent: 0,thickness:1.0,),
                        Expanded(
                          child: TextButton(
                              child: Text("加入",style: TextStyle(color: AppTheme.themeBlue)),
                            onPressed: ThrottleUtil().throttle(() async {
                              if(!await Permission.camera.status.isGranted || !await Permission.speech.status.isGranted || !await Permission.storage.status.isGranted){
                                G.showCustomToast(
                                    context: context,
                                    titleText: "相机、麦克风、存储权限说明：",
                                    subTitleText: "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                                    time: 2
                                );
                              }
                              if (await Permission.camera.request().isGranted &&
                                  await Permission.speech.request().isGranted &&
                                  await Permission.storage.request().isGranted) {
                                Navigator.of(context).pop();
                                reEnterVideoRoom(model);
                              } else {
                                G.showPermissionDialog(str: "访问内部存储、语音麦克风、相机、相册权限");
                              }
                            }),
                          ),
                        ),
                      ]
                    ),
                  )
                ]
              )
            ),
          );
          }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: '视频公证'),
      body: Consumer<UserViewModel>(builder: (context, usermodel, child) {
        userViewModel = usermodel;
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: getWidthPx(20)),
                child: Text(
                  '申请人信息',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xff5496e0)),
                ),
              ),
              SizedBox(
                height: getHeightPx(20),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      height: getHeightPx(100),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('本人名字',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                          ),
                          Text(
                            usermodel.userName == null ||
                                    usermodel.userName == ""
                                ? "当事人"
                                : usermodel.userName,
                            style: TextStyle(
                                fontSize: 16, color: AppTheme.Text_min),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: getHeightPx(100),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('身份证号',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                          ),
                          Text(
                            usermodel.idCard,
                            style: TextStyle(
                                fontSize: 16, color: AppTheme.Text_min),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: getHeightPx(100),
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text('手机号码',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black87)),
                          ),
                          Text(
                            usermodel.mobile,
                            style: TextStyle(
                                fontSize: 16, color: AppTheme.Text_min),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  loadData();
                },
                child: Container(
                  height: getWidthPx(80),
                  margin: EdgeInsets.only(
                      left: getWidthPx(40),
                      right: getWidthPx(40),
                      bottom: MediaQuery.of(context).padding.bottom +
                          getHeightPx(20)),
                  alignment: Alignment.center,
                  decoration: ShapeDecoration(
                      shape: StadiumBorder(), color: AppTheme.themeBlue),
                  child: Text(
                    '下一步',
                    style: TextStyle(
                      fontSize: getSp(28),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
