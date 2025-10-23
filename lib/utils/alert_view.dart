import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/account_api.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock/wakelock.dart';

import 'common_tools.dart';
import 'event_bus_instance.dart';

class AlertView {
  ///预选房号的底部弹框
  ///@param context 上下文
  ///@param data 数据源
  static showSelectRoomBottomView(
      BuildContext context, List data, Function callback) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return _SelectRoomWidget(data: data, callBack: callback);
        });
  }

  /// 选房超时退出APP

  static showExitApp(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(
                  horizontal: 60.0,
                  vertical: (MediaQuery.of(context).size.height - 200) / 2),
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
                    child: Text('抱歉，您已超时！',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                  Expanded(child: SizedBox()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            '退出APP',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          exit(0);
                        },
                      ),
                      SizedBox(
                        width: 30.0,
                      ),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 5.0),
                          decoration: BoxDecoration(
                              color: AppTheme.textBlue,
                              borderRadius: BorderRadius.circular(8.0)),
                          child: Text(
                            '返回首页',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              RoutePaths.HomeIndex, (route) => false);
                        },
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ));
        });
  }

  static showPhoneAreaAlert(
      BuildContext context, List data, Function onSelectedItemChanged) {
    String selectValue = data[0];
    if (data == null || data.isEmpty) {
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text('取消'),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (selectValue.isEmpty) {
                          EasyLoading.show(status: "请选择区号");
                          return;
                        }
                        Navigator.pop(context);
                        onSelectedItemChanged(selectValue);
                      },
                      child: Text('确定'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      selectValue = data[index];
                    },
                    children: data
                        .map((e) => Center(
                              child: Text(
                                '+ $e',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ))
                        .toList()),
              ),
            ],
          ),
        );
      },
    );
  }

  static showPickerViewAlert(
      BuildContext context, List data, Function onSelectedItemChanged) {
    String selectValue = data[0];
    if (data == null || data.isEmpty) {
      return;
    }
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: 200),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Text('取消'),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        if (selectValue.isEmpty) {
                          EasyLoading.show(status: "数据不能为空");
                          return;
                        }
                        Navigator.pop(context);
                        onSelectedItemChanged(selectValue);
                      },
                      child: Text('确定'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: CupertinoPicker(
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      selectValue = data[index];
                    },
                    children: data
                        .map((e) => Center(
                              child: Text(
                                '$e',
                                style: TextStyle(
                                    fontSize: 15, color: Colors.black),
                              ),
                            ))
                        .toList()),
              ),
            ],
          ),
        );
      },
    );
  }

  // 城市选择器
  static showCityPickerView(BuildContext context,
      {Function resultCallBack, String locationCode}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 400),
          child: Container(
            color: Colors.red,
            child: CityPickerView(
              locationCode: locationCode,
              onResult: (res) {
                wjPrint(res.toJson());
                if (resultCallBack != null) {
                  resultCallBack(res);
                }
              },
            ),
          ),
        );
      },
    );
  }
}

///预选房号的底部弹框 widget
// ignore: must_be_immutable
class _SelectRoomWidget extends StatefulWidget {
  List data;
  Function callBack;
  _SelectRoomWidget({Key key, this.data, this.callBack}) : super(key: key);

  @override
  State<_SelectRoomWidget> createState() => __SelectRoomWidgetState();
}

class __SelectRoomWidgetState extends BaseState<_SelectRoomWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getWidthPx(720),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10.0),
            topRight: Radius.circular(10.0),
          )),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 20.0, bottom: 10.0),
            child: Text(
              '您可直接选择预选的房号',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Container(
                  alignment: Alignment.center,
                  child: GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10.0),
                      alignment: Alignment.center,
                      width: 180,
                      height: 40.0,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 10.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[200], width: 0.5),
                        borderRadius: BorderRadius.circular(10.0),
                        color: widget.data[index]['isSelected']
                            ? AppTheme.textBlue
                            : Colors.white,
                      ),
                      child: Text(
                        widget.data[index]['name'],
                        style: TextStyle(
                          fontSize: 16.0,
                          color: widget.data[index]["isSelected"]
                              ? Colors.white
                              : AppTheme.textBlue,
                        ),
                      ),
                    ),
                    onTap: () {
                      widget.data.forEach((element) {
                        element['isSelected'] = false;
                        if (element['id'] == widget.data[index]['id']) {
                          element['isSelected'] = true;
                        }
                        setState(() {});
                      });
                    },
                  ),
                );
              },
              itemCount: widget.data.length,
            ),
          )),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Center(
              child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 20.0),
                  decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.textBlue, width: 0.5),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Text(
                    "放弃预选房号，重新选择",
                    style: TextStyle(
                      fontSize: 16.0,
                      color: AppTheme.textBlue,
                    ),
                  )),
            ),
          ),
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).padding.bottom),
              color: AppTheme.textBlue,
              alignment: Alignment.center,
              height: getWidthPx(100) + MediaQuery.of(context).padding.bottom,
              child: Text(
                '确认',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              widget.data.forEach((element) {
                if (element['isSelected']) {
                  widget.callBack(element);
                }
              });
            },
          ),
        ],
      ),
    );
  }
}

