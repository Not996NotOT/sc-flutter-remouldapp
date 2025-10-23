import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/components/a_dialog/a_dialog.dart';
import 'package:notarization_station_app/page/home/entity/reception_common_user_information.dart';
import 'package:notarization_station_app/page/home/vm/receptiom_room_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

/// 金融公证受理室部分代码
class ReceptionRoomWidget extends StatefulWidget {
  final data;
  ReceptionRoomWidget({Key key, this.data}) : super(key: key);

  @override
  State<ReceptionRoomWidget> createState() => _ReceptionRoomWidgetState();
}

class _ReceptionRoomWidgetState extends BaseState<ReceptionRoomWidget>
    with TickerProviderStateMixin {
  ReceptionRoomViewModel _receptionRoomViewModel;

  @override
  void dispose() {
    super.dispose();
    if (_receptionRoomViewModel.pageController != null) {
      _receptionRoomViewModel.pageController.dispose();
    }
    _receptionRoomViewModel.closeRoom();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () {
          ADialog.confirm(context,
              content: "是否确认退出金融公证？",
              cancelButtonText: Text("取消"),
              confirmButtonText: Text("确认"), cancelButtonPress: () {
            Navigator.of(context).pop();
          }, confirmButtonPress: () {
            _receptionRoomViewModel.closeSocket();
            G.pop();
            G
                .getCurrentState()
                .popUntil(ModalRoute.withName(RoutePaths.HomeIndex));
          });
          return Future.value(false);
        },
        child: Consumer<UserViewModel>(builder: (context, userModel, child) {
          return ProviderWidget<ReceptionRoomViewModel>(
            builder: (context, vm, child) {
              return Column(
                children: [
                  _renderWidget(),
                  vm.isCommon ? _commonTabbar() : _selectionWidget(),
                  vm.isCommon
                      ? Expanded(child: _commonTabbarViewWidget(context))
                      : Expanded(child: _tabbarViewWidget())
                ],
              );
            },
            model: ReceptionRoomViewModel(
                userModel, widget.data['orderInfor'], widget.data['isCommon']),
            onModelReady: (vm) {
              _receptionRoomViewModel = vm;
              vm.videoHeight = getHeightPx(1334) - getWidthPx(400);
              vm.initData();
            },
          );
        }),
      ),
    );
  }

/**
 *  非简易模版构建的界面
 */
  //
  Widget _selectionWidget() {
    return _singleChildScrollViewWidget();
  }

  // SingleChildScrollView包装
  Widget _singleChildScrollViewWidget() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _receptionRoomViewModel.userInforList.map((e) {
              int index = _receptionRoomViewModel.userInforList.indexOf(e);
              return GestureDetector(
                onTap: () {
                  _receptionRoomViewModel.changeUserRole(index);
                  // pageController.animateToPage(index,
                  //     duration: Duration(microseconds: 300),
                  //     curve: Curves.bounceInOut);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "${e['userTypeName']}",
                    style: _receptionRoomViewModel.tabIndex == index
                        ? TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent)
                        : TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              );
            }).toList()),
      ),
    );
  }

  // tabbarView widget
  Widget _tabbarViewWidget() {
    if (_receptionRoomViewModel.userInforList.isEmpty) {
      return Container();
    } else {
      return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _receptionRoomViewModel.pageController,
        children: _receptionRoomViewModel.userInforList.map((e) {
          return _borrowerInformationWidget(e);
        }).toList(),
      );
    }
  }

  // 借款人信息界面
  Widget _borrowerInformationWidget(Map data) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        children: [
          _borrowerInformationView(data),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _gridView(),
          ),
        ],
      ),
    );
  }

  // 借款人信息widget
  Widget _borrowerInformationView(Map data) {
    return data.isEmpty
        ? SizedBox()
        : Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _borrowerCell(data["userTypeName"], data["userName"] ?? ''),
                _borrowerCell("身份证号码", data["idCard"] ?? ''),
                _borrowerCell("地址", data["address"] ?? ''),
                _borrowerCell("联系电话", data["phoneNumber"] ?? ''),
                /* data['otherField'] !=null && jsonDecode(data["otherField"]).isNotEmpty ?
                _borrowerCell(
                    "邮编", jsonDecode(data["otherField"])[0]["fieldCode"]) : Container(),*/
              ],
            ),
          );
  }

