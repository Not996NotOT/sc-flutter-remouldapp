import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/view_model/view_state.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/throttleUtil.dart';
import 'package:notarization_station_app/model/OrderReenterStatusInfoModel.dart';
import 'package:notarization_station_app/model/OrderReenterStatusModel.dart';
import 'package:notarization_station_app/page/home/vm/VideoUnfinishedViewModel.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class VideoUnfinishedPage extends StatefulWidget {
  final String comeFrom;
  const VideoUnfinishedPage({Key key,this.comeFrom}):super(key: key);

  @override
  State<VideoUnfinishedPage> createState() => _VideoUnfinishedPageState();
}

class _VideoUnfinishedPageState extends BaseState<VideoUnfinishedPage> {

  VideoUnfinishedViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "视频公证"),
      body: Consumer<UserViewModel>(
        builder: (ctx,userModel,child){
          return ProviderWidget<VideoUnfinishedViewModel>(
            onModelReady: (model) {
              viewModel = model;
              viewModel.getData();
            },
              builder: (ctx,videoUnfinishedViewModel,child){
              if (viewModel.state == ViewState.busy) {
                return const CupertinoActivityIndicator(radius: 20,);
              } else if (viewModel.state == ViewState.empty) {
                return SizedBox();
              } else {
                return mainWidget();
              }
          }, model: VideoUnfinishedViewModel(userModel));
        },
      ));
  }

  Widget mainWidget(){
    return Column(
      children: [
      Expanded(child: ListView.builder(
          itemCount: viewModel.orderStatusList.length,
          itemBuilder: (context,index){
            return itemWidget(viewModel.orderStatusList[index]);
          }),),
        GestureDetector(
          onTap: () {
            G
                .getCurrentState()
                .pushReplacementNamed(RoutePaths.VideoNotarize);
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
              '发起新的订单',
              style: TextStyle(
                fontSize: getSp(28),
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }


  /// item 的样式
 Widget itemWidget(OrderReenterStatusModel model){
    return Container(
      margin: EdgeInsets.only(left: getWidthPx(30),right: getWidthPx(30),top: getWidthPx(30)),
      padding: EdgeInsets.all(getWidthPx(20)),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(
          color: AppTheme.bg_e,
          blurRadius: 5,
          spreadRadius: 10,
        )],
      ),
      child: Column(
        children: [
          Padding(
            padding:  EdgeInsets.only(top: getWidthPx(20)),
            child: Row(
              children: [
                Text("申请编号",style: TextStyle(
                  fontWeight: FontWeight.w500
                ),),
                Expanded(child: Text(model.orderNo??'',textAlign: TextAlign.end,)),
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(vertical: getWidthPx(20)),
            child: Row(
              children: [
                Text("公证事项",style: TextStyle(
                    fontWeight: FontWeight.w500
                )),
                Expanded(child: Text(model.notarizationTypes??'',textAlign: TextAlign.end,overflow: TextOverflow.ellipsis,maxLines: 1,))
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(bottom: getWidthPx(20)),
            child: Row(
              children: [
                Text("公证员",style: TextStyle(
                    fontWeight: FontWeight.w500
                )),
                Expanded(child: Text(model.greffierName??'',textAlign: TextAlign.end,))
              ],
            ),
          ),
          Padding(
            padding:  EdgeInsets.only(bottom: getWidthPx(20)),
            child: Row(
              children: [
                Text("创建时间",style: TextStyle(
                    fontWeight: FontWeight.w500
                )),
                Expanded(child: Text(model.createDate??'',textAlign: TextAlign.end,))
              ],
            ),
          ),
          Divider(),
          Row(
            children: [
              Spacer(),
              InkWell(
                onTap: ThrottleUtil().throttle(() async {
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
                    viewModel.reEnterVideoRoom(model);
                  } else {
                    G.showPermissionDialog(str: "访问内部存储、语音麦克风、相机、相册权限");
                  }
                }),
                child: Container(
                  decoration: BoxDecoration(
                      color: AppTheme.themeBlue,
                      borderRadius: BorderRadius.circular(getWidthPx(10))
                  ),
                  padding: EdgeInsets.symmetric(horizontal: getWidthPx(40),vertical: getWidthPx(15)),
                  child: Text('开始公证',textAlign: TextAlign.center,style: TextStyle(
                      color: AppTheme.white
                  ),),
                ),
              )
            ],
          )
        ],
      ),
    );
 }
}
