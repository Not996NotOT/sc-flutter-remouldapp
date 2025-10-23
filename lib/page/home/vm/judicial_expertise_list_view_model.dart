/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-10-23 11:23:42
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2023-12-12 10:04:17
 * @FilePath: /remouldApp/lib/page/home/vm/judicial_expertise_list_view_model.dart
 * @Description: 司法鉴定订单列表
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/default_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_pickers/time_picker/model/suffix.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/model/judicial_expertise_list_data_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../appTheme.dart';

class JudicialExpertiseListViewModel extends SingleViewStateModel {
  List<Records> dataSource = [];

  TextEditingController searchController = TextEditingController();

  RefreshController refreshController = RefreshController();

  // 筛选数据源
  List<String> dataList = ["车牌号", "当事人", "创建时间", '司法鉴定机构'];

  // 要筛选的数据
  String filterString = '车牌号';

  // 搜索框的placeHolder
  String filterPlaceHolder = '请输入车牌号';

  bool turn = false;

  int currentPage = 1;

  int pageSize = 10;

  bool isInit = false;

  String searchText = '';

  JudicialExpertiseListViewModel();

  FocusNode focusNode = FocusNode();

  bool hasFocus = false;

  @override
  Future loadData() {
    //输入框焦点监测
    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        print('失去焦点');
        hasFocus = false;
      } else {
        if (searchController.text.length > 0) {
          hasFocus = true;
        }
        print('得到焦点');
      }
      notifyListeners();
    });
    getOrderData();
    // getSelectAllTop();
    // throw UnimplementedError();
  }

  // 切换筛选条件
  changeFilterCondition(BuildContext context) {
    turn = true;
    notifyListeners();
    showFiltrateAlertWidget(context);
  }

  // void getSelectAllTop() async {
  //   HomeApi.getSingleton().getSelectAllTopWithHeaderToken({'keyword': 'judicialLottery'},G.userToken).then((value) {
  //     if (value["code"] == 200) {
  //       if (value['data'] != null) {
  //         HomeApi.getSingleton().selectPageWithHeaderToken({"currentPage":1,"pageSize":50,"unitGuid":value['data'][0]["unitGuid,"]}, G.userToken).then((value){
  //           judicialLotteryStateModel = JudicialLotteryStateModel.fromJson(value);
  //         });
  //       }
  //     }
  //   });
  // }

  // 界面跳转
  void jumpIntoOtherWidget(Records records) {
    print("该方法是否被调用");
    if (records.status == "2") {
      updateOrderInformation(records);
      Navigator.pushNamed(G.getCurrentContext(), RoutePaths.caseHandleShowPDF,arguments: {
        'fileId': records.notificationFileId,
        'unitGuid': records.unitGuid,
        "unionnotaritionid":records.unionNotaritionId,
        "userName": records.whetherDelegate ==1 ? records.principalName : records.name,
        "idCard":records.whetherDelegate ==1 ? records.principalIdCard:records.idCard,
        "money":records.money,
        "payStatus":records.payStatus,
        "isOnlinePay":records.isOnlinePay,
        "notaryName":records.notaryName,
      }).then((value) => getOrderData());
    } else if (records.status == "3") {
      // // 开始录屏
      // String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      // Permission.microphone.request().isGranted.then((value){
      //   if(value){
      //     EasyLoading.show(status: "录屏即将开始");
      //     FlutterScreenRecording.startRecordScreenAndAudio(fileName).then((data) {
      //       print("started-------$data");
      //       if (data) {
      //         Future.delayed(const Duration(seconds: 2), () {
      //           EasyLoading.dismiss();
      //           G.pushNamed(RoutePaths.notaryExtractWidget, arguments: {
      //             'unitGuid': records.unitGuid,
      //             'unionnotaritionid': records.unionNotaritionId
      //           });
      //         });
      //       } else {
      //         EasyLoading.dismiss();
      //       }
      //     });
      //
      //   }else{
      //     EasyLoading.dismiss();
      //     G.showPermissionDialog(str: '麦克风');
      //   }
      // });
      updateOrderInformation(records);
      Navigator.pushNamed(G.getCurrentContext(), RoutePaths.caseHandleShowPDF,arguments: {
        'fileId': records.notificationFileId,
        'unitGuid': records.unitGuid,
        "unionnotaritionid":records.unionNotaritionId,
        "userName": records.whetherDelegate ==1 ? records.principalName : records.name,
        "idCard":records.whetherDelegate ==1 ? records.principalIdCard:records.idCard,
        "money":records.money,
        "payStatus":records.payStatus,
        "isOnlinePay":records.isOnlinePay,
        "notaryName":records.notaryName,
      }).then((value) => getOrderData());
    } else {
      // G.pushNamed(RoutePaths.cashierDesk,arguments: {'money':"200","orderNumber":records.unitGuid});
      G.pushNamed(RoutePaths.caseDetailWidget, arguments: {"model": records});
    }
  }

  // 更新订单数据
  void updateOrderInformation(Records recordss) {
    Map data = {
      'unitGuid': recordss.unitGuid,
      'accepanceFileId': G.indentyId,
    };
    HomeApi.getSingleton().updateOrderWithUserIndenty(data, errorCallBack: (e) {
      EasyLoading.dismiss();
    }).then((value) {});
  }

  // 时间选择器
  void selectTimer(BuildContext context) {
    Pickers.showDatePicker(
      context,
      // 模式，详见下方
      mode: DateMode.YMDHMS,
      // 后缀 默认Suffix.normal()，为空的话Suffix()
      suffix: Suffix(hours: '小时', minutes: '分钟', seconds: '秒'),
      // 样式  详见下方样式
      pickerStyle: DefaultPickerStyle(),
      // 默认选中
      selectDate: PDuration(
          year: DateTime.now().year,
          month: DateTime.now().month,
          day: DateTime.now().month,
          hour: DateTime.now().hour,
          minute: DateTime.now().minute,
          second: DateTime.now().second),
      minDate: PDuration(
          year: 1970, month: 1, day: 1, hour: 0, minute: 0, second: 0),
      maxDate: PDuration(
          year: 2500, month: 1, day: 1, hour: 0, minute: 0, second: 0),
      onConfirm: (p) {
        print('longer >>> 返回数据：$p');
        String timerString = '';
        if (p != null) {
          if (p.month < 10) {
            timerString = "${p.year}-0${p.month}";
          } else {
            timerString = "${p.year}-${p.month}";
          }
          if (p.day < 10) {
            timerString = "$timerString-0${p.day}";
          } else {
            timerString = "$timerString-${p.day}";
          }
          if (p.hour < 10) {
            timerString = "$timerString 0${p.hour}";
          } else {
            timerString = "$timerString ${p.hour}";
          }
          if (p.minute < 10) {
            timerString = "$timerString:0${p.minute}";
          } else {
            timerString = "$timerString:${p.minute}";
          }
          if (p.second < 10) {
            timerString = "$timerString:0${p.second}";
          } else {
            timerString = "$timerString:${p.second}";
          }
          searchText = timerString;
          searchController.text = timerString;
        }
      },
      // onChanged: (p) => print(p),
    );
  }

  // 获取订单数据

  getOrderData() {
    Map<String, dynamic> data = {
      'pageSize': pageSize,
      'currentPage': currentPage,
      'use': 1,
      'name': G.userName,
      'idCard': G.userIdCard,
    };
    if (filterString == '车牌号' && searchText.replaceAll(' ', "").isNotEmpty) {
      data['caseNumber'] = searchText.replaceAll(' ', "");
    }
    // else if(filterString == '当事人' && searchText.isNotEmpty){
    //   data['name'] = searchText;
    // }else if(filterString == '创建时间' && searchText.isNotEmpty){
    //   data['createDate'] = searchText;
    // }else if(filterString == '司法鉴定机构' && searchText.isNotEmpty){
    //   data['inusureNotaritionName'] = searchText;
    // }
    EasyLoading.show(status: "列表加载中...");
    HomeApi.getSingleton().appraiseOrderSelectOrder(data,
        errorCallBack: (error) {
      EasyLoading.dismiss();
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      isInit = true;
      if (currentPage == 1) {
        refreshController.refreshFailed();
      } else {
        currentPage--;
        refreshController.loadFailed();
      }
      notifyListeners();
    }).then((value) {
      isInit = true;
      EasyLoading.dismiss();
      if (value['success']) {
        JudicialExpertiseListDataModel model =
            JudicialExpertiseListDataModel.fromJson(value);
        if (model != null && model.code == 200) {
          if (model.data != null) {
            if (currentPage == 1) {
              dataSource.clear();
            }
            if (model.data.records != null && model.data.records.isNotEmpty) {
              dataSource.addAll(model.data.records);
              if (currentPage == 1) {
                if (dataSource.length == model.data.total) {
                  refreshController.refreshCompleted();
                  refreshController.loadNoData();
                } else {
                  refreshController.refreshCompleted();
                }
              } else {
                if (dataSource.length == model.data.total) {
                  refreshController.loadNoData();
                } else {
                  refreshController.loadComplete();
                }
              }
            } else {
              if (currentPage == 1) {
                if (dataSource.length == model.data.total) {
                  refreshController.refreshCompleted();
                  refreshController.loadNoData();
                } else {
                  refreshController.refreshCompleted();
                }
              } else {
                if (dataSource.length == model.data.total) {
                  refreshController.loadNoData();
                } else {
                  refreshController.loadComplete();
                }
              }
            }
          } else {
            refreshController.loadNoData();
          }
        } else {
          if (currentPage == 1) {
            refreshController.refreshFailed();
          } else {
            currentPage--;
            refreshController.loadFailed();
          }
          ToastUtil.showErrorToast(
              "${value['message'] ?? value['msg'] ?? value['data']}");
        }
      } else {
        if (currentPage == 1) {
          refreshController.refreshFailed();
        } else {
          currentPage--;
          refreshController.loadFailed();
        }
      }

      notifyListeners();
    });
  }

  // 刷新数据
  refresh() {
    currentPage = 1;
    refreshController.resetNoData();
    getOrderData();
  }

  // 加载更多
  loadMore() {
    currentPage++;
    getOrderData();
  }

  @override
  onCompleted(data) {
    // throw UnimplementedError();
  }

  // 显示筛选的弹窗
  showFiltrateAlertWidget(BuildContext context1) {
    showCupertinoDialog(
        context: context1,
        barrierDismissible: true,
        builder: (context) {
          return Material(
            color: Colors.transparent,
            child: StatefulBuilder(builder: (context, myState) {
              return Column(
                children: [
                  const Spacer(),
                  Container(
                    height: 300,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        )),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  G.pop();
                                  turn = false;
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: Text(
                                    '取消',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppTheme.bg_f,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  G.pop();
                                  turn = false;
                                  if (filterString == '车牌号') {
                                    filterPlaceHolder = "请输入车牌号";
                                  } else if (filterString == "当事人") {
                                    filterPlaceHolder = "请输入当事人姓名";
                                  } else if (filterString == "创建时间") {
                                    filterPlaceHolder = "请输入案件创建时间";
                                    selectTimer(context1);
                                  } else if (filterString == "司法鉴定机构") {
                                    filterPlaceHolder = "请输入司法鉴定机构名称";
                                  }
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                  child: Text(
                                    '确定',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: AppTheme.themeBlue,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        MediaQuery.removePadding(
                          context: context,
                          removeTop: true,
                          child: ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: dataList.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    myState(() {
                                      filterString = dataList[index];
                                    });
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    child: Column(
                                      children: [
                                        Text(
                                          dataList[index],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: filterString ==
                                                      dataList[index]
                                                  ? AppTheme.themeBlue
                                                  : AppTheme.textBlack),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        });
  }
}
