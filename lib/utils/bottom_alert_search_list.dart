import 'package:flutter/material.dart';
import 'package:lpinyin/lpinyin.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:notarization_station_app/utils/search_text.dart';

import 'common_tools.dart';

// ignore: must_be_immutable
class BottomAlertSearchList extends StatefulWidget {
  Function selectValueCallBack;
  String holderString;
  List<String> dataSource;
  BottomAlertSearchList(
      {Key key,
      this.selectValueCallBack,
      this.dataSource,
      this.holderString = '请输入你想搜索的国家/地区'})
      : super(key: key);

  @override
  State<BottomAlertSearchList> createState() => _BottomAlertSearchListState();
}

class _BottomAlertSearchListState extends State<BottomAlertSearchList>
    with WidgetsBindingObserver {
  List<String> tempData = [];

  String searchValue = '';

  List<String> saveData = [];

  /// 键盘的高度
  double keyboardHeight = 0.0;

  SearchTextController searchController = SearchTextController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    searchController.isActionShow = true;
    tempData.addAll(widget.dataSource);
    saveData.addAll(widget.dataSource);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // 键盘高度
    final double viewInsetsBottom = EdgeInsets.fromWindowPadding(
            WidgetsBinding.instance.window.viewInsets,
            WidgetsBinding.instance.window.devicePixelRatio)
        .bottom;

    wjPrint(viewInsetsBottom);

    setState(() {
      keyboardHeight = viewInsetsBottom;
    });
  }

  // 所搜结果
  void _search(value) {
    tempData.clear();
    wjPrint('saveData-------$saveData');
    saveData.forEach((element) {
      if (element.contains(value) ||
          PinyinHelper.getPinyin(element).contains(value)) {
        tempData.add(element);
      }
    });
    wjPrint("tempData-------$tempData");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        Container(
          // constraints: BoxConstraints(
          //   maxHeight: 400,
          // ),
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10))),
          child: Column(
            children: [
              SearchText(
                hintText: widget.holderString,
                onTextCommit: (value) {
                  _search(value);
                },
                onTextChange: (value) {
                  if (value == null || value.isEmpty) {
                    setState(() {
                      tempData.clear();
                      searchValue = '';
                      tempData.addAll(saveData);
                    });
                  }else{
                    setState(() {
                      searchValue = value;
                    });
                  }
                },
                searchController: searchController,
                action: GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '搜索',
                      style: TextStyle(color: searchValue.isNotEmpty ?  Colors.blue : Colors.grey),
                    ),
                  ),
                  onTap:searchValue.isNotEmpty ? () {
                    FocusScope.of(context).unfocus();
                    _search(searchValue);
                  } : null,
                ),
              ),
              Container(
                constraints: BoxConstraints(
                    maxHeight: keyboardHeight == 0.0 || keyboardHeight == null
                        ? 360
                        : keyboardHeight),
                child: MediaQuery.removeViewPadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                      itemCount: tempData.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (widget.selectValueCallBack != null) {
                              widget.selectValueCallBack(tempData[index]);
                              G.pop();
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey[100], width: 1))),
                            child: Row(
                              children: [
                                Text(tempData[index]),
                                const Spacer(),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
