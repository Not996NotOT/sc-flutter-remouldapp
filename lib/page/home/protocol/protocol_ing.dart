import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/page/home/vm/protocol_ing_vm.dart';
import 'package:notarization_station_app/page/login/entity/user_info_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

class ProtocolIngPage extends StatefulWidget {
  final arguments;

  ProtocolIngPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return ProtocolIngPageState();
  }
}

class ProtocolIngPageState extends BaseState<ProtocolIngPage> {
  ProtocolIngViewModel videoVm;
  UserInfoEntity userInfo;

  @override
  void initState() {
    super.initState();
    // Wakelock.enable();
  }

  @override
  void dispose() {
    super.dispose();
    videoVm.closeRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          ADialog.confirm(context,
              content: "是否确认退出视频公证？",
              cancelButtonText: Text("取消"),
              confirmButtonText: Text("确认"), cancelButtonPress: () {
            Navigator.of(context).pop();
          }, confirmButtonPress: () {
            videoVm.closeSocket();
            videoVm.destoryRoom();
            G.pop();
            G
                .getCurrentState()
                .popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
          });
          return Future.value(false);
        },
        child: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<ProtocolIngViewModel>(
                model: ProtocolIngViewModel(userModel,
                    widget.arguments['roomId'], widget.arguments['unitGuid']),
                onModelReady: (model) async {
                  videoVm = model;
                  model.videoHeight = getHeightPx(1334) - getWidthPx(375);
                  model.initData();
                },
                builder: (ctx, vm, child) {
                  return SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        _renderWidget(),
                        Container(
                          width: getWidthPx(750),
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.bg_b,
                          ),
                          child: const Text(
                            "经办人的信息",
                            style: TextStyle(
                                color: AppTheme.themeBlue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        MediaQuery.removePadding(
                          removeTop: true,
                          removeBottom: true,
                          context: context,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: vm.protocolInfoList.length,
                              itemBuilder: (ctx, a) {
                                var item = vm.protocolInfoList[a];
                                return Column(
                                  children: [
                                    Container(
                                      width: getWidthPx(750),
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.all(getWidthPx(20)),
                                      decoration: BoxDecoration(
                                        border: const Border(
                                            bottom: BorderSide(
                                                width: 1,
                                                color: AppTheme.bg_c)),
                                      ),
                                      child: Text(
                                          ' ${item['contractParty'].join('和')}签约主体信息'),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: item['signUserList'].length,
                                        itemBuilder: (ctx, index) {
                                          var e = item['signUserList'][index];
                                          return Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.all(
                                                    getWidthPx(20)),
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color:
                                                              AppTheme.bg_c)),
                                                ),
                                                child: Row(
                                                  children: <Widget>[
                                                    Container(
                                                      width: getWidthPx(10),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppTheme.themeBlue,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        10),
                                                                bottom: Radius
                                                                    .circular(
                                                                        10)),
                                                      ),
                                                      height: getHeightPx(30),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 5.0),
                                                      child: Text(
                                                        ' 签约方信息${index + 1}',
                                                        style: const TextStyle(
                                                            fontSize: 16),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color:
                                                              AppTheme.bg_c)),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: getWidthPx(10)),
                                                padding: EdgeInsets.fromLTRB(
                                                    getWidthPx(40),
                                                    getWidthPx(20),
                                                    getWidthPx(40),
                                                    getWidthPx(20)),
                                                child: Row(
                                                  children: <Widget>[
                                                    const Text('签字人姓名',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        )),
                                                    Expanded(
                                                        child: Text(
                                                      "${e['userName'] ?? ""}",
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: AppTheme
                                                              .deactivatedText),
                                                      textAlign:
                                                          TextAlign.right,
                                                    )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                  border: const Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color:
                                                              AppTheme.bg_c)),
                                                ),
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: getWidthPx(10)),
                                                padding: EdgeInsets.fromLTRB(
                                                    getWidthPx(40),
                                                    getWidthPx(20),
                                                    getWidthPx(40),
                                                    getWidthPx(20)),
                                                child: Row(
                                                  children: <Widget>[
                                                    const Text('签字人身份证号',
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                        )),
                                                    Expanded(
                                                        child: Text(
                                                            "${e['idCard'] ?? ""}",
                                                            style: const TextStyle(
                                                                fontSize: 16,
                                                                color: AppTheme
                                                                    .deactivatedText),
                                                            textAlign: TextAlign
                                                                .right)),
                                                  ],
                                                ),
                                              ),
                                              e['enterprise'] == null
                                                  ? SizedBox()
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        border: const Border(
                                                            bottom: BorderSide(
                                                                width: 1,
                                                                color: AppTheme
                                                                    .bg_c)),
                                                      ),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  getWidthPx(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              getWidthPx(40),
                                                              getWidthPx(20),
                                                              getWidthPx(40),
                                                              getWidthPx(20)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text('企业名称',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                          Expanded(
                                                              child: Text(
                                                                  e['enterprise'] ==
                                                                          null
                                                                      ? ""
                                                                      : "${e['enterprise']['enterpriseName'] ?? ""}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: AppTheme
                                                                          .deactivatedText),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right)),
                                                        ],
                                                      ),
                                                    ),
                                              e['enterprise'] == null
                                                  ? SizedBox()
                                                  : Container(
                                                      decoration: BoxDecoration(
                                                        border: const Border(
                                                            bottom: BorderSide(
                                                                width: 1,
                                                                color: AppTheme
                                                                    .bg_c)),
                                                      ),
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  getWidthPx(
                                                                      10)),
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              getWidthPx(40),
                                                              getWidthPx(20),
                                                              getWidthPx(40),
                                                              getWidthPx(20)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          const Text('企业地址',
                                                              style: TextStyle(
                                                                fontSize: 16,
                                                              )),
                                                          Expanded(
                                                              child: Text(
                                                                  e['enterprise'] ==
                                                                          null
                                                                      ? ""
                                                                      : "${e['enterprise']['enterpriseAddress'] ?? ""}",
                                                                  style: const TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      color: AppTheme
                                                                          .deactivatedText),
                                                                  textAlign:
                                                                      TextAlign
                                                                          .right)),
                                                        ],
                                                      ),
                                                    ),
                                              e['enterprise'] == null ||
                                                      e['enterprise'][
                                                                  'publicnotaryusers']
                                                              .length ==
                                                          0
                                                  ? SizedBox()
                                                  : ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount: e['enterprise']
                                                              [
                                                              'publicnotaryusers']
                                                          .length,
                                                      itemBuilder: (ctx, b) {
                                                        var example = e[
                                                                'enterprise'][
                                                            'publicnotaryusers'][b];
                                                        return Column(
                                                          children: <Widget>[
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: const Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: AppTheme
                                                                            .bg_c)),
                                                              ),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          getWidthPx(
                                                                              10)),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      getWidthPx(
                                                                          40),
                                                                      getWidthPx(
                                                                          20),
                                                                      getWidthPx(
                                                                          40),
                                                                      getWidthPx(
                                                                          20)),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  const Text(
                                                                      '法定代表人姓名',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      )),
                                                                  Expanded(
                                                                      child:
                                                                          Text(
                                                                    "${example['userName'] ?? ""}",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        color: AppTheme
                                                                            .deactivatedText),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .right,
                                                                  )),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: const Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: AppTheme
                                                                            .bg_c)),
                                                              ),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          getWidthPx(
                                                                              10)),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      getWidthPx(
                                                                          40),
                                                                      getWidthPx(
                                                                          20),
                                                                      getWidthPx(
                                                                          40),
                                                                      getWidthPx(
                                                                          20)),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  const Text(
                                                                      '法定代表人身份证号',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      )),
                                                                  Expanded(
                                                                      child: Text(
                                                                          "${example['idCard'] ?? ""}",
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: AppTheme.deactivatedText),
                                                                          textAlign: TextAlign.right)),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                border: const Border(
                                                                    bottom: BorderSide(
                                                                        width:
                                                                            1,
                                                                        color: AppTheme
                                                                            .bg_c)),
                                                              ),
                                                              margin: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          getWidthPx(
                                                                              10)),
                                                              padding: EdgeInsets
                                                                  .fromLTRB(
                                                                      getWidthPx(
                                                                          40),
                                                                      getWidthPx(
                                                                          20),
                                                                      getWidthPx(
                                                                          40),
                                                                      getWidthPx(
                                                                          20)),
                                                              child: Row(
                                                                children: <
                                                                    Widget>[
                                                                  const Text(
                                                                      '法定代表人手机号',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                      )),
                                                                  Expanded(
                                                                      child: Text(
                                                                          "${example['mobile'] ?? ""}",
                                                                          style: const TextStyle(
                                                                              fontSize: 16,
                                                                              color: AppTheme.deactivatedText),
                                                                          textAlign: TextAlign.right)),
                                                                ],
                                                              ),
                                                            ),
                                                            Container(
                                                              color:
                                                                  AppTheme.bg_e,
                                                              height:
                                                                  getWidthPx(
                                                                      20),
                                                            ),
                                                          ],
                                                        );
                                                      }),
                                              Container(
                                                color: AppTheme.bg_e,
                                                height: getWidthPx(20),
                                              ),
                                            ],
                                          );
                                        }),
                                  ],
                                );
                              }),
                        ),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