// 城市选择
typedef ResultBlock = void Function(CityResult result);

class CityPickerView extends StatefulWidget {
  // 结果返回
  final ResultBlock onResult;
  String locationCode;
  CityPickerView({this.onResult, this.locationCode});
  @override
  _CityPickerViewState createState() => _CityPickerViewState();
}

class _CityPickerViewState extends State<CityPickerView> {
  List<ProvinceModelClass> datas = [];
  int provinceIndex;
  int cityIndex;
  int areaIndex;

  FixedExtentScrollController provinceScrollController;
  FixedExtentScrollController cityScrollController;
  FixedExtentScrollController areaScrollController;

  CityResult result = CityResult();

  bool isShow = false;

  List<ProvinceModelClass> get provinces {
    if (datas.length > 0) {
      if (provinceIndex == null) {
        provinceIndex = 0;
        result.province = provinces[provinceIndex].name;
        result.provinceCode = provinces[provinceIndex].id.toString();
      }
      return datas;
    }
    return [];
  }

  List<CityModelClass> get citys {
    if (provinces.length > 0) {
      return provinces[provinceIndex].treeChild ?? [];
    }
    return [];
  }

  List<AreaModelClass> get areas {
    if (citys.length > 0) {
      if (cityIndex == null) {
        cityIndex = 0;
        result.city = citys[cityIndex].name;
        result.cityCode = citys[cityIndex].id.toString();
      }
      List<AreaModelClass> list = citys[cityIndex].treeChild ?? [];
      if (list.length > 0) {
        if (areaIndex == null) {
          areaIndex = 0;
          result.area = list[areaIndex].name;
          result.areaCode = list[areaIndex].id.toString();
        }
      }
      return list;
    }
    return [];
  }

  // 保存选择结果
  _saveInfoData() {
    var prs = provinces;
    var cts = citys;
    var ars = areas;
    if (provinceIndex != null && prs.length > 0) {
      result.province = prs[provinceIndex].name;
      result.provinceCode = prs[provinceIndex].id.toString();
    } else {
      result.province = '';
      result.provinceCode = '';
    }

    if (cityIndex != null && cts.length > 0) {
      result.city = cts[cityIndex].name;
      result.cityCode = cts[cityIndex].id.toString();
    } else {
      result.city = '';
      result.cityCode = '';
    }

    if (areaIndex != null && ars.length > 0) {
      result.area = ars[areaIndex].name;
      result.areaCode = ars[areaIndex].id.toString();
    } else {
      result.area = '';
      result.areaCode = '';
    }
  }

  @override
  void dispose() {
    provinceScrollController.dispose();
    cityScrollController.dispose();
    areaScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    //初始化控制器
    provinceScrollController = FixedExtentScrollController();
    cityScrollController = FixedExtentScrollController();
    areaScrollController = FixedExtentScrollController();

    //读取city.json数据
    _loadCitys();
  }