/**
  *  简易模版构建的模块
  */

  Widget _commonTabbar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _receptionRoomViewModel.commonUserList.map((e) {
              int index = _receptionRoomViewModel.commonUserList.indexOf(e);
              return GestureDetector(
                onTap: () {
                  _receptionRoomViewModel.changeUserRole(index);
                  // pageController.animateToPage(index,
                  //     duration: Duration(microseconds: 300),
                  //     curve: Curves.bounceInOut);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    e.bankUser ? "信贷人员" : "自然人${e.sort}",
                    style: _receptionRoomViewModel.tabIndex == index
                        ? TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent)
                        : TextStyle(fontSize: 15, color: Colors.black),
                  ),
                ),
              );
            }).toList()),
      ),
    );
  }

  Widget _commonTabbarViewWidget(BuildContext context) {
    if (_receptionRoomViewModel.commonUserList.isEmpty) {
      return Container();
    } else {
      return PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _receptionRoomViewModel.pageController,
        children: _receptionRoomViewModel.commonUserList.map((e) {
          return _commonUserWidget(context, e);
        }).toList(),
      );
    }
  }

  // 自然人信息widget
  Widget _commonUserWidget(
      BuildContext context, ReceptionCommonUserInformation model) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        children: [
          _selfItemWidget(model),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: _gridView(),
          ),
        ],
      ),
    );
  }

  // 自然人信息
  Widget _commonUserInforamtionWidget(BuildContext context, List data) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
          itemCount: data.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _selfItemWidget(data[index]);
          }),
    );
  }

  // 自然人Item
  Widget _selfItemWidget(ReceptionCommonUserInformation model) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, bottom: 10),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text(
                    model.bankUser ? '信贷人员' : '自然人',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
          _borrowerCell("姓名", model.userName),
          model.bankUser ? Container() : _borrowerCell("地址", model.address),
          _borrowerCell("身份证号码", model.idCard),
        ],
      ),
    );
  }

/**
 *  通用模块
 */

  // 视频widget
  Widget _renderWidget() {
    if (_receptionRoomViewModel.userList == null ||
        _receptionRoomViewModel.userList.isEmpty) {
      return SizedBox();
    } else {
      return GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, //每行三列
            childAspectRatio: 1.0, //显示区域宽高相等
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
          ),
          itemCount: _receptionRoomViewModel.userList.length,
          itemBuilder: (context, index) {
            // return videoVm.userList[index]['widget']!=null?videoVm.userList[index]['widget']:SizedBox();
            return Stack(
              children: [
                _receptionRoomViewModel.userList[index]['widget'] != null
                    ? _receptionRoomViewModel.userList[index]['widget']
                    : SizedBox(),
                _receptionRoomViewModel.userList[index]['userId'] ==
                        _receptionRoomViewModel.userViewModel.idCard
                    ? Positioned(
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            _receptionRoomViewModel.changeCamera();
                          },
                          child: Container(
                            color: Color(0x66ffffff),
                            child: Icon(Icons.autorenew),
                          ),
                        ),
                      )
                    : SizedBox(),
                _receptionRoomViewModel.userList[index]['userId'] ==
                        _receptionRoomViewModel.userViewModel.idCard
                    ? Positioned(
                        right: 0,
                        bottom: 0,
                        child: Icon(
                          !_receptionRoomViewModel.onMuteAudio
                              ? Icons.volume_up
                              : Icons.volume_off,
                          color: AppTheme.themeBlue,
                        ),
                      )
                    : SizedBox()
              ],
            );
          });
    }
  }

  // 借款人信息 cell
  Widget _borrowerCell(String key, String value) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Row(
        children: [
          Text(
            "$key: ",
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(
            width: 10.0,
          ),
          Expanded(
              child: Text(
            "$value",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ))
        ],
      ),
    );
  }

  // 图片widget
  Widget _gridView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text("上传补充材料(仅限图片)"),
        ),
        GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, //每行三列
              childAspectRatio: 1.0, //显示区域宽高相等
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: _receptionRoomViewModel.imgList.length + 1,
            itemBuilder: (context, index) {
              return releaseImage(
                  index == _receptionRoomViewModel.imgList.length,
                  index != _receptionRoomViewModel.imgList.length
                      ? _receptionRoomViewModel.imgList[index]
                      : null);
            }),
        SizedBox(
          height: MediaQuery.of(context).padding.bottom + 10,
        )
      ],
    );
  }

  // 图片item
  Widget releaseImage(bool isDef, Asset asset) {
    return isDef && _receptionRoomViewModel.showUpload
        ? InkWell(
            onTap: () {
              _receptionRoomViewModel.requestCameraPermission();
            },
            child: Image.asset("lib/assets/images/add_img.png"))
        : ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AssetThumb(
              asset: asset,
              width: 500,
              height: 500,
            ),
          );
  }
}
