import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/infomation/vm/information_vm.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class InformationIndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return InformationPageState();
  }
}

class InformationPageState extends BaseState<InformationIndexPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: AppTheme.themeBlue,
        centerTitle: true,
        title: Text(
          "消息通知",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      backgroundColor: AppTheme.chipBackground,
      body: ProviderWidget<InformationViewModel>(
        model: InformationViewModel(),
        onModelReady: (model) {
          model.refresh();
        },
        builder: (ctx, infomationModel, child) {
          ///我顶层定义的有 refresh的属性，可以用这个方法获得，并不一定非要这么写
          return Container(
              width: getWidthPx(750),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: getHeightPx(20),
                  ),
                  Expanded(
                    child: Container(
                        child: infomationModel.busy
                            ? loadingWidget()
                            : infomationModel.empty
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        height: getHeightPx(500),
                                        width: getWidthPx(500),
                                        child: Image.asset(
                                          "lib/assets/images/noInfo.png",
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ],
                                  )
                                : RefreshConfiguration.copyAncestor(
                                    context: context,
                                    child: Container(
                                        child: getNoInkWellListView(
                                      scrollView: SmartRefresher(
                                        enablePullDown: true,
                                        enablePullUp: true,
                                        header: HomeRefreshHeader(Colors.black),
                                        footer: RefresherFooter(),
                                        controller:
                                            infomationModel.refreshController,
                                        onRefresh: infomationModel.refresh,
                                        onLoading: infomationModel.loadMore,
                                        child: ListView(
                                          children: infomationModel.infoList
                                              .map((item) {
                                            return Container(
                                              alignment: Alignment.center,
                                              margin: EdgeInsets.only(
                                                  bottom: getHeightPx(20)),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        getWidthPx(20)),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  G.pushNamed(
                                                      RoutePaths.InfoDetail,
                                                      arguments: {
                                                        "title": item.title,
                                                        "content": item.content,
                                                        "date":
                                                            item.publishTime,
                                                        "notaryName":
                                                            item.notaryName
                                                      });
                                                },
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: getHeightPx(20),
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(
                                                          children: <Widget>[
                                                            SizedBox(
                                                              width: getWidthPx(
                                                                  20),
                                                            ),
//                                            Image.network(item['pictureUrl']),
                                                            ClipOval(
                                                                child: FadeInImage
                                                                    .assetNetwork(
                                                              width: getWidthPx(
                                                                  80),
                                                              height:
                                                                  getWidthPx(
                                                                      80),
                                                              placeholder:
                                                                  'lib/assets/images/logo1.jpg',
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  'lib/assets/images/logo1.jpg',
                                                            )),
                                                            SizedBox(
                                                              width: getWidthPx(
                                                                  10),
                                                            ),
                                                            Text(
                                                              item.notaryName,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff5496e0),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: <Widget>[
                                                            Text(
                                                              item.publishTime
                                                                  .toString()
                                                                  .substring(
                                                                      0, 10),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black54,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                            SizedBox(
                                                              width: getWidthPx(
                                                                  20),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: getHeightPx(30),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 15),
                                                      child: Image.network(
                                                          item.pictureUrl),
                                                    ),
                                                    SizedBox(
                                                      height: getHeightPx(10),
                                                    ),
                                                    Text(
                                                      item.title,
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Row(
                                                      children: <Widget>[
                                                        SizedBox(
                                                          height:
                                                              getHeightPx(30),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    )))),
                  )
                ],
              ));
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