  Future _loadCitys() async {
    final response = await HomeApi.getSingleton().getProvinceAndCiteMessage(2,
        errorCallBack: (msg) {
      ToastUtil.showErrorToast(msg.toString());
    });
    if (response['code'] == 200) {
      if (response['data'] != null && response['data'].isNotEmpty) {
        try {
          datas = response['data']
              .map<ProvinceModelClass>((e) => ProvinceModelClass.fromMap(e))
              .toList();
          if (widget.locationCode != null && widget.locationCode.isNotEmpty) {
            ;
            datas.forEach((element) {
              element.treeChild.forEach((element1) {
                if (element1.id.toString() == widget.locationCode) {
                  cityIndex = element.treeChild.indexOf(element1);
                  provinceIndex = datas.indexOf(element);
                  result.province = element.name;
                  result.provinceCode = element.id.toString();
                  result.city = element1.name;
                  result.cityCode = element1.id.toString();
                  cityScrollController =
                      FixedExtentScrollController(initialItem: cityIndex);
                  provinceScrollController =
                      FixedExtentScrollController(initialItem: provinceIndex);
                  setState(() {});
                }
              });
            });
          }
        } catch (e) {
          wjPrint("报错信息：$e");
        }
      } else {
        datas = [];
      }
      setState(() {
        isShow = true;
      });
    } else {
      ToastUtil.showErrorToast("获取城市信息失败");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _firstView(),
            _contentView(),
          ],
        ),
      ),
    );
  }

  Widget _firstView() {
    return Container(
      height: 44,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: Text('取消'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('确定'),
              onPressed: () {
                if (widget.onResult != null) {
                  widget.onResult(result);
                }
                Navigator.pop(context);
              },
            ),
          ]),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(color: Colors.grey.withOpacity(0.1), width: 1)),
      ),
    );
  }

  Widget _contentView() {
    return Container(
      // color: Colors.orange,
      height: 300,
      child: isShow
          ? Row(
              children: <Widget>[
                Expanded(child: _provincePickerView()),
                Expanded(child: _cityPickerView()),
                // Expanded(child: _areaPickerView()),
              ],
            )
          : Center(
              child: CupertinoActivityIndicator(
                animating: true,
              ),
            ),
    );
  }

  Widget _provincePickerView() {
    return Container(
      child: CupertinoPicker(
        scrollController: provinceScrollController,
        children: provinces.map((item) {
          return Center(
            child: Text(
              item.name,
              style: TextStyle(color: Colors.black87, fontSize: 16),
              maxLines: 1,
            ),
          );
        }).toList(),
        onSelectedItemChanged: (index) {
          provinceIndex = index;
          if (cityIndex != null) {
            cityIndex = 0;
            if (cityScrollController.positions.length > 0) {
              cityScrollController.jumpTo(0);
            }
          }
          if (areaIndex != null) {
            areaIndex = 0;
            if (areaScrollController.positions.length > 0) {
              areaScrollController.jumpTo(0);
            }
          }
          _saveInfoData();
          setState(() {});
        },
        itemExtent: 36,
      ),
    );
  }

  Widget _cityPickerView() {
    return Container(
      child: citys.length == 0
          ? Container()
          : CupertinoPicker(
              scrollController: cityScrollController,
              children: citys.map((item) {
                return Center(
                  child: Text(
                    item.name,
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    maxLines: 1,
                  ),
                );
              }).toList(),
              onSelectedItemChanged: (index) {
                cityIndex = index;
                if (areaIndex != null) {
                  areaIndex = 0;
                  if (areaScrollController.positions.length > 0) {
                    areaScrollController.jumpTo(0);
                  }
                }
                _saveInfoData();
                setState(() {});
              },
              itemExtent: 36,
            ),
    );
  }

  Widget _areaPickerView() {
    return Container(
      width: double.infinity,
      child: areas.length == 0
          ? Container()
          : CupertinoPicker(
              scrollController: areaScrollController,
              children: areas.map((item) {
                return Center(
                  child: Text(
                    item.name,
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                    maxLines: 1,
                  ),
                );
              }).toList(),
              onSelectedItemChanged: (index) {
                areaIndex = index;
                _saveInfoData();
                setState(() {});
              },
              itemExtent: 36,
            ),
    );
  }
}

class ProvinceModelClass {
  // 省、市、区id
  int id;
  // 省、市、区名称
  String name;
  // 省、市、区 拼写
  String alpha;
  // 包含的三级区域
  List<CityModelClass> treeChild;

  ProvinceModelClass.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alpha = json['alpha'];
    if (json['treeChild'] != null && json['treeChild'].isNotEmpty) {
      treeChild = (json['treeChild'] as List)
          .map((e) => CityModelClass.fromMap(e))
          .toList();
    } else {
      treeChild = [];
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['alpha'] = alpha;
    if (treeChild.isEmpty) {
      data['treeChild'] = [];
    } else {
      data['treeChild'] = treeChild.map((e) => e.toMap());
    }
    return data;
  }
}

