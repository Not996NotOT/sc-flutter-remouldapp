import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/infomation/vm/msg_inform_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MsgInformPage extends StatefulWidget {
  int arguments;
  MsgInformPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MsgInformPageState();
  }
}

class MsgInformPageState extends BaseState<MsgInformPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 22,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          backgroundColor: AppTheme.themeBlue,
          centerTitle: true,
          title: Text(
            widget.arguments == 1 ? "点赞" : "评论",
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        backgroundColor: AppTheme.chipBackground,
        body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
          return ProviderWidget<MsgInformModel>(
            model: MsgInformModel(userModel, widget.arguments),
            onModelReady: (model) {
              model.loadData();
            },
            builder: (ctx, vm, child) {
              return Container(
                width: getWidthPx(750),
                color: Color(0xffEDEDED),
                child: SmartRefresher(
                  enablePullDown: true,
                  enablePullUp: true,
                  header: HomeRefreshHeader(Colors.black),
                  footer: RefresherFooter(),
                  controller: vm.refreshController,
                  onRefresh: vm.refresh,
                  onLoading: vm.loadMore,
                  child: vm.busy
                      ? loadingWidget()
                      : vm.msgList.length > 0
                          ? widget.arguments == 1
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: vm.msgList.length,
                                  itemBuilder: (ctx, i) {
                                    var item = vm.msgList[i];
                                    return InkWell(
                                      onTap: () {
                                        vm.goDetail(
                                            item['category'],
                                            item['questionId'],
                                            item['unitGuid'],
                                            item['IsRead'] == 1 ? false : true);
                                        item['IsRead'] = 1;
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 15, 10, 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Color(0xffEBEBEB))),
                                        ),
                                        child: Row(
                                          children: [
                                            item['IsRead'] == 0
                                                ? Container(
                                                    width: 5,
                                                    height: 5,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          width: 0,
                                                          style:
                                                              BorderStyle.none),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Text(
                                              item['cuserName'] != null
                                                  ? "${item['cuserName'] ?? "用户某某"}"
                                                  : "${item['buserName'] ?? "用户某某"}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['category'] == 1
                                                        ? "点赞了您的提问"
                                                        : "点赞了您的评论",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppTheme.Text_max),
                                                  ),
                                                  item['operateDate'] == null
                                                      ? SizedBox()
                                                      : Text(
                                                          "${item['operateDate']}",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: AppTheme
                                                                  .Text_a),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "详情",
                                              style: TextStyle(
                                                  color: AppTheme.themeBlue),
                                            ),
                                            Icon(Icons.chevron_right,
                                                color: AppTheme.themeBlue),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: vm.msgList.length,
                                  itemBuilder: (ctx, i) {
                                    var item = vm.msgList[i];
                                    return InkWell(
                                      onTap: () {
                                        vm.goDetailTwo(
                                            item['category'],
                                            item['questionid'],
                                            item['unitguid'],
                                            item['IsRead'] == 1 ? false : true);
                                        item['isRead'] = 1;
                                        setState(() {});
                                      },
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 15, 10, 15),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 1,
                                                  color: Color(0xffEBEBEB))),
                                        ),
                                        child: Row(
                                          children: [
                                            item['isRead'] == 0
                                                ? Container(
                                                    width: 5,
                                                    height: 5,
                                                    padding: EdgeInsets.all(5),
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          width: 0,
                                                          style:
                                                              BorderStyle.none),
                                                    ),
                                                  )
                                                : SizedBox(),
                                            Text(
                                              "${item['createusername'] ?? "用户某某"}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    item['type'] == 1
                                                        ? "评论了您的提问"
                                                        : "回复了您的评论",
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color:
                                                            AppTheme.Text_max),
                                                  ),
                                                  item['createdate'] == null
                                                      ? SizedBox()
                                                      : Text(
                                                          "${item['createdate']}",
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: AppTheme
                                                                  .Text_a),
                                                        ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                              "详情",
                                              style: TextStyle(
                                                  color: AppTheme.themeBlue),
                                            ),
                                            Icon(Icons.chevron_right,
                                                color: AppTheme.themeBlue),
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                          : Center(child: Text("暂无记录")),
                ),
              );
            },
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}