// 声网
  // Widget _renderWidget() {
  //   print("++++videoVm.userList.length+++++++++${videoVm.userList.length}");
  //   if (videoVm.userList == null || videoVm.userList.isEmpty) {
  //     return SizedBox();
  //   } else {
  //     return  Column(
  //       children: [
  //         Container(
  //             width: getWidthPx(750),
  //             height: getWidthPx(500),
  //             child: videoVm.notaryInfo==0?SizedBox():RtcRemoteView.SurfaceView(uid: videoVm.notaryInfo)
  //         ),
  //         MediaQuery.removePadding(
  //           removeTop: true,
  //           context: context,
  //           child: GridView.builder(
  //               shrinkWrap: true,
  //               physics: NeverScrollableScrollPhysics(),
  //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //                 crossAxisCount: 2, //每行三列
  //                 childAspectRatio: 1.0 ,//显示区域宽高相等
  //                 mainAxisSpacing: 0,
  //                 crossAxisSpacing:0,
  //               ),
  //               itemCount:videoVm.userList.length,
  //               itemBuilder: (context, index) {
  //                 return  videoVm.userList[index]['name']=="自己"?Stack(
  //                   children: [
  //                     RtcLocalView.SurfaceView(),
  //                     Positioned(
  //                       right: 0,
  //                       child: InkWell(
  //                         onTap: (){
  //                           videoVm.engine.switchCamera();
  //                           videoVm.camerasNum = videoVm.camerasNum==0?1:0;
  //                         },
  //                         child: Container(
  //                           color: Color(0x66ffffff),
  //                           child: Icon(
  //                               Icons.autorenew
  //                           ),
  //                         ),
  //                       ),
  //                     )
  //                   ],
  //                 ) :RtcRemoteView.SurfaceView(uid: videoVm.userList[index]['uid']);
  //               }),
  //         )
  //       ],
  //     );
  //   }
  // }

