import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';

class MatterListPage extends StatefulWidget {
  Map arguments;
  MatterListPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return MatterListPageState();
  }
}

class MatterListPageState extends BaseState<MatterListPage> {
  List treeList = [];

  @override
  void initState() {
    super.initState();
    getTree();
  }

  getTree() async {
    var res = await InformationApi.getSingleton()
        .getMaterialModel({"notaryItemModelId": widget.arguments['unitGuid']});
    if (res['code'] == 200) {
      treeList = res['items'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: AppTheme.white,
          leading: InkWell(
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 22,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: true,
          title: Text(
            "公证事项详情",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
        body: Container(
            width: getWidthPx(750),
            child: Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                Container(
                    color: Colors.white,
                    width: getWidthPx(750),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "公证事项：${widget.arguments['name'] ?? "无"}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    )),
                Container(
                    color: Color.fromRGBO(219, 231, 249, 1),
                    width: getWidthPx(750),
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child: Center(
                                child: Text(
                              "材料名称",
                              style: TextStyle(fontSize: 16),
                            ))),
                        Expanded(
                            flex: 2,
                            child: Center(
                                child: Text(
                              "类型",
                              style: TextStyle(fontSize: 16),
                            ))),
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(
                              "必要",
                              style: TextStyle(fontSize: 16),
                            ))),
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(
                              "份数",
                              style: TextStyle(fontSize: 16),
                            ))),
                        Expanded(
                            flex: 1,
                            child: Center(
                                child: Text(
                              "备注",
                              style: TextStyle(fontSize: 16),
                            ))),
                      ],
                    )),
                treeList.length > 0
                    ? Expanded(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: treeList.length,
                            itemBuilder: (ctx, i) {
                              var item = treeList[i];
                              return Container(
                                  color: i.isOdd
                                      ? Color.fromRGBO(245, 247, 250, 1)
                                      : Colors.white,
                                  width: getWidthPx(750),
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Center(
                                              child: Text(
                                            "${item['name'] ?? "无"}",
                                            style: TextStyle(fontSize: 16),
                                          ))),
                                      Expanded(
                                          flex: 2,
                                          child: Center(
                                              child: Text(
                                            "图片/复印件",
                                            style: TextStyle(fontSize: 16),
                                          ))),
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                              child: Text(
                                            item['isMust'] == 1 ? "是" : "否",
                                            style: TextStyle(fontSize: 16),
                                          ))),
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                              child: Text(
                                            "${item['copies'] ?? "无"}",
                                            style: TextStyle(fontSize: 16),
                                          ))),
                                      Expanded(
                                          flex: 1,
                                          child: Center(
                                              child: Text(
                                            "${item['remark'] ?? "无"}",
                                            style: TextStyle(fontSize: 16),
                                          ))),
                                    ],
                                  ));
                            }),
                      )
                    : Center(child: Text("暂无数据"))
              ],
            )));
  }
}
