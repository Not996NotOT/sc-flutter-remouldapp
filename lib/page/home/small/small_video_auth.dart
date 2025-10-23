import 'dart:collection';

import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/page/home/entity/small_list_entity.dart';
import 'package:notarization_station_app/page/home/entity/small_material_entity.dart';
import 'package:notarization_station_app/page/home/small/start_public_vm.dart';
import 'package:notarization_station_app/page/login/entity/user_info_entity.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:provider/provider.dart';

import '../../../appTheme.dart';

class SmallVideoAuthPage extends StatefulWidget {
  final arguments;
  SmallVideoAuthPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SmallVideoAuthPageState();
  }
}

class SmallVideoAuthPageState extends BaseState<SmallVideoAuthPage>
    with SingleTickerProviderStateMixin {
  SmallVideoModel videoVm;
  List<CameraDescription> cameras = [];
  UserInfoEntity userInfo;
  TabController tabController;
  Map<int, List<SmallListItemsUserList>> hasMapList = new HashMap();
  SmallListItems orderInfo;

  String nameType(int num) {
    if (num == 1) {
      return "借款人";
    } else if (num == 2) {
      return "担保人";
    } else if (num == 3) {
      return "共同还款人";
    } else if (num == 4) {
      return "财产共同所有人";
    } else if (num == 5) {
      return "借款人和抵押人";
    } else if (num == 6) {
      return "第三方担保人";
    } else if (num == 7) {
      return "第三方财产共同所有人";
    }
    return "";
  }

  List<Widget> tabList(bool isTab) {
    List<Widget> tabList = new List();
    if (isTab) {
      hasMapList.forEach((key, value) {
        tabList.add(Text(nameType(key)));
      });
    } else {
      hasMapList.forEach((key, value) {
        tabList.add(
          MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: value.length,
                itemBuilder: (ctx, a) {
                  return Column(
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: AppTheme.bg_c)),
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                        padding: EdgeInsets.fromLTRB(getWidthPx(40),
                            getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                        child: Row(
                          children: <Widget>[
                            Text('姓名',
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                            Expanded(
                                child: Text(
                              value[a].userName == null
                                  ? ""
                                  : value[a].userName,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.deactivatedText),
                              textAlign: TextAlign.right,
                            )),
                          ],
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(width: 1, color: AppTheme.bg_c)),
                        ),
                        margin:
                            EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                        padding: EdgeInsets.fromLTRB(getWidthPx(40),
                            getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                        child: Row(
                          children: <Widget>[
                            Text('身份证号',
                                style: TextStyle(
                                  fontSize: 16,
                                )),
                            Expanded(
                                child: Text(
                                    value[a].idCard == null
                                        ? ""
                                        : value[a].idCard,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: AppTheme.deactivatedText),
                                    textAlign: TextAlign.right)),
                          ],
                        ),
                      ),
                      Container(
                        color: AppTheme.bg_e,
                        height: getWidthPx(20),
                      ),
                    ],
                  );
                }),
          ),
        );
      });
    }
    return tabList;
  }

  @override
  void initState() {
    super.initState();
    orderInfo = widget.arguments['detail'];
    orderInfo.userList.forEach((SmallListItemsUserList e) {
      if (!hasMapList.containsKey(e.userType)) {
        // ignore: deprecated_member_use
        hasMapList[e.userType] = new List<SmallListItemsUserList>();
      }
      hasMapList[e.userType].add(e);
    });
    print("++++++++++++++${hasMapList.length}");
    tabController = TabController(vsync: this, length: hasMapList.length);
    getCameras();
  }

  getCameras() async {
    cameras = await availableCameras();
    videoVm?.setCameras(cameras);
    videoVm?.setImgNewList(widget.arguments['materialList']);
  }


  @override
  void dispose() {
    videoVm.closeRoom();
    super.dispose();
  }

  changeShowDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (ctx, setBottomSheet) {
              return Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                    height: getHeightPx(900),
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(4)),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: AppTheme.bg_c, width: 1))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                    child: Text(
                                  "上传材料",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                )),
                                Icon(Icons.clear, color: Colors.redAccent),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: videoVm.materialList.length,
                                itemBuilder: (ctx, i) {
                                  SmallMaterialEntity item =
                                      videoVm.materialList[i];
                                  return Column(
                                    children: [
                                      Container(
                                          padding:
                                              EdgeInsets.all(getWidthPx(10)),
                                          width: double.infinity,
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            item.name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14),
                                          )),
                                      GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3, //每行三列
                                            childAspectRatio: 1.0, //显示区域宽高相等
                                            mainAxisSpacing: 10,
                                            crossAxisSpacing: 10,
                                          ),
                                          itemCount: item.data.length + 1,
                                          itemBuilder: (context, index) {
                                            return releaseImage(
                                                index == item.data.length,
                                                index != item.data.length
                                                    ? item.data
                                                    : null,
                                                index,
                                                item.name,
                                                setBottomSheet);
                                          }),
                                    ],
                                  );
                                }),
                          ),
                        ),
                      ],
                    )),
              );
            },
          );
        });
  }

  Widget releaseImage(bool isDef, List<SmallMaterialData> img, int num,
      String name, StateSetter setBottomSheet) {
    return isDef
        ? InkWell(
            onTap: () {
              videoVm.requestCameraPermission(name, setBottomSheet);
            },
            child: Image.asset("lib/assets/images/add_img.png",
                width: 400, height: 400))
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    img[num].annexId,
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              !isDef
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                          onTap: () {
                            videoVm.delImg(
                                img[num].imgPath, num, name, setBottomSheet);
                            videoVm.notifyListeners();
                          },
                          child: Icon(Icons.clear, color: Colors.redAccent)))
                  : SizedBox(width: 0, height: 0)
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.endFloat, 0, -50),
      floatingActionButton: Container(
        width: getWidthPx(70),
        height: getWidthPx(70),
        child: FloatingActionButton(
          child: Icon(Icons.add_circle_outline, size: getWidthPx(70)),
          onPressed: () {
            changeShowDialog();
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () {
          ADialog.confirm(context,
              content: "是否确认退出视频公证？",
              cancelButtonText: Text("取消"),
              confirmButtonText: Text("确认"), cancelButtonPress: () {
            Navigator.of(context).pop();
          }, confirmButtonPress: () {
            videoVm.closeSocket();
            Navigator.of(context).pop();
            Navigator.popUntil(
                context, ModalRoute.withName(RoutePaths.HomeIndex));
          });
          return Future.value(false);
        },
        child: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<SmallVideoModel>(
                model: SmallVideoModel(userModel, widget.arguments['roomId'],
                    tabController, hasMapList, orderInfo),
                onModelReady: (model) async {
                  videoVm = model;
                  model.videoHeight = getHeightPx(1334) - getWidthPx(360);
                  model.initData();
                },
                builder: (ctx, vm, child) {
                  return Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: getScreenWidth() / 2,
                            child: _renderWidget()),
                        Container(
                          height: getHeightPx(70),
                          color: Color(0xFF0188FE),
                          child: TabBar(
                            controller: videoVm.tabController,
                            unselectedLabelColor: Colors.white70,
                            //设置未选中时的字体颜色，tabs里面的字体样式优先级最高
                            unselectedLabelStyle: TextStyle(fontSize: 14),
                            //设置未选中时的字体样式，tabs里面的字体样式优先级最高
                            labelColor: Colors.white,
                            //设置选中时的字体颜色，tabs里面的字体样式优先级最高
                            labelStyle: TextStyle(fontSize: 14),
                            //设置选中时的字体样式，tabs里面的字体样式优先级最高
                            //允许左右滚动
                            indicatorColor: Colors.white,
                            //选中下划线的颜色
                            indicatorSize: TabBarIndicatorSize.label,
                            //选中下划线的长度，label时跟文字内容长度一样，tab时跟一个Tab的长度一样
                            indicatorWeight: 2,
                            onTap: (a) {
                              // if(isOnTap){
                              //   videoVm.tabController.index = 0;
                              // }
                            },
                            tabs: tabList(true),
                          ),
                        ),
                        vm.titleString == ""
                            ? SizedBox()
                            : Expanded(
                                child: SingleChildScrollView(
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: getWidthPx(20),
                                        left: getWidthPx(20),
                                        right: getWidthPx(20)),
                                    child: Html(
                                      data: vm.titleString,
                                    ),
                                  ),
                                ),
                              ),
                        Expanded(
                            child: TabBarView(
                          physics: NeverScrollableScrollPhysics(),
                          controller: videoVm.tabController,
                          children: tabList(false),
                        )),
                      ],
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Widget _renderWidget() {
    print("++++videoVm.userList.length+++++++++${videoVm.userList.length}");
    if (videoVm.userList == null || videoVm.userList.isEmpty) {
      return SizedBox();
    } else {
      return GridView.builder(
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
            return videoVm.userList[index]['name'] == "自己"
                ? RtcLocalView.SurfaceView()
                : RtcRemoteView.SurfaceView(
                    uid: videoVm.userList[index]['uid']);
          });
    }
  }
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