class CityModelClass {
  // 省、市、区id
  int id;
  // 省、市、区名称
  String name;
  // 省、市、区 拼写
  String alpha;
  // 包含的三级区域
  List<AreaModelClass> treeChild;

  CityModelClass.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alpha = json['alpha'];
    if (json['treeChild'] != null && json['treeChild'].isNotEmpty) {
      treeChild = (json['treeChild'] as List)
          .map((e) => AreaModelClass.fromMap(e))
          .toList();
    } else {
      treeChild = [];
    }
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['alpha'] = alpha;
    if (treeChild.isEmpty) {
      data['treeChild'] = [];
    } else {
      data['treeChild'] = treeChild.map((e) => e.toMap());
    }
    return data;
  }
}

class AreaModelClass {
  // 省、市、区id
  int id;
  // 省、市、区名称
  String name;
  // 省、市、区 拼写
  String alpha;

  AreaModelClass.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    alpha = json['alpha'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};
    data['id'] = id;
    data['name'] = name;
    data['alpha'] = alpha;
    return data;
  }
}

class CityResult {
  String province;
  String provinceCode;
  String city;
  String cityCode;
  String area;
  String areaCode;
  CityResult(
      {this.province,
      this.provinceCode,
      this.city,
      this.cityCode,
      this.area,
      this.areaCode});

  CityResult.fromJson(Map<String, dynamic> json) {
    province = json['province'];
    city = json['city'];
    area = json['area'];
    provinceCode = json['provinceCode'];
    cityCode = json['cityCode'];
    areaCode = json['areaCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> datas = new Map<String, dynamic>();
    datas['province'] = this.province;
    datas['city'] = this.city;
    datas['area'] = this.area;
    datas['provinceCode'] = this.provinceCode;
    datas['cityCode'] = this.cityCode;
    datas['areaCode'] = this.areaCode;

    return datas;
  }
}

/// 复制链接弹框
void showCopyLinkAlert({BuildContext context, String url, Function onConfirm}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.symmetric(horizontal: 52),
                padding: EdgeInsets.only(left: 15, right: 15),
                height: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "选择直接下载或复制链接",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      "前往浏览器进行下载 \n 链接有效期为一天",
                      style: TextStyle(fontSize: 16),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 150),
                      child: Text("$url",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 16)),
                    ),
                    const Spacer(),
                    const Divider(),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                                onConfirm();
                              },
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text('直接下载',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.themeBlue)),
                                ),
                              ),
                            ),
                          ),
                          const VerticalDivider(
                            width: 1,
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () {
                                ToastUtil.showToast('复制成功', gravity: 'center');
                                Clipboard.setData(ClipboardData(text: url));
                                Navigator.pop(context);
                              },
                              child: Center(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 15),
                                  child: Text('复制链接',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: AppTheme.themeBlue)),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 32),
                child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Image.asset(
                      "lib/assets/images/close_circle_white.png",
                      width: 32,
                      height: 32,
                    )),
              )
            ],
          ),
        );
      });
}

enum DownloadType {
  electronicNotarialFileDownload,
  fileDownload,
}

/// 下载文件弹框没有暂停按钮
void showDownloadFileNoPauseAlert(
    {String url,
    int fileSize,
    String name,
    DownloadType type,
    String fileName}) async {
  if (!await Permission.storage.status.isGranted) {
    G.showCustomToast(
      context: G.getCurrentState().overlay.context,
      titleText: "文件存储权限使用说明：",
      subTitleText: "用于文件存储等场景",
      time: 2,
    );
  }
  if (await Permission.storage.request().isGranted) {
    showDialog(
        barrierDismissible: false,
        context: G.getCurrentContext(),
        builder: (context) {
          return Center(
            child: DialogNoPauseProcessWidget(
              videoUrl: url,
              fileSize: fileSize,
              name: name,
              fileName: fileName,
              type: type ?? DownloadType.fileDownload,
            ),
          );
        });
  } else {
    G.showPermissionDialog(str: '访问内部存储全权限');
  }
}

class DialogNoPauseProcessWidget extends StatefulWidget {
  String videoUrl;
  int fileSize;
  String name;
  String fileName;
  DownloadType type;

  DialogNoPauseProcessWidget(
      {Key key,
      this.videoUrl,
      this.fileSize,
      this.type = DownloadType.fileDownload,
      this.name,
      this.fileName})
      : super(key: key);

