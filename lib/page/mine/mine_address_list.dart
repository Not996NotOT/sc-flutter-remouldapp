import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/components/drawable_text_widget.dart';
import 'package:notarization_station_app/page/mine/vm/address_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../login/vm/user_view_model.dart';

class MineAddressListPage extends StatefulWidget {
  @override
  _MineAddressListPageState createState() => _MineAddressListPageState();
}

class _MineAddressListPageState extends BaseState<MineAddressListPage> {
  AddressViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(
        title: "我的地址",
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, RoutePaths.AddAddress)
                  .then((value) => viewModel.refresh());
            },
            child: Center(
              child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: const Text("新增地址")),
            ),
          )
        ],
      ),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return ProviderWidget<AddressViewModel>(
            model: AddressViewModel(userModel.user),
            onModelReady: (model) {
              viewModel = model;
              model.initData();
            },
            builder: (ctx, addressModel, child) {
              return ColoredBox(
                  color: AppTheme.chipBackground,
                  child: addressModel.busy
                      ? loadingWidget()
                      : addressModel.empty
                          ? emptyWidget("您还没有添加地址")
                          : RefreshConfiguration.copyAncestor(
                              context: context,
                              child: Container(
                                child: getNoInkWellListView(
                                    scrollView: SmartRefresher(
                                  controller: addressModel.refreshController,
                                  header: HomeRefreshHeader(Colors.black),
                                  footer: RefresherFooter(),
                                  onRefresh: addressModel.refresh,
                                  onLoading: addressModel.loadMore,
                                  enablePullDown: true,
                                  enablePullUp: true,
                                  child: addressListWidget(),
                                )),
                              )));
            },
          );
        },
      ),
    );
  }

  Widget addressListWidget() {
    return ListView.separated(
        itemCount: viewModel.infoList.length,
        separatorBuilder: (BuildContext context, int index) {
          return Divider(color: Colors.transparent, height: 10);
        }, //根据
        itemBuilder: (ctx, index) {
          var item = viewModel.infoList[index];
          return Container(
            color: Colors.white,
            padding: EdgeInsets.all(getWidthPx(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text(
                      item.receivingUsername,
                      maxLines: 2,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: getSp(36),
                      ),
                    ),
                    SizedBox(width: getWidthPx(10)),
                    Text(
                      item.phone,
                      maxLines: 2,
                      style:
                          TextStyle(color: Colors.black38, fontSize: getSp(28)),
                    ),
                  ],
                ),
                SizedBox(
                  height: getHeightPx(20),
                ),
                Text(
                  item.address,
                  maxLines: 2,
                  style: TextStyle(color: Colors.black, fontSize: getSp(30)),
                  softWrap: true,
                ),
                Divider(height: getHeightPx(40), thickness: 1),
                Row(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                            value: item.noDefault == "0",
                            onChanged: (value) {
                              if (item.noDefault == "1") {
                                item.noDefault = "0";
                              } else {
                                item.noDefault = "1";
                              }
                              viewModel.editAddress(item);
                            }),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text('默认地址',
                              style: TextStyle(
                                color: item.noDefault == "0"
                                    ? AppTheme.themeBlue
                                    : AppTheme.deactivatedText,
                                fontSize: getSp(28),
                              )),
                        )
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, RoutePaths.AddAddress,
                                arguments: item)
                            .then((value) => viewModel.refresh());
                      },
                      child: DrawableTextView(
                        text: Text("编辑",
                            style: TextStyle(
                                color: AppTheme.deactivatedText,
                                fontSize: getSp(28))),
                        asset: "lib/assets/images/ic_address_edit.png",
                        model: DrawableModel.left,
                        assetWidth: getWidthPx(35),
                        drawablePadding: getWidthPx(10),
                      ),
                    ),
                    SizedBox(width: getWidthPx(30)),
                    InkWell(
                      onTap: () {
                        ADialog.confirm(context,
                            content: "是否确认删除地址？",
                            cancelButtonText: const Text("取消"),
                            confirmButtonText: const Text("删除"),
                            cancelButtonPress: () {
                          Navigator.of(context).pop();
                        }, confirmButtonPress: () {
                          viewModel.delAddress(item.unitGuid, index);
                          Navigator.of(context).pop();
                        });
                      },
                      child: DrawableTextView(
                        text: Text("删除",
                            style: TextStyle(
                                color: AppTheme.deactivatedText,
                                fontSize: getSp(28))),
                        asset: "lib/assets/images/ic_address_del.png",
                        model: DrawableModel.left,
                        assetWidth: getWidthPx(35),
                        drawablePadding: getWidthPx(10),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        });
  }
}
