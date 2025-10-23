import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/infomation/vm/notary_office_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/focus_detector.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotaryOfficePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NotaryOfficePageState();
  }
}

class NotaryOfficePageState extends BaseState<NotaryOfficePage>
    with AutomaticKeepAliveClientMixin {
  NotaryOfficeModel notaryModel;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FocusDetector(
      onFocusGained: () {
        if (notaryModel != null) {
          notaryModel.getNotaryOffice();
          notaryModel.getTree();
        }
      },
      child: Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            leading: InkWell(
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 22,
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: AppTheme.white,
            centerTitle: true,
            title: const Text(
              "公证处",
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
            actions: [
              notaryModel?.isShow != null && notaryModel.isShow
                  ? SizedBox()
                  : InkWell(
                      onTap: () {
                        G.pushNamed(RoutePaths.Search);
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.search, color: Colors.black),
                      ),
                    )
            ],
          ),
          backgroundColor: AppTheme.chipBackground,
          body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
            return ProviderWidget<NotaryOfficeModel>(
              model: NotaryOfficeModel(userModel),
              onModelReady: (model) {
                notaryModel = model;
                // model.getNotaryOffice();
                // model.getTree();
              },
              builder: (ctx, vm, child) {
                return Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      color: Color(0xffFAFAFA),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              vm.isShow = false;
                              vm.getNotaryOffice();
                              setState(() {});
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  "公证处",
                                  style: TextStyle(
                                      color: vm.isShow
                                          ? Colors.black
                                          : AppTheme.textBlue,
                                      fontSize: !vm.isShow ? 16 : 14,
                                      fontWeight: !vm.isShow
                                          ? FontWeight.bold
                                          : FontWeight.normal),
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              vm.isShow = true;
                              setState(() {});
                            },
                            child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 20),
                                child: Text("公证事项",
                                    style: TextStyle(
                                        color: vm.isShow
                                            ? AppTheme.textBlue
                                            : Colors.black,
                                        fontSize: vm.isShow ? 16 : 14,
                                        fontWeight: vm.isShow
                                            ? FontWeight.bold
                                            : FontWeight.normal))),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: !vm.isShow
                          ? ColoredBox(
                              color: Colors.white,
                              child: vm.notaryList.length > 0
                                  ? SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      header: HomeRefreshHeader(Colors.black),
                                      footer: RefresherFooter(),
                                      controller: vm.refreshController,
                                      onRefresh: vm.refresh,
                                      onLoading: vm.loadMore,
                                      child: ListView.builder(
                                          // shrinkWrap: true,
                                          // physics:NeverScrollableScrollPhysics(),
                                          itemCount: vm.notaryList.length,
                                          itemBuilder: (ctx, i) {
                                            var item = vm.notaryList[i];
                                            return InkWell(
                                              onTap: () {
                                                G.pushNamed(
                                                    RoutePaths.NotaryDetail,
                                                    arguments: item);
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        10, 6, 10, 10),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  border: const Border(
                                                      bottom: BorderSide(
                                                          width: 1,
                                                          color: AppTheme.bg_b)),
                                                ),
                                                child: Row(
                                                  children: [
                                                    Image.asset(
                                                        "lib/assets/images/logo.png",
                                                        width: getWidthPx(160)),
                                                    Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets
                                                                .symmetric(
                                                            horizontal: 10),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "${item['notarialName'] ?? ''}",
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          4),
                                                              child: Row(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                textBaseline:
                                                                    TextBaseline
                                                                        .alphabetic,
                                                                children: [
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        top: 4),
                                                                    child: Image.asset(
                                                                        "lib/assets/images/位置.png",
                                                                        width:
                                                                            12),
                                                                  ),
                                                                  Expanded(
                                                                      child: Text(
                                                                          "${item['address'] ?? ''}",
                                                                          maxLines:
                                                                              2,
                                                                          overflow:
                                                                              TextOverflow
                                                                                  .ellipsis,
                                                                          style: const TextStyle(
                                                                              fontSize:
                                                                                  14)))
                                                                ],
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Image.asset(
                                                                    "lib/assets/images/距离.png",
                                                                    width: 12),
                                                                Text(
                                                                    "距你${double.parse("${item['distance'] ?? 0}") / 1000}km",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14))
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    Image.asset(
                                                        "lib/assets/images/iPhone.png",
                                                        width: 28),
                                                    SizedBox(
                                                      width: 18,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          }))
                                  : const Center(child: Text("暂无记录")),
                            )
                          : vm.treeList.length > 0
                              ? ListView.builder(
                                  itemCount: vm.treeList.length,
                                  itemBuilder: (ctx, i) {
                                    var item = vm.treeList[i];
                                    return Container(
                                      padding: EdgeInsets.fromLTRB(10, 6, 10, 10),
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "${item['name'] ?? ''}",
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold),
                                              )),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10),
                                            child: item['children'].length > 0
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        left: getWidthPx(10)),
                                                    child: Wrap(
                                                      spacing: getWidthPx(10),
                                                      children: getWidget(
                                                          item['children'] ?? ''),
                                                    ))
                                                : const Text("暂无数据"),
                                          ),
                                        ],
                                      ),
                                    );
                                  })
                              : const Center(child: Text("暂无记录")),
                    ),
                  ],
                );
              },
            );
          })),
    );
  }

  List<Widget> getWidget(List info) {
    List<Widget> list = [];
    info.forEach((element) {
      Widget text = InkWell(
          onTap: () {
            G.pushNamed(RoutePaths.MatterList, arguments: element);
          },
          child: Container(
              padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
              margin: EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                border: Border.all(width: 1, color: AppTheme.Text_min),
              ),
              child: Text(
                "${element['name'] ?? ''}",
                style: TextStyle(color: AppTheme.Text_min),
              )));
      list.add(text);
    });
    return list;
  }

  @override
  bool get wantKeepAlive => true;
}