// 腾讯
  Widget _renderWidget() {
    print("++++videoVm.userList.length+++++++++${videoVm.userList.length}");
    if (videoVm.userList == null || videoVm.userList.isEmpty) {
      return SizedBox();
    } else {
      return MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, //每行三列
              childAspectRatio: 1.0, //显示区域宽高相等
              mainAxisSpacing: 0,
              crossAxisSpacing: 0,
            ),
            itemCount: videoVm.userList.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  videoVm.userList[index]['widget'] != null
                      ? videoVm.userList[index]['widget']
                      : SizedBox(),
                  videoVm.userList[index]['userId'] ==
                          videoVm.userViewModel.idCard
                      ? Positioned(
                          right: 0,
                          child: InkWell(
                            onTap: () {
                              videoVm.txDeviceManager.switchCamera(
                                  videoVm.camerasNum == 0 ? true : false);
                              videoVm.camerasNum =
                                  videoVm.camerasNum == 0 ? 1 : 0;
                              // videoVm.trtcCloud.stopScreenCapture();
                              setState(() {});
                            },
                            child: ColoredBox(
                              color: Color(0x66ffffff),
                              child: Icon(Icons.autorenew),
                            ),
                          ),
                        )
                      : SizedBox()
                ],
              );
            }),
      );
    }
  }
}
