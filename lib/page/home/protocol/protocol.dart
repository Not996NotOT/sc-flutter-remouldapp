import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/protocol_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProtocolPage extends StatefulWidget {
  @override
  _ProtocolPageState createState() => _ProtocolPageState();
}

class _ProtocolPageState extends BaseState<ProtocolPage> {
  ProtocolViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppTheme.themeBlue,
          centerTitle: true,
          title: const Text(
            "待办列表",
            style: TextStyle(fontSize: 16),
          ),
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 22,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            TextButton(
                onPressed: () {
                  G
                      .getCurrentState()
                      .pushReplacementNamed(RoutePaths.ContractPeople);
                },
                child: const Text(
                  "办理多方公证",
                  style: TextStyle(color: Colors.white),
                ))
          ],
        ),
        body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
          return ProviderWidget<ProtocolViewModel>(
              model: ProtocolViewModel(userModel),
              onModelReady: (model) {
                viewModel = model;
                model.getAppointmentLists();
              },
              builder: (ctx, helpModel, child) {
                return ColoredBox(
                    color: Color.fromRGBO(247, 247, 247, 1),
                    child: helpModel.busy
                        ? loadingWidget()
                        : viewModel.appointmentLists != null && viewModel.appointmentLists.length > 0
                            ? SmartRefresher(
                                enablePullDown: true,
                                enablePullUp: true,
                                header: HomeRefreshHeader(Colors.black),
                                footer: RefresherFooter(),
                                controller: helpModel.refreshController,
                                onRefresh: helpModel.refresh,
                                onLoading: helpModel.loadMore,
                                child: ListView.builder(
                                  itemCount: viewModel.appointmentLists.length,
                                  itemBuilder: (context, index) {
                                    return _listItem(
                                        viewModel.appointmentLists[index]);
                                  },
                                ))
                            : Center(
                                child: Text(
                                  "暂无待办",
                                ),
                              ));
              });
        }));
  }

  /// list item
  Widget _listItem(Map item) {
    bool isTrue = true;
    if(viewModel.selectMap.isEmpty){
      isTrue = true;
    }else {
      if (viewModel.selectMap['unitGuid'] == item['unitGuid']){
        isTrue = false;
      }else {
        isTrue = true;
      }
    }
    return Container(
      margin: EdgeInsets.fromLTRB(getWidthPx(20),0,getWidthPx(20), getWidthPx(20)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(getWidthPx(20))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: getWidthPx(700),
            margin: EdgeInsets.fromLTRB(getWidthPx(20), getWidthPx(30),
                getWidthPx(20), getWidthPx(0)),
            child: Row(
              children: <Widget>[
                 Text(
                 item['projectId'] !=null && item['projectId'].isNotEmpty ? "项目名称" : "合同方",
                  style: TextStyle(
                    color: Color.fromRGBO(195, 195, 195, 1),
                  ),
                ),
                Expanded(
                    child: Text(
                      "${item['name'] ?? ''}",
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ),
          Container(
            width: getWidthPx(700),
            margin: EdgeInsets.fromLTRB(getWidthPx(20), getWidthPx(30),
                getWidthPx(20), getWidthPx(0)),
            child: Row(
              children: <Widget>[
                const Text(
                  "公证处",
                  style: TextStyle(
                    color: Color.fromRGBO(195, 195, 195, 1),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "${item['notaryName'] ?? ''}",
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
          Offstage(
            offstage: !(item['projectId'] !=null && item['projectId'].isNotEmpty),
            child: Container(
              width: getWidthPx(700),
              margin: EdgeInsets.fromLTRB(getWidthPx(20), getWidthPx(30),
                  getWidthPx(20), getWidthPx(10)),
              child: Row(
                children: <Widget>[
                  const Text(
                    "公证员",
                    style: TextStyle(
                      color: Color.fromRGBO(195, 195, 195, 1),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      "${item['greffierName'] ?? ''}",
                      textAlign: TextAlign.right,
                      style: const TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DebounceButton(
                clickTap: () async {
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
                    viewModel.selectMap = item;
                    if(item['projectId']!=null && item['projectId'].isNotEmpty){
                      viewModel.addOrder(item['projectId'], item['roomNum'].toString());
                    }else {
                      viewModel.sendContractOrder(item['unitGuid'],item['orderNo']);
                    }

                  } else {
                    G.showPermissionDialog(str: "访问内部存储、语音麦克风、相机、相册信息权限");
                  }
                },
                isEnable: isTrue,
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                backgroundColor: Colors.white,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.play_circle_fill,color: isTrue ? AppTheme.themeBlue : AppTheme.white, size: 18),
                    SizedBox(width: 5,),
                    Text('开始公证',
                        style: TextStyle(color: isTrue ? AppTheme.themeBlue : AppTheme.white))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
