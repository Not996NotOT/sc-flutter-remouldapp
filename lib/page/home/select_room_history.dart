import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/vm/select_room_history_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SelectRoomHistoryWidget extends StatefulWidget {
  const SelectRoomHistoryWidget({Key key}) : super(key: key);

  @override
  State<SelectRoomHistoryWidget> createState() =>
      _SelectRoomHistoryWidgetState();
}

class _SelectRoomHistoryWidgetState extends BaseState<SelectRoomHistoryWidget> {
  SelectRoomHistoryViewModel _selectRoomHistoryViewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "选房记录"),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          return ProviderWidget(
            builder: (context, selectRoomViewModel, child) {
              if (selectRoomViewModel.busy) {
                return loadingWidget();
              } else if (selectRoomViewModel.empty) {
                return emptyWidget("暂无数据");
              } else if (selectRoomViewModel.idle) {
                return SmartRefresher(
                    enablePullDown: true,
                    enablePullUp: true,
                    header: HomeRefreshHeader(Colors.black),
                    footer: RefresherFooter(),
                    controller: selectRoomViewModel.controller,
                    onRefresh: selectRoomViewModel.refreshData,
                    onLoading: selectRoomViewModel.loadMoreData,
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        return _buildCardView(index);
                      },
                      itemCount: 10, //selectRoomViewModel.dataList.length,
                    ));
              }
              return null;
            },
            model: SelectRoomHistoryViewModel(userViewModel: userViewModel),
            onModelReady: (selectRoomViewModel) {
              // _selectRoomHistoryViewModel = selectRoomViewModel;
              // selectRoomViewModel.initData();
            },
          );
        },
      ),
    );
  }

  // 创建card
  Widget _buildCardView(int index) {
    return Container(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: Color(0xFFF0F0F0), spreadRadius: 6.0, blurRadius: 3.0)
            ]),
        child: Column(
          children: [_showTimerWidget(index), _houseInformationWidget(index)],
        ),
      ),
    );
  }

  // 倒计时显示
  Widget _showTimerWidget(int index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
      decoration: BoxDecoration(
          color: Color(0xFFB2B2B2),
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10.0), topRight: Radius.circular(10.0))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "待确认",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          RichText(
              text: TextSpan(
                  text: "请在",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                // _selectRoomHistoryViewModel.dataList[index].minute==null||int.parse(_selectRoomHistoryViewModel.dataList[index].minute)==0?null:
                TextSpan(
                    text:
                        "14", //'${_selectRoomHistoryViewModel.dataList[index].minute}',
                    style: TextStyle(
                      color: Colors.redAccent,
                    )),
                // _selectRoomHistoryViewModel.dataList[index].minute==null||int.parse(_selectRoomHistoryViewModel.dataList[index].minute)==0?null:
                TextSpan(
                  text: "分",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                TextSpan(
                    text:
                        "43", //'${_selectRoomHistoryViewModel.dataList[index].seconds}',
                    style: TextStyle(
                      color: Colors.redAccent,
                    )),
                TextSpan(
                  text: "秒内完成并确认签字",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ]))
        ],
      ),
    );
  }

  // 选房信息
  Widget _houseInformationWidget(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text("楼盘名称："),
                Expanded(child: Text('新江花园')),
              ],
            ),
          ),
          Row(
            children: [
              Text("选中房号："),
              Expanded(child: Text('2栋2单元2层202室')),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Text("选房时间："),
                Expanded(child: Text('2022-03-09 13：05')),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: InkWell(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: Colors.deepOrangeAccent, width: 1.0),
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  '立即确认',
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Text(
              '友情提示',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              '未在规定时间内签字确认，将视为自动放 弃认购。',
            ),
          ),
        ],
      ),
    );
  }
}
