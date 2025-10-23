import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/infomation/vm/message_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:provider/provider.dart';

import '../../utils/common_tools.dart';

class AddFriendPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddFriendPageState();
  }
}

class AddFriendPageState extends BaseState<AddFriendPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TabController tabController;
  List applyList = [];
  MessageModel mineVM;
  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppTheme.App_bar,
              ),
            ),
          ),
          centerTitle: true,
          title: const Text(
            "消息",
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          elevation: 0,
          leading: InkWell(
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 22,
            ),
            onTap: () {
              if (mineVM.isOperation == 1) {
                Navigator.pop(context, "refresh");
              } else {
                Navigator.pop(context);
              }
            },
          ),
        ),
        backgroundColor: AppTheme.chipBackground,
        body: WillPopScope(
          onWillPop: () async {
            if (mineVM.isOperation == 1) {
              wjPrint("111111111111");
              Navigator.pop(context, "refresh");
            } else {
              Navigator.pop(context);
            }
            return Future.value(false);
          },
          child: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
            return ProviderWidget<MessageModel>(
              model: MessageModel(userModel),
              onModelReady: (model) {
                model.applyFriend();
                mineVM = model;
              },
              builder: (ctx, vm, child) {
                return Container(
                  width: getWidthPx(750),
                  child: vm.applyList.length == 0
                      ? const Center(
                          child: Text("暂无记录"),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          // physics:NeverScrollableScrollPhysics(),
                          itemCount: vm.applyList.length,
                          itemBuilder: (ctx, a) {
                            var item = vm.applyList[a];
                            return Container(
                              padding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                              decoration: BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(
                                          width: 1, color: AppTheme.Text_a))),
                              child: Row(
                                children: [
                                  Text(
                                    "${item['userName'] ?? ''}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "申请添加你的好友",
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.Text_max),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        "${item['createDate'] ?? ''}",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.Text_a),
                                      ),
                                    ],
                                  )),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      vm.isOperation = 1;
                                      vm.approvalFriend(item['unitGuid'], 2);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 6, 15, 6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.themeBlue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                      child: const Text(
                                        "同意",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      vm.isOperation = 1;
                                      vm.approvalFriend(item['unitGuid'], 3);
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 6, 15, 6),
                                      decoration: BoxDecoration(
                                        color: AppTheme.Text_min,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(4.0)),
                                      ),
                                      child: const Text(
                                        "拒绝",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                );
              },
            );
          }),
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
