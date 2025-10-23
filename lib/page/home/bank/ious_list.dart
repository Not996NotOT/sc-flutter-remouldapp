import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'ious_vm.dart';

class IousListPage extends StatefulWidget {
  IousListPage({Key key}) : super(key: key);

  @override
  _IousListPageState createState() => _IousListPageState();
}

class _IousListPageState extends BaseState<IousListPage> {
  IousModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // 取消监听
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "借款借据确认"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return ProviderWidget<IousModel>(
            model: IousModel(userModel),
            onModelReady: (model) {
              viewModel = model;
              model.initData();
            },
            builder: (ctx, viewModel, child) {
              return Column(
                children: <Widget>[
                  Expanded(
                      child: viewModel.busy
                          ? loadingWidget()
                          : RefreshConfiguration.copyAncestor(
                              context: context,
                              child: Container(
                                child: getNoInkWellListView(
                                    scrollView: SmartRefresher(
                                  controller: viewModel.refreshController,
                                  header: HomeRefreshHeader(Colors.black),
                                  footer: RefresherFooter(),
                                  onRefresh: viewModel.refresh,
                                  onLoading: viewModel.loadMore,
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  child: viewModel.searchList.length < 1
                                      ? emptyWidget("您还没有任何记录")
                                      : ListView.builder(
                                          itemCount:
                                              viewModel.searchList.length,
                                          itemBuilder: (ctx, index) {
                                            var entity =
                                                viewModel.searchList[index];
                                            return Card(
                                              margin: EdgeInsets.only(
                                                  left: getWidthPx(20),
                                                  right: getWidthPx(20),
                                                  top: getWidthPx(20)),
                                              elevation: 3,
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Column(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height:
                                                              getHeightPx(20),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      getWidthPx(
                                                                          30)),
                                                          child: Row(
                                                            children: <Widget>[
                                                              Text(
                                                                  "借  款 人:   "),
                                                              Expanded(
                                                                child: Text(
                                                                    entity[
                                                                        'name']),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              getHeightPx(20),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      getWidthPx(
                                                                          30)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text("身份证号:   "),
                                                              Expanded(
                                                                child: Text(entity[
                                                                    'idCard']),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              getHeightPx(20),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left:
                                                                      getWidthPx(
                                                                          30)),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: <Widget>[
                                                              Text(
                                                                  "订  单 号:   "),
                                                              Expanded(
                                                                child: Text(entity[
                                                                    'orderNo']),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height:
                                                              getHeightPx(20),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  TextButton(
                                                    onPressed: () async {
                                                      if(!await Permission.camera.status.isGranted || !await Permission.speech.status.isGranted || !await Permission.storage.status.isGranted){
                                                        G.showCustomToast(
                                                            context: context,
                                                            titleText: "相机、麦克风、存储权限说明：",
                                                            subTitleText: "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                                                            time: 2
                                                        );
                                                      }
                                                      if (await Permission.camera.request().isGranted &&
                                                          await Permission
                                                              .speech
                                                              .request()
                                                              .isGranted &&
                                                          await Permission
                                                              .storage
                                                              .request()
                                                              .isGranted) {
                                                        viewModel
                                                            .getData(entity);
                                                      } else {
                                                        G.showPermissionDialog(
                                                            str:
                                                                "访问内部存储、语音麦克风、相机、相册权限");
                                                      }
                                                    },
                                                    child: Text("开始公证"),
                                                  )
                                                ],
                                              ),
                                            );
                                          }),
                                )),
                              ))),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;
}