  @override
  State<DialogNoPauseProcessWidget> createState() =>
      _DialogNoPauseProcessWidgetState();
}

class _DialogNoPauseProcessWidgetState
    extends State<DialogNoPauseProcessWidget> {
  double process = 0;

  String path = '';
  CancelToken cancelToken = CancelToken();

  int total = 0;
  int received = 0;

  int mFileSize = 0;

  String newFileName = '';

  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    mFileSize = caculateKBSize(widget.fileSize);
    initData();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
    // DownloadManager.instance.dispose();
  }

  Future<void> downloadFile({
    String url,
    String savePath,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
    void Function() done,
    void Function(Exception) failed,
  }) async {
    final downloadDio = Dio();
    int downloadStart = 0;
    File f = File(savePath);
    if (f.existsSync()) {
      // 文件存在时拿到已下载的字节数
      downloadStart = f.lengthSync();
    }
    wjPrint("start: $downloadStart");
    try {
      Response response = await downloadDio.get<ResponseBody>(url,
          options: Options(
            /// Receive response data as a stream
            responseType: ResponseType.stream,
            followRedirects: false,
            headers: {
              /// 加入range请求头，实现断点续传
              "range": "bytes=$downloadStart-",
            },
          ),
          cancelToken: cancelToken);
      RandomAccessFile raf = f.openSync(mode: FileMode.append);
      int received = downloadStart;
      total = int.parse(response.data.headers['content-length'][0]);
      wjPrint('total-----$total');
      setState(() {});
      Stream<Uint8List> stream = response.data.stream;
      StreamSubscription<Uint8List> subscription;
      subscription = stream.listen(
        (data) {
          /// Write files must be synchronized
          raf.writeFromSync(data);
          received += data.length;
          process = received / (widget.fileSize * 1024);
          setState(() {});
          wjPrint("received-----$received");
          onReceiveProgress?.call(received, total);
        },
        onDone: () async {
          f.rename(savePath.replaceAll('.temp', ''));
          await raf.close();
          await subscription?.cancel();
          wjPrint(
              "文件是否存在------${File(savePath.replaceAll('.temp', '')).existsSync()}");
          wjPrint("文件路径------${savePath.replaceAll('.temp', '')}");
          done?.call();
          G.pop();
          downloadFinishAlert();
        },
        onError: (e) async {
          await raf.close();
          await subscription?.cancel();
          ToastUtil.showErrorToast('下载失败');
          G.pop();
          failed?.call(e);
        },
        cancelOnError: true,
      );
      cancelToken.whenCancel.then((_) async {
        await subscription?.cancel();
        await raf.close();
        wjPrint("取消下载了！");
      });
    } on DioError catch (error) {
      if (CancelToken.isCancel(error)) {
        wjPrint("Download cancelled");
      } else {
        failed?.call(error);
        G.pop();
        ToastUtil.showErrorToast('下载失败');
      }
    }
  }

  initData() async {
    var dir;
    String dirPath;
    if (Platform.isIOS) {
      dir = await getApplicationDocumentsDirectory();
      dirPath = dir.path;
    } else if (Platform.isAndroid) {
      dir = await getExternalStorageDirectory();
      dirPath = dir.path;
    }
    Directory directory = Directory("${dirPath}/downloads");
    var fileType = '';
    try {
      if (widget.type == DownloadType.fileDownload) {
        final fileUrl = widget.videoUrl.split('?')[0];
        final filename = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);
        fileType =
            filename.substring(filename.lastIndexOf("."), filename.length);
        newFileName = "${widget.fileName}$fileType";
      } else {
        newFileName = "${widget.fileName}.zip";
      }

      if (directory.existsSync()) {
        path = "${directory.path}/$newFileName.temp";
      } else {
        directory.createSync();
        path = "${directory.path}/$newFileName.temp";
      }
      if (await Wakelock.enabled) {
        await downloadFile(
            url: widget.videoUrl, savePath: path, cancelToken: cancelToken);
      } else {
        await Wakelock.enable();
        await downloadFile(
            url: widget.videoUrl, savePath: path, cancelToken: cancelToken);
      }
    } catch (e) {
      wjPrint('下载视频时抛出的错误：$e');
      // DownloadManager.instance.dispose();
    }
  }

  // 下载完成弹框
  void downloadFinishAlert() {
    showDialog(
        context: G.getCurrentContext(),
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: Container(
              width: 300,
              height: 260,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 15),
                    child: Image.asset(
                      'lib/assets/images/check_fill_green.png',
                      width: 36,
                      height: 36,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    '下载完成',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30),
                    child: Row(
                      children: const [
                        Text('文件位置：'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 30, right: 30),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          Platform.isIOS
                              ? '文件/青桐智盒/downloads/$newFileName'
                              : "文件管理/Android/data/com.njguochu.qingtongzhihe/files/downloads/$newFileName",
                          maxLines: 5,
                        )),
                      ],
                    ),
                  ),
                  const Spacer(),
                  const Divider(),
                  GestureDetector(
                    onTap: () {
                      G.pop();
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                        width: double.infinity,
                        color: Colors.white,
                        alignment: Alignment.center,
                        child: Text(
                          '确认',
                          style: TextStyle(
                              fontSize: 17,
                              color: AppTheme.themeBlue,
                              fontWeight: FontWeight.w600),
                        )),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 280,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            '下载中',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Row(
              children: [
                Expanded(
                    child: LinearProgressIndicator(
                  value: process,
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(AppTheme.themeBlue),
                )),
                SizedBox(
                  width: 10,
                ),
                Text(
                  '${(process * 100).toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 14),
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text(
              '文件总大小${mFileSize.toStringAsFixed(1)}M,已下载${(mFileSize * process).toStringAsFixed(0)}M',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Divider(),
          GestureDetector(
            onTap: () {
              cancelToken.cancel();
              G.pop();
              if (File(path).existsSync()) {
                File(path).deleteSync();
              }
            },
            child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppTheme.white,
              ),
              child: Text(
                '取消',
                style: TextStyle(fontSize: 17, color: AppTheme.themeBlue),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// 弹出对话框
Future<bool> showDownloadApkProgress(BuildContext context) {
  return showDialog<bool>(
    barrierDismissible: false,
    context: context,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return Future.value(false);
        },
        child: DownloadApkProgress(),
      );
    },
  );
}

class DownloadApkProgress extends StatefulWidget {
  const DownloadApkProgress({Key key}) : super(key: key);

  @override
  State<DownloadApkProgress> createState() => _DownloadApkProgressState();
}

class _DownloadApkProgressState extends State<DownloadApkProgress> {
  int progress = 0;

  StreamSubscription streamSubscription;

  @override
  void initState() {
    super.initState();
    streamSubscription = eventBus.on().listen((event) {
      if (event['name'] == "downloadApkCallback") {
        if (mounted) {
          setState(() {
            progress = event['progress'];
          });
        }
        Future.delayed(const Duration(milliseconds: 200), () {
          if (progress == 100) {
            Navigator.pop(context);
            streamSubscription.cancel();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: 80,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.white),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("更新中..."),
            ),
            Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation(AppTheme.themeBlue),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text("$progress%")
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// 案件退出提示弹框

showLogoutCaseAlert(BuildContext context, {Function decideFunction}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Material(
            color: Colors.green.withAlpha(10),
            child: Center(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 45),
                    padding: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 30,
                          bottom: 15,
                        ),
                        child: Image.asset(
                          "lib/assets/images/error_blue.png",
                          width: 53,
                          height: 53,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          '是否确认取消本次案件办理？',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 16, bottom: 25, left: 40, right: 40),
                        child: Text(
                          '取消后案件变为终止状态，可重新开始',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF454545)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                G.pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xFFEBEBEB),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  '取消',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                decideFunction();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    color: AppTheme.themeBlue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  '确定',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppTheme.white),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ]))));
      });
}

