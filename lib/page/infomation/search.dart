import 'dart:ui';

import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/common_tools.dart';

class SearchBarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  final controller = TextEditingController();
  List notaryList = [];
  final TelAndSmsService _service = locator<TelAndSmsService>();
  bool isSearch = false;

  int pageNum = 1;
  int pageSize = 10;
  RefreshController refreshController;

  String text = '';

  @override
  void initState() {
    refreshController = RefreshController();
    super.initState();
  }

  getNotaryOffice() async {
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
        context: context,
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,);
    }
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Location location = await AmapLocation.instance.fetchLocation();

      Map<String, dynamic> map = {
        "institutionType": "1",
        "currentPage": 1,
        "pageSize": 10,
        "distance": "${location.latLng.longitude},${location.latLng.latitude}",
        "notarialName": text
      };
      wjPrint("位置信息：-----$map");
      var res = await InformationApi.getSingleton()
          .getNotarial(map, errorCallBack: (e) {});
      if (res['code'] == 200) {
        notaryList = res['items'] == null ? [] : res['items'];
        if (notaryList.length == 0) {
          isSearch = true;
        } else {
          isSearch = false;
        }
        setState(() {});
      }
    } else {
      G.showPermissionDialog(str: '访问定位权限');
    }
  }

  refresh() async {
    notaryList.clear();
    pageNum = 1;
    refreshController.resetNoData();
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
        context: context,
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,);
    }
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Location location = await AmapLocation.instance.fetchLocation();
      Map<String, dynamic> map = {
        "institutionType": "1",
        "currentPage": 1,
        "pageSize": 10,
        "distance": "${location.latLng.longitude},${location.latLng.latitude}",
        "notarialName": text
      };
      wjPrint("位置信息：-----$map");
      InformationApi.getSingleton().getNotarial(map, errorCallBack: (e) {
        refreshController.refreshFailed();
        setState(() {});
      }).then((res) {
        if (res['code'] == 200) {
          if (res['items'] == null || res['items'].isEmpty) {
          } else {
            notaryList.addAll(res['items']);
          }
          refreshController.refreshCompleted();

          if (notaryList.length == 0) {
            isSearch = true;
          } else {
            isSearch = false;
          }
          setState(() {});
        }
      }).whenComplete(() => refreshController.refreshCompleted());
    } else {
      G.showPermissionDialog(str: '访问定位权限');
    }
  }

  loadMore() async {
    pageNum += 1;
    if(!await Permission.location.status.isGranted){
      G.showCustomToast(
        context: context,
        titleText: "定位权限使用说明：",
        subTitleText: "用于获取当前位置信息",
        time: 2,);
    }
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      Location location = await AmapLocation.instance.fetchLocation();

      Map<String, dynamic> map = {
        "institutionType": "1",
        "currentPage": pageNum,
        "pageSize": 10,
        "distance": "${location.latLng.longitude},${location.latLng.latitude}",
        "notarialName": text
      };
      wjPrint("位置信息：-----$map");
      var res = await InformationApi.getSingleton().getNotarial(map,
          errorCallBack: (e) {
        pageNum--;
        refreshController.loadFailed();
        setState(() {});
      });
      if (res['code'] == 200) {
        if (res['items'] == null || res['items'].isEmpty) {
          refreshController.loadNoData();
        } else {
          notaryList.addAll(res['items']);
          refreshController.loadComplete();
        }
        if (notaryList.length == 0) {
          isSearch = true;
        } else {
          isSearch = false;
        }
        setState(() {});
      }
    } else {
      G.showPermissionDialog(str: '访问定位权限');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.only(
                top: MediaQueryData.fromWindow(window).padding.top,
              ),
              child: Container(
                height: 52.0,
                child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                              child: Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  width: 5.0,
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: TextField(
                                      controller: controller,
                                      autofocus: true,
                                      decoration: InputDecoration(
                                          contentPadding: EdgeInsets.all(0),
                                          prefixIcon: Icon(Icons.search),
                                          alignLabelWithHint: true,
                                          hintStyle: TextStyle(
                                            height: 1.0,
                                          ),
                                          hintText: '搜索',
                                          border: InputBorder.none),
                                      textInputAction:
                                          TextInputAction.search, //设置跳到下一个选项
                                      // onChanged: onSearchTextChanged,
                                      onSubmitted: (info) {
                                        wjPrint("123------$info");
                                        setState(() {
                                          text = info;
                                        });
                                        refresh();
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.cancel),
                                  color: Colors.grey,
                                  iconSize: 18.0,
                                  onPressed: () {
                                    controller.clear();
                                  },
                                ),
                              ],
                            ),
                          )),
                        ),
                        InkWell(
                          onTap: () {
                            G.pop();
                          },
                          child: Container(
                            child: Text(
                              "取消",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    )),
              ),
            ),
          ),
          Expanded(
            child: notaryList.length == 0 && isSearch
                ? Center(
                    child: Text("暂无数据"),
                  )
                : MediaQuery.removePadding(
                    removeTop: true,
                    context: context,
                    child: SmartRefresher(
                      controller: refreshController,
                      header: HomeRefreshHeader(Colors.black),
                      footer: RefresherFooter(),
                      onRefresh: refresh,
                      onLoading: loadMore,
                      enablePullDown: true,
                      enablePullUp: true,
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, //每行三列
                            childAspectRatio: 1.0, //显示区域宽高相等
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                          ),
                          shrinkWrap: true,
                          itemCount: notaryList.length,
                          itemBuilder: (ctx, i) {
                            var item = notaryList[i];
                            return InkWell(
                              onTap: () {
                                G.pushNamed(RoutePaths.NotaryDetail,
                                    arguments: item);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffF5F5F5),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(4.0)),
                                    image: new DecorationImage(
                                        image: new AssetImage(
                                            "lib/assets/images/公证处_bg.png"),
                                        fit: BoxFit.fill)),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "lib/assets/images/logo.png",
                                      width: 70,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "${item['notarialName']}",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "${item['address']}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
