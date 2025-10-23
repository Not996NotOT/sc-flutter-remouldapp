import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/entity/small_list_entity.dart';
import 'package:notarization_station_app/page/home/small/small_money_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SmallMoneyPage extends StatefulWidget {
  SmallMoneyPage({Key key}) : super(key: key);

  @override
  _SmallMoneyPageState createState() => _SmallMoneyPageState();
}

class _SmallMoneyPageState extends BaseState<SmallMoneyPage> {
  SmallMoneyModel viewModel;

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
      appBar: commonAppBar(title: "区块链赋强"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return ProviderWidget<SmallMoneyModel>(
            model: SmallMoneyModel(userModel),
            onModelReady: (model) {
              viewModel = model;
              model.initData();
            },
            builder: (ctx, viewModel, child) {
              return Column(
                children: <Widget>[
                  // Container(
                  //   height: getHeightPx(70),
                  //   margin: EdgeInsets.all(getWidthPx(20)),
                  //   padding: EdgeInsets.only(left: getWidthPx(10), right: getWidthPx(10)),
                  //   decoration: BoxDecoration(
                  //     border: Border.all(width: 1, color: Colors.black12),
                  //     borderRadius: BorderRadius.circular(getWidthPx(10)),
                  //   ),
                  //   child: Row(
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: <Widget>[
                  //       Expanded(
                  //         child: TextField(
                  //             controller: viewModel.searchController,
                  //             decoration: InputDecoration(
                  //               hintText: "请输入用户身份证进行查询",
                  //               border: InputBorder.none,
                  //               hintStyle: TextStyle(
                  //                 fontSize: 16,
                  //               ),
                  //             ),
                  //             inputFormatters: [WhitelistingTextInputFormatter(RegExp("[0-9Xx.]"))]),
                  //       ),
                  //       InkWell(
                  //         onTap: () {
                  //           print("点击搜索按钮");
                  //           viewModel.refresh();
                  //         },
                  //         child: Icon(
                  //           Icons.search,
                  //           color: Color(0xffAFB1B3),
                  //           size: 40,
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Expanded(
                      child: viewModel.busy
                          ? loadingWidget()
                          : viewModel.searchList.length < 1
                              ? emptyWidget("您还没有任何记录")
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
                                      child: ListView.builder(
                                          itemCount:
                                              viewModel.searchList.length,
                                          itemBuilder: (ctx, index) {
                                            SmallListItems entity =
                                                viewModel.searchList[index];
                                            return InkWell(
                                              onTap: () {
                                                Navigator.pushNamed(context,
                                                        RoutePaths.SmallNew,
                                                        arguments: entity)
                                                    .then((value) =>
                                                        viewModel.refresh());
                                              },
                                              child: Card(
                                                margin: EdgeInsets.only(
                                                    left: getWidthPx(20),
                                                    right: getWidthPx(20),
                                                    top: getWidthPx(20)),
                                                elevation: 3,
                                                child: Column(
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: getHeightPx(20),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: getWidthPx(30)),
                                                      child: Row(
                                                        children: <Widget>[
                                                          Text(
                                                              "借        款       人:   "),
                                                          Expanded(
                                                            child: Text(entity
                                                                .borrower),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: getHeightPx(20),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: getWidthPx(30)),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Text("借款人身份证号:   "),
                                                          Expanded(
                                                            child: Text(
                                                                entity.idCard),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: getHeightPx(20),
                                                    ),
                                                  ],
                                                ),
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