// 录屏是提示弹框
showRecordAlert(BuildContext context,
    {Function decideFunction, Function cancelFunction}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Material(
            color: Colors.green.withAlpha(10),
            child: Center(
                child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 45),
                    padding: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          '提示',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            top: 16, bottom: 25, left: 40, right: 40),
                        child: Text(
                          '摇号过程，我们将全程录音录屏，并上传到服务器，请同意系统的录屏弹框权限!',
                          textAlign: TextAlign.center,
                          style:
                              TextStyle(fontSize: 14, color: Color(0xFF454545)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                cancelFunction.call();
                                G.pop();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xFFEBEBEB),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  '取消',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                decideFunction();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                    color: AppTheme.themeBlue,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  '确定',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: AppTheme.white),
                                ),
                              ),
                            ),
                          )
                        ]),
                      ),
                    ]))));
      });
}

//图形验证码弹框
showCaptchaCodeAlert(
    {BuildContext context,
    Map<String, dynamic> imageData,
    bool isForgetPassword,
    Function confirmEvent,
    Function cancelEvent,
    Function errorCallBack,
    Function successCallBack,
    Function failCallBack}) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
            child: Material(
                color: Colors.transparent,
                child: CaptchaCodeView(
                    imageData: imageData,
                    isForgetPassword: isForgetPassword,
                    confirmEvent: confirmEvent,
                    cancelEvent: cancelEvent,
                    errorCallBack: errorCallBack,
                    successCallBack: successCallBack,
                    failCallBack: failCallBack)),
            onWillPop: () async {
              return Future.value(false);
            });
      });
}

