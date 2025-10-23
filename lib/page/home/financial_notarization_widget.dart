import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/entity/financial_notarization_entity.dart';
import 'package:notarization_station_app/page/home/vm/financial_notarization%20_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/common_tools.dart';

/// 金融公证模块代码
class FinancialNotarizationWidget extends StatefulWidget {
  const FinancialNotarizationWidget({Key key}) : super(key: key);

  @override
  State<FinancialNotarizationWidget> createState() =>
      _FinancialNotarizationWidgetState();
}

class _FinancialNotarizationWidgetState
    extends BaseState<FinancialNotarizationWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "金融公证"),
      body: Consumer<UserViewModel>(
        builder: (context, userModel, child) {
          return ProviderWidget<FinancialNotarizationViewModel>(
            builder: (context, viewModel, child) {
              wjPrint("viewModel.dataList------${viewModel.dataList.length}");
              if (viewModel.busy) {
                return loadingWidget();
              } else if (viewModel.empty) {
                return Container(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/images/empty.png",
                        width: 150,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text('暂无数据'),
                      )
                    ],
                  ),
                );
              } else if (viewModel.idle) {
                return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: HomeRefreshHeader(Colors.black),
                    footer: RefresherFooter(),
                    controller: viewModel.refreshController,
                    onRefresh: viewModel.refreshData,
                    onLoading: viewModel.loadMoreData,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return FinancialNotarizationItem(
                            entity: viewModel.dataList[index],
                            callBack: () {
                              viewModel.startAuthentication(
                                  viewModel.dataList[index]);
                            });
                      },
                      itemCount: viewModel.dataList.length,
                    ));
              }
              return null;
            },
            model: FinancialNotarizationViewModel(userViewModel: userModel),
            onModelReady: (viewModel) {
              viewModel.initData();
            },
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class FinancialNotarizationItem extends StatelessWidget {
  FinancialNotarizationEntity entity;
  Function callBack;
  FinancialNotarizationItem({Key key, this.entity, this.callBack})
      : super(key: key);

  /// 创建list item
  Widget _createListItem() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: 5, right: 5),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Color(0xFFF2F2F2), offset: Offset(0, 4), blurRadius: 6),
            BoxShadow(
                color: Color(0xFFF2F2F2), offset: Offset(0, 4), blurRadius: 6)
          ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "订单编号：",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${entity.orderNumber}",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Text(
                          "机构名称：",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "${entity.notaryName}",
                          //entity.orderNo,
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: InkWell(
              onTap: () {
                callBack();
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                    color: AppTheme.themeBlue,
                    borderRadius: BorderRadius.circular(5.0)),
                child: Text(
                  "开始公证",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _createListItem();
  }
}