// 图形验证码弹框界面
class CaptchaCodeView extends StatefulWidget {
  final Map<String, dynamic> imageData;
  final bool isForgetPassword;
  final Function confirmEvent;
  final Function cancelEvent;
  final Function errorCallBack;
  final Function successCallBack;
  final Function failCallBack;
  CaptchaCodeView(
      {Key key,
      this.imageData,
      this.confirmEvent,
      this.cancelEvent,
      this.errorCallBack,
      this.successCallBack,
      this.failCallBack,
      this.isForgetPassword = true})
      : super(key: key);

  @override
  State<CaptchaCodeView> createState() => _CaptchaCodeViewState();
}

class _CaptchaCodeViewState extends State<CaptchaCodeView> {
  TextEditingController _controller = TextEditingController();

  String imageString = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isForgetPassword) {
      forgetPasswordGetCaptchaCode();
    } else {
      registerGetCaptchaCode();
    }
  }

  // 忘记密码部分获取图形验证码
  void forgetPasswordGetCaptchaCode() async {
    AccountApi.getSingleton().sendCaptchaCodeForget(widget.imageData,
        errorCallBack: (e) {
      ToastUtil.showWarningToast('获取图形验证码失败');
      widget.errorCallBack(e);
    }).then((value) {
      if (value != null) {
        widget.successCallBack(value);
        if (value != null && value['code'] == 200) {
          setState(() {
            imageString = value['data'];
          });
        }
      } else {
        widget.failCallBack();
        ToastUtil.showErrorToast(value['message']);
      }
    });
  }

  // 注册部分获取图形验证码
  void registerGetCaptchaCode() async {
    AccountApi.getSingleton().sendCaptchaCode(widget.imageData,
        errorCallBack: (e) {
      ToastUtil.showWarningToast('获取图形验证码失败');
      widget.errorCallBack(e);
      // abroadCodeCountDownIsEnable = true;
      // notifyListeners();
    }).then((value) {
      if (value != null) {
        widget.successCallBack(value);
        if (value['code'] == 200) {
          setState(() {
            imageString = value['data'];
          });
        }
      } else {
        widget.failCallBack();
        ToastUtil.showErrorToast(value['message']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Spacer(
          flex: 1,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.white),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('图形验证码',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        widget.cancelEvent();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey[200],
                        ),
                      ))
                ],
              ),
              Divider(
                height: 1,
                color: Colors.grey[200],
              ),
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    key:Key(imageString),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 20),
                    width: ScreenUtil.getInstance().screenWidth - 20,
                    child: imageString.isEmpty
                        ? const SizedBox()
                        : Image.memory(
                            base64Decode(imageString),
                            width: 100,
                            height: 40,
                            gaplessPlayback: true,
                          ),
                  ),
                  GestureDetector(
                      onTap: () {
                        if (widget.isForgetPassword) {
                          forgetPasswordGetCaptchaCode();
                        } else {
                          registerGetCaptchaCode();
                        }
                      },
                      child: Icon(
                        Icons.refresh,
                        color: Colors.grey[200],
                      ))
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "请输入图形验证码",
                        fillColor: Colors.grey[200],
                        filled: true,
                        hoverColor: Colors.grey[200],
                        hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                        isCollapsed: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      G.pop();
                      widget.confirmEvent(_controller.text);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                      decoration: BoxDecoration(
                          color: AppTheme.themeBlue,
                          borderRadius: BorderRadius.circular(8)),
                      child: Text(
                        '确定',
                        style: TextStyle(fontSize: 15, color: AppTheme.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Spacer(
          flex: 1,
        ),
      ],
    );
  }
}
