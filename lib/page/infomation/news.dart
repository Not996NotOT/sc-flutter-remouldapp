import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/infomation/vm/news_vm.dart';
import 'package:notarization_station_app/page/infomation/widget/comment.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../utils/common_tools.dart';

class NewsPage extends StatefulWidget {
  final arguments;
  NewsPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return NewsPageState();
  }
}

class NewsPageState extends BaseState<NewsPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  bool isClick = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Consumer<UserViewModel>(builder: (ctx, userModel, child) {
      return ProviderWidget<NewsModel>(
        model: NewsModel(userModel, widget.arguments),
        onModelReady: (model) {
          model.getComment();
        },
        builder: (ctx, vm, child) {
          return Scaffold(
            appBar: commonAppBar(title: "详情"),
            backgroundColor: AppTheme.chipBackground,
            body: NestedScrollView(
              headerSliverBuilder: (context, isShow) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                            color: Colors.white,
                            width: getWidthPx(750),
                            child: Html(
                              data: widget.arguments['content'],
                              defaultTextStyle: TextStyle(
                                  fontSize: 14, color: Color(0xff4B4B4B)),
                            )),
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                          color: Colors.white,
                          margin: EdgeInsets.only(bottom: 15),
                          child: Row(
                            children: [
                              // Container(
                              //   constraints: BoxConstraints.expand(
                              //     width: 30.0,
                              //     height: 30.0,
                              //   ),
                              //   decoration: BoxDecoration(
                              //     image: DecorationImage(image: NetworkImage(Config.splicingImageUrl(widget.arguments['headIcon']))),
                              //     borderRadius: BorderRadius.circular(15.0),
                              //   ),
                              // ),
                              // SizedBox(width: 10,),
                              Expanded(
                                  child: Text(
                                      "${widget.arguments['notarialName']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xff606060)))),
                              Text("${widget.arguments['createDate']}",
                                  style: TextStyle(color: Color(0xff8D8D8D))),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPersistentHeader(
                    delegate:
                        NewsPersistensHeaderDelegate(vm.commentList.length),
                    pinned: true,
                  ),
                ];
              },
              body: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: vm.commentList.length,
                    itemBuilder: (ctx, i) {
                      var item = vm.commentList[i];
                      return Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    constraints: BoxConstraints.expand(
                                      width: 30.0,
                                      height: 30.0,
                                    ),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: item['dheadIcon'] == null &&
                                                  item['cheadIcon'] == null
                                              ? AssetImage(
                                                  "lib/assets/images/on-boy.jpg")
                                              : NetworkImage(
                                                  item['cheadIcon'] == null
                                                      ? Config.splicingImageUrl(
                                                          item['dheadIcon'])
                                                      : Config.splicingImageUrl(
                                                          item['cheadIcon']))),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
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
                                          item['cuserName'] == null
                                              ? "${item['duserName']}"
                                              : "${item['cuserName']}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      InkWell(
                                        onTap: () {
                                          showDialog<String>(
                                              context: context, //BuildContext对象
                                              builder: (BuildContext context) {
                                                return GestureDetector(
                                                  onTap: () {
                                                    G.pop(); //点击背景透明层，退出弹出框
                                                  },
                                                  child: CommentDialog(
                                                      params: "",
                                                      callback: (o) {
                                                        // vm.addComment(o,commentId: item['unitGuid'],type: 2);
                                                        vm.addComment(o,
                                                            commentId: item[
                                                                'unitGuid'],
                                                            type: 2,
                                                            parentId: item[
                                                                'createUser'],
                                                            parentName: item[
                                                                        'cuserName'] ==
                                                                    null
                                                                ? "${item['duserName']}"
                                                                : "${item['cuserName']}");
                                                      }),
                                                );
                                              });
                                        },
                                        child: Container(
                                          child: Text(
                                              "${item['commentContent']}",
                                              style: TextStyle(
                                                  color: Color(0xff5A5A5A),
                                                  fontSize: 16)),
                                        ),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (isClick) return;
                                isClick = true;
                                if (item['number'] != 0) {
                                  var data = await vm.getReply(item);
                                  if (data["code"] == 200) {
                                    vm.presentList = data['items'];
                                    vm.notifyListeners();
                                  }
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                          builder: (ctx, setBottomSheet) {
                                            return Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Container(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              0, 10, 0, 10),
                                                      width: getWidthPx(750),
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.vertical(
                                                                top: Radius
                                                                    .circular(
                                                                        10.0)),
                                                      ),
                                                      child: Center(
                                                          child: Text(
                                                        "评论详情",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ))),
                                                  SizedBox(height: 10),
                                                  Expanded(
                                                    child:
                                                        SingleChildScrollView(
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        10),
                                                            child: Row(
                                                              children: [
                                                                Container(
                                                                  constraints:
                                                                      BoxConstraints
                                                                          .expand(
                                                                    width: 25.0,
                                                                    height:
                                                                        25.0,
                                                                  ),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image: DecorationImage(
                                                                        image: item['dheadIcon'] == null && item['cheadIcon'] == null
                                                                            ? AssetImage(
                                                                                "lib/assets/images/on-boy.jpg")
                                                                            : NetworkImage(item['cheadIcon'] == null
                                                                                ? Config.splicingImageUrl(item['dheadIcon'])
                                                                                : Config.splicingImageUrl(item['cheadIcon']))),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            15.0),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  width: 10,
                                                                ),
                                                                Expanded(
                                                                    child: Text(
                                                                        item['cuserName'] == null
                                                                            ? "${item['duserName']}"
                                                                            : "${item['cuserName']}",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                16,
                                                                            fontWeight:
                                                                                FontWeight.w500))),
                                                                InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    var res = await vm
                                                                        .clickLike(
                                                                            item);
                                                                    if (res["code"] ==
                                                                        200) {
                                                                      setBottomSheet(
                                                                          () {
                                                                        item[
                                                                            'likesNumber'] = item['isLike'] ==
                                                                                1
                                                                            ? item['likesNumber'] -
                                                                                1
                                                                            : item['likesNumber'] +
                                                                                1;
                                                                        item[
                                                                            'isLike'] = item['isLike'] ==
                                                                                1
                                                                            ? 0
                                                                            : 1;
                                                                        vm.notifyListeners();
                                                                      });
                                                                    }
                                                                  },
                                                                  child: Row(
                                                                    children: [
                                                                      likeIco(
                                                                          color: item['isLike'] == 0
                                                                              ? Colors.black26
                                                                              : AppTheme.themeBlue,
                                                                          size: 20),
                                                                      SizedBox(
                                                                          width:
                                                                              8),
                                                                      Text(
                                                                        "${item['likesNumber']}",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: item['isLike'] == 0
                                                                              ? Colors.black26
                                                                              : AppTheme.themeBlue,
                                                                        ),
                                                                      )
                                                                    ],
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          InkWell(
                                                            onTap: () {
                                                              showDialog<
                                                                      String>(
                                                                  context:
                                                                      context, //BuildContext对象
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        G.pop(); //点击背景透明层，退出弹出框
                                                                      },
                                                                      child: CommentDialog(
                                                                          params: "",
                                                                          callback: (o) async {
                                                                            wjPrint("------------------$item");
                                                                            // var isTrue = await vm.addComment(o,commentId: item['unitGuid'],type: 2,);
                                                                            var isTrue = await vm.addComment(o,
                                                                                commentId: item['unitGuid'],
                                                                                type: 2,
                                                                                parentId: item['createUser'],
                                                                                parentName: item['cuserName'] == null ? "${item['duserName']}" : "${item['cuserName']}");
                                                                            var data =
                                                                                await vm.getReply(item);
                                                                            if (isTrue) {
                                                                              wjPrint("-----isTrue------$data");
                                                                              vm.presentList = data['items'];
                                                                              setBottomSheet(() {});
                                                                            }
                                                                          }),
                                                                    );
                                                                  });
                                                            },
                                                            child: Container(
                                                              padding:
                                                                  EdgeInsets
                                                                      .fromLTRB(
                                                                          40,
                                                                          10,
                                                                          0,
                                                                          0),
                                                              width: getWidthPx(
                                                                  750),
                                                              child: Text(
                                                                  "${item['commentContent']}"),
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                getWidthPx(750),
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border: Border(
                                                                  bottom: BorderSide(
                                                                      width: 1,
                                                                      color: AppTheme
                                                                          .bg_e)),
                                                            ),
                                                            margin:
                                                                EdgeInsets.only(
                                                                    left: 40),
                                                            padding: EdgeInsets
                                                                .fromLTRB(0, 10,
                                                                    10, 10),
                                                            child: Text(
                                                              "${item['createDate']}",
                                                              style: TextStyle(
                                                                  color: AppTheme
                                                                      .bg_f),
                                                            ),
                                                          ),
                                                          Container(
                                                            width:
                                                                getWidthPx(750),
                                                            padding:
                                                                EdgeInsets.all(
                                                                    10),
                                                            child: Text(
                                                              "全部回复",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ),
                                                          ListView.builder(
                                                              shrinkWrap: true,
                                                              itemCount: vm
                                                                  .presentList
                                                                  .length,
                                                              physics:
                                                                  NeverScrollableScrollPhysics(),
                                                              itemBuilder:
                                                                  (ctx, a) {
                                                                var example =
                                                                    vm.presentList[
                                                                        a];
                                                                return Container(
                                                                  child: Column(
                                                                    children: [
                                                                      Container(
                                                                        padding:
                                                                            EdgeInsets.symmetric(horizontal: 10),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              constraints: BoxConstraints.expand(
                                                                                width: 25.0,
                                                                                height: 25.0,
                                                                              ),
                                                                              decoration: BoxDecoration(
                                                                                image: DecorationImage(image: item['dheadIcon'] == null && item['cheadIcon'] == null ? AssetImage("lib/assets/images/on-boy.jpg") : NetworkImage(example['cheadIcon'] == null ? Config.splicingImageUrl(example['dheadIcon']) : Config.splicingImageUrl(example['cheadIcon']))),
                                                                                borderRadius: BorderRadius.circular(15.0),
                                                                              ),
                                                                            ),
                                                                            SizedBox(
                                                                              width: 10,
                                                                            ),
                                                                            Expanded(child: Text(example['cuserName'] == null ? "${example['duserName']}" : "${example['cuserName']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          showDialog<String>(
                                                                              context: context, //BuildContext对象
                                                                              builder: (BuildContext context) {
                                                                                return GestureDetector(
                                                                                  onTap: () {
                                                                                    G.pop(); //点击背景透明层，退出弹出框
                                                                                  },
                                                                                  child: CommentDialog(
                                                                                      params: example['cuserName'] == null ? "回复:${example['duserName']}" : "回复:${example['cuserName']}",
                                                                                      callback: (o) async {
                                                                                        var isTrue = await vm.addComment(o, commentId: item['unitGuid'], parentId: example['createUser'], parentName: example['cuserName'] == null ? "${example['duserName']}" : "${example['cuserName']}", type: 2);
                                                                                        var data = await vm.getReply(item);
                                                                                        if (isTrue) {
                                                                                          wjPrint("-----isTrue------$data");
                                                                                          vm.presentList = data['items'];
                                                                                          setBottomSheet(() {});
                                                                                        }
                                                                                      }),
                                                                                );
                                                                              });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding: EdgeInsets.fromLTRB(
                                                                              40,
                                                                              10,
                                                                              0,
                                                                              0),
                                                                          width:
                                                                              getWidthPx(750),
                                                                          child: Text(example['parentName'] == ""
                                                                              ? "${example['commentContent']}"
                                                                              : "回复${example['parentName']}：${example['commentContent']}"),
                                                                        ),
                                                                      ),
                                                                      Container(
                                                                        width: getWidthPx(
                                                                            750),
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              Colors.white,
                                                                          border:
                                                                              Border(bottom: BorderSide(width: 1, color: AppTheme.bg_b)),
                                                                        ),
                                                                        margin: EdgeInsets.only(
                                                                            left:
                                                                                40),
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            0,
                                                                            10,
                                                                            10,
                                                                            10),
                                                                        child:
                                                                            Text(
                                                                          "${example['createDate']}",
                                                                          style:
                                                                              TextStyle(color: AppTheme.bg_f),
                                                                        ),
                                                                      ),
                                                                      a + 1 == vm.presentList.length &&
                                                                              vm.presentList.length > 9
                                                                          ? FlatButton(
                                                                              textColor: Colors.blue,
                                                                              child: Text("点击加载更多"),
                                                                              onPressed: () async {
                                                                                var res = await vm.getReplyTwo(item);
                                                                                if (res['code'] == 200 && res['items'].length != 0) {
                                                                                  res['items'].forEach((e) {
                                                                                    vm.presentList.add(e);
                                                                                  });
                                                                                  setBottomSheet(() {});
                                                                                } else {
                                                                                  ToastUtil.showWarningToast("暂无更多了");
                                                                                }
                                                                              },
                                                                            )
                                                                          : SizedBox()
                                                                    ],
                                                                  ),
                                                                );
                                                              })
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        );
                                      });
                                } else {
                                  showDialog<String>(
                                      context: context, //BuildContext对象
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            G.pop(); //点击背景透明层，退出弹出框
                                          },
                                          child: CommentDialog(
                                              params: "",
                                              callback: (o) {
                                                // vm.addComment(o,commentId: item['unitGuid'],type: 2);
                                                vm.addComment(o,
                                                    commentId: item['unitGuid'],
                                                    type: 2,
                                                    parentId:
                                                        item['createUser'],
                                                    parentName: item[
                                                                'cuserName'] ==
                                                            null
                                                        ? "${item['duserName']}"
                                                        : "${item['cuserName']}");
                                              }),
                                        );
                                      });
                                }
                                isClick = false;
                              },
                              child: Container(
                                width: getWidthPx(750),
                                margin: EdgeInsets.fromLTRB(40, 10, 10, 0),
                                padding: EdgeInsets.fromLTRB(10, 6, 0, 6),
                                decoration: new BoxDecoration(
                                  color: Color(0xFFF6F6F6),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6.0)),
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      item['number'] != 0
                                          ? "共${item['number']}条回复信息"
                                          : "暂无回复",
                                      style: TextStyle(
                                          color: Color(0xff098CFF),
                                          fontSize: 14),
                                    ),
                                    item['number'] != 0
                                        ? Icon(Icons.chevron_right,
                                            color: Color(0xff098CFF), size: 14)
                                        : SizedBox()
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: getWidthPx(750),
                              padding: EdgeInsets.fromLTRB(50, 10, 15, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "${item['createDate']}",
                                    style: TextStyle(color: Color(0xff818181)),
                                  )),
                                  InkWell(
                                    onTap: () {
                                      showDialog<String>(
                                          context: context, //BuildContext对象
                                          builder: (BuildContext context) {
                                            return GestureDetector(
                                              onTap: () {
                                                G.pop(); //点击背景透明层，退出弹出框
                                              },
                                              child: CommentDialog(
                                                  params: "",
                                                  callback: (o) {
                                                    // vm.addComment(o,commentId: item['unitGuid'],type: 2);
                                                    vm.addComment(o,
                                                        commentId:
                                                            item['unitGuid'],
                                                        type: 2,
                                                        parentId:
                                                            item['createUser'],
                                                        parentName: item[
                                                                    'cuserName'] ==
                                                                null
                                                            ? "${item['duserName']}"
                                                            : "${item['cuserName']}");
                                                  }),
                                            );
                                          });
                                    },
                                    child: commentIco(
                                      color: Color(0xff474747),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      var res = await vm.clickLike(item);
                                      if (res["code"] == 200) {
                                        item['likesNumber'] =
                                            item['isLike'] == 1
                                                ? item['likesNumber'] - 1
                                                : item['likesNumber'] + 1;
                                        item['isLike'] =
                                            item['isLike'] == 1 ? 0 : 1;
                                        vm.notifyListeners();
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        likeIco(
                                          color: item['isLike'] == 0
                                              ? Color(0xff474747)
                                              : AppTheme.themeBlue,
                                          size: 20,
                                        ),
                                        SizedBox(width: 6),
                                        Text(
                                          "${item['likesNumber']}",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: item['isLike'] == 0
                                                ? Color(0xff474747)
                                                : AppTheme.themeBlue,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.fromLTRB(50, 10, 10, 20),
                              color: Color(0xffF1F1F1),
                              width: getWidthPx(750),
                              height: 1,
                            ),
                            i + 1 == vm.commentList.length &&
                                    vm.presentList.length > 9
                                ? FlatButton(
                                    textColor: Colors.blue,
                                    child: Text("点击加载更多"),
                                    onPressed: () {
                                      vm.getCommentTwo();
                                    },
                                  )
                                : SizedBox()
                          ],
                        ),
                      );
                    },
                  )),
                  Container(
                    padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(top: BorderSide(color: Color(0xffF1F1F1))),
                    ),
                    child: InkWell(
                      onTap: () {
                        showDialog<String>(
                            context: context, //BuildContext对象
                            builder: (BuildContext context) {
                              return GestureDetector(
                                onTap: () {
                                  G.pop(); //点击背景透明层，退出弹出框
                                },
                                child: CommentDialog(
                                    params: "",
                                    callback: (o) {
                                      vm.addComment(o,
                                          type: 1,
                                          parentId: widget
                                              .arguments['createUser'],
                                          parentName: widget
                                              .arguments['userName']);
                                    }),
                              );
                            });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(top: 15,bottom: 40),
                        child: commentIco(
                          color: Color(0xff474747),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    });

    Scaffold(
        appBar: commonAppBar(title: "详情"),
        backgroundColor: AppTheme.chipBackground,
        body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
          return ProviderWidget<NewsModel>(
            model: NewsModel(userModel, widget.arguments),
            onModelReady: (model) {
              model.getComment();
            },
            builder: (ctx, vm, child) {
              return Container(
                width: getWidthPx(750),
                color: Color(0xffF5F5F5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                                color: Colors.white,
                                width: getWidthPx(750),
                                child: Html(
                                  data: widget.arguments['content'],
                                  defaultTextStyle: TextStyle(
                                      fontSize: 14, color: Color(0xff4B4B4B)),
                                )),
                            Container(
                              padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                              color: Colors.white,
                              child: Row(
                                children: [
                                  // Container(
                                  //   constraints: BoxConstraints.expand(
                                  //     width: 30.0,
                                  //     height: 30.0,
                                  //   ),
                                  //   decoration: BoxDecoration(
                                  //     image: DecorationImage(image: NetworkImage(Config.splicingImageUrl(widget.arguments['headIcon']))),
                                  //     borderRadius: BorderRadius.circular(15.0),
                                  //   ),
                                  // ),
                                  // SizedBox(width: 10,),
                                  Expanded(
                                      child: Text(
                                          "${widget.arguments['notarialName']}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff606060)))),
                                  Text("${widget.arguments['createDate']}",
                                      style:
                                          TextStyle(color: Color(0xff8D8D8D))),
                                ],
                              ),
                            ),
                            Container(
                              width: getWidthPx(750),
                              padding: EdgeInsets.all(10),
                              margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1, color: Color(0xffEFEFEF))),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("评论 ${vm.commentList.length}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18)),
                                  //Text("赞 ${widget.arguments['likesNumber']}",style: TextStyle(color:Color(0xff8C8C8C),fontSize: 16)),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemCount: vm.commentList.length,
                              itemBuilder: (ctx, i) {
                                var item = vm.commentList[i];
                                return Container(
                                  color: Colors.white,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              constraints:
                                                  BoxConstraints.expand(
                                                width: 30.0,
                                                height: 30.0,
                                              ),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: item['dheadIcon'] ==
                                                                null &&
                                                            item['cheadIcon'] ==
                                                                null
                                                        ? AssetImage(
                                                            "lib/assets/images/on-boy.jpg")
                                                        : NetworkImage(item[
                                                                    'cheadIcon'] ==
                                                                null
                                                            ? Config.splicingImageUrl(
                                                                item[
                                                                    'dheadIcon'])
                                                            : Config.splicingImageUrl(
                                                                item[
                                                                    'cheadIcon']))),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
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
                                                    item['cuserName'] == null
                                                        ? "${item['duserName']}"
                                                        : "${item['cuserName']}",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                InkWell(
                                                  onTap: () {
                                                    showDialog<String>(
                                                        context:
                                                            context, //BuildContext对象
                                                        builder: (BuildContext
                                                            context) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              G.pop(); //点击背景透明层，退出弹出框
                                                            },
                                                            child:
                                                                CommentDialog(
                                                                    params: "",
                                                                    callback:
                                                                        (o) {
                                                                      // vm.addComment(o,commentId: item['unitGuid'],type: 2);
                                                                      vm.addComment(
                                                                          o,
                                                                          commentId: item[
                                                                              'unitGuid'],
                                                                          type:
                                                                              2,
                                                                          parentId: item[
                                                                              'createUser'],
                                                                          parentName: item['cuserName'] == null
                                                                              ? "${item['duserName']}"
                                                                              : "${item['cuserName']}");
                                                                    }),
                                                          );
                                                        });
                                                  },
                                                  child: Container(
                                                    child: Text(
                                                        "${item['commentContent']}",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff5A5A5A),
                                                            fontSize: 16)),
                                                  ),
                                                ),
                                              ],
                                            )),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () async {
                                          if (isClick) return;
                                          isClick = true;
                                          if (item['number'] != 0) {
                                            var data = await vm.getReply(item);
                                            if (data["code"] == 200) {
                                              vm.presentList = data['items'];
                                              vm.notifyListeners();
                                            }
                                            showModalBottomSheet(
                                                context: context,
                                                backgroundColor:
                                                    Colors.transparent,
                                                builder:
                                                    (BuildContext context) {
                                                  return StatefulBuilder(
                                                    builder:
                                                        (ctx, setBottomSheet) {
                                                      return Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10.0)),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .fromLTRB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            10),
                                                                width:
                                                                    getWidthPx(
                                                                        750),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top: Radius.circular(
                                                                              10.0)),
                                                                ),
                                                                child: Center(
                                                                    child: Text(
                                                                  "评论详情",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700),
                                                                ))),
                                                            SizedBox(
                                                                height: 10),
                                                            Expanded(
                                                              child:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      padding: EdgeInsets.symmetric(
                                                                          horizontal:
                                                                              10),
                                                                      child:
                                                                          Row(
                                                                        children: [
                                                                          Container(
                                                                            constraints:
                                                                                BoxConstraints.expand(
                                                                              width: 25.0,
                                                                              height: 25.0,
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              image: DecorationImage(image: item['dheadIcon'] == null && item['cheadIcon'] == null ? AssetImage("lib/assets/images/on-boy.jpg") : NetworkImage(item['cheadIcon'] == null ? Config.splicingImageUrl(item['dheadIcon']) : Config.splicingImageUrl(item['cheadIcon']))),
                                                                              borderRadius: BorderRadius.circular(15.0),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                10,
                                                                          ),
                                                                          Expanded(
                                                                              child: Text(item['cuserName'] == null ? "${item['duserName']}" : "${item['cuserName']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                                                          InkWell(
                                                                            onTap:
                                                                                () async {
                                                                              var res = await vm.clickLike(item);
                                                                              if (res["code"] == 200) {
                                                                                setBottomSheet(() {
                                                                                  item['likesNumber'] = item['isLike'] == 1 ? item['likesNumber'] - 1 : item['likesNumber'] + 1;
                                                                                  item['isLike'] = item['isLike'] == 1 ? 0 : 1;
                                                                                  vm.notifyListeners();
                                                                                });
                                                                              }
                                                                            },
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                likeIco(color: item['isLike'] == 0 ? Colors.black26 : AppTheme.themeBlue, size: 20),
                                                                                SizedBox(width: 8),
                                                                                Text(
                                                                                  "${item['likesNumber']}",
                                                                                  style: TextStyle(
                                                                                    fontSize: 14,
                                                                                    color: item['isLike'] == 0 ? Colors.black26 : AppTheme.themeBlue,
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        showDialog<
                                                                                String>(
                                                                            context:
                                                                                context, //BuildContext对象
                                                                            builder:
                                                                                (BuildContext context) {
                                                                              return GestureDetector(
                                                                                onTap: () {
                                                                                  G.pop(); //点击背景透明层，退出弹出框
                                                                                },
                                                                                child: CommentDialog(
                                                                                    params: "",
                                                                                    callback: (o) async {
                                                                                      wjPrint("------------------$item");
                                                                                      // var isTrue = await vm.addComment(o,commentId: item['unitGuid'],type: 2,);
                                                                                      var isTrue = await vm.addComment(o, commentId: item['unitGuid'], type: 2, parentId: item['createUser'], parentName: item['cuserName'] == null ? "${item['duserName']}" : "${item['cuserName']}");
                                                                                      var data = await vm.getReply(item);
                                                                                      if (isTrue) {
                                                                                        wjPrint("-----isTrue------$data");
                                                                                        vm.presentList = data['items'];
                                                                                        setBottomSheet(() {});
                                                                                      }
                                                                                    }),
                                                                              );
                                                                            });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        padding: EdgeInsets.fromLTRB(
                                                                            40,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                        width: getWidthPx(
                                                                            750),
                                                                        child: Text(
                                                                            "${item['commentContent']}"),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: getWidthPx(
                                                                          750),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        border: Border(
                                                                            bottom:
                                                                                BorderSide(width: 1, color: AppTheme.bg_e)),
                                                                      ),
                                                                      margin: EdgeInsets.only(
                                                                          left:
                                                                              40),
                                                                      padding: EdgeInsets
                                                                          .fromLTRB(
                                                                              0,
                                                                              10,
                                                                              10,
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        "${item['createDate']}",
                                                                        style: TextStyle(
                                                                            color:
                                                                                AppTheme.bg_f),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      width: getWidthPx(
                                                                          750),
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              10),
                                                                      child:
                                                                          Text(
                                                                        "全部回复",
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.bold),
                                                                      ),
                                                                    ),
                                                                    ListView.builder(
                                                                        shrinkWrap: true,
                                                                        itemCount: vm.presentList.length,
                                                                        physics: NeverScrollableScrollPhysics(),
                                                                        itemBuilder: (ctx, a) {
                                                                          var example =
                                                                              vm.presentList[a];
                                                                          return Container(
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Container(
                                                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                                                  child: Row(
                                                                                    children: [
                                                                                      Container(
                                                                                        constraints: BoxConstraints.expand(
                                                                                          width: 25.0,
                                                                                          height: 25.0,
                                                                                        ),
                                                                                        decoration: BoxDecoration(
                                                                                          image: DecorationImage(image: item['dheadIcon'] == null && item['cheadIcon'] == null ? AssetImage("lib/assets/images/on-boy.jpg") : NetworkImage(example['cheadIcon'] == null ? Config.splicingImageUrl(example['dheadIcon']) : Config.splicingImageUrl(example['cheadIcon']))),
                                                                                          borderRadius: BorderRadius.circular(15.0),
                                                                                        ),
                                                                                      ),
                                                                                      SizedBox(
                                                                                        width: 10,
                                                                                      ),
                                                                                      Expanded(child: Text(example['cuserName'] == null ? "${example['duserName']}" : "${example['cuserName']}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500))),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                InkWell(
                                                                                  onTap: () {
                                                                                    showDialog<String>(
                                                                                        context: context, //BuildContext对象
                                                                                        builder: (BuildContext context) {
                                                                                          return GestureDetector(
                                                                                            onTap: () {
                                                                                              G.pop(); //点击背景透明层，退出弹出框
                                                                                            },
                                                                                            child: CommentDialog(
                                                                                                params: example['cuserName'] == null ? "回复:${example['duserName']}" : "回复:${example['cuserName']}",
                                                                                                callback: (o) async {
                                                                                                  var isTrue = await vm.addComment(o, commentId: item['unitGuid'], parentId: example['createUser'], parentName: example['cuserName'] == null ? "${example['duserName']}" : "${example['cuserName']}", type: 2);
                                                                                                  var data = await vm.getReply(item);
                                                                                                  if (isTrue) {
                                                                                                    wjPrint("-----isTrue------$data");
                                                                                                    vm.presentList = data['items'];
                                                                                                    setBottomSheet(() {});
                                                                                                  }
                                                                                                }),
                                                                                          );
                                                                                        });
                                                                                  },
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.fromLTRB(40, 10, 0, 0),
                                                                                    width: getWidthPx(750),
                                                                                    child: Text(example['parentName'] == "" ? "${example['commentContent']}" : "回复${example['parentName']}：${example['commentContent']}"),
                                                                                  ),
                                                                                ),
                                                                                Container(
                                                                                  width: getWidthPx(750),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.white,
                                                                                    border: Border(bottom: BorderSide(width: 1, color: AppTheme.bg_b)),
                                                                                  ),
                                                                                  margin: EdgeInsets.only(left: 40),
                                                                                  padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                                                                                  child: Text(
                                                                                    "${example['createDate']}",
                                                                                    style: TextStyle(color: AppTheme.bg_f),
                                                                                  ),
                                                                                ),
                                                                                a + 1 == vm.presentList.length && vm.presentList.length > 9
                                                                                    ? FlatButton(
                                                                                        textColor: Colors.blue,
                                                                                        child: Text("点击加载更多"),
                                                                                        onPressed: () async {
                                                                                          var res = await vm.getReplyTwo(item);
                                                                                          if (res['code'] == 200 && res['items'].length != 0) {
                                                                                            res['items'].forEach((e) {
                                                                                              vm.presentList.add(e);
                                                                                            });
                                                                                            setBottomSheet(() {});
                                                                                          } else {
                                                                                            ToastUtil.showWarningToast("暂无更多了");
                                                                                          }
                                                                                        },
                                                                                      )
                                                                                    : SizedBox()
                                                                              ],
                                                                            ),
                                                                          );
                                                                        })
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    },
                                                  );
                                                });
                                          } else {
                                            showDialog<String>(
                                                context:
                                                    context, //BuildContext对象
                                                builder:
                                                    (BuildContext context) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      G.pop(); //点击背景透明层，退出弹出框
                                                    },
                                                    child: CommentDialog(
                                                        params: "",
                                                        callback: (o) {
                                                          // vm.addComment(o,commentId: item['unitGuid'],type: 2);
                                                          vm.addComment(o,
                                                              commentId: item[
                                                                  'unitGuid'],
                                                              type: 2,
                                                              parentId: item[
                                                                  'createUser'],
                                                              parentName: item[
                                                                          'cuserName'] ==
                                                                      null
                                                                  ? "${item['duserName']}"
                                                                  : "${item['cuserName']}");
                                                        }),
                                                  );
                                                });
                                          }
                                          isClick = false;
                                        },
                                        child: Container(
                                          width: getWidthPx(750),
                                          margin: EdgeInsets.fromLTRB(
                                              40, 10, 10, 0),
                                          padding:
                                              EdgeInsets.fromLTRB(10, 6, 0, 6),
                                          decoration: new BoxDecoration(
                                            color: Color(0xFFF6F6F6),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(6.0)),
                                          ),
                                          child: Row(
                                            children: [
                                              Text(
                                                item['number'] != 0
                                                    ? "共${item['number']}条回复信息"
                                                    : "暂无回复",
                                                style: TextStyle(
                                                    color: Color(0xff098CFF),
                                                    fontSize: 14),
                                              ),
                                              item['number'] != 0
                                                  ? Icon(Icons.chevron_right,
                                                      color: Color(0xff098CFF),
                                                      size: 14)
                                                  : SizedBox()
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: getWidthPx(750),
                                        padding:
                                            EdgeInsets.fromLTRB(50, 10, 15, 0),
                                        child: Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              "${item['createDate']}",
                                              style: TextStyle(
                                                  color: Color(0xff818181)),
                                            )),
                                            InkWell(
                                              onTap: () {
                                                showDialog<String>(
                                                    context:
                                                        context, //BuildContext对象
                                                    builder:
                                                        (BuildContext context) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          G.pop(); //点击背景透明层，退出弹出框
                                                        },
                                                        child: CommentDialog(
                                                            params: "",
                                                            callback: (o) {
                                                              // vm.addComment(o,commentId: item['unitGuid'],type: 2);
                                                              vm.addComment(o,
                                                                  commentId: item[
                                                                      'unitGuid'],
                                                                  type: 2,
                                                                  parentId: item[
                                                                      'createUser'],
                                                                  parentName: item[
                                                                              'cuserName'] ==
                                                                          null
                                                                      ? "${item['duserName']}"
                                                                      : "${item['cuserName']}");
                                                            }),
                                                      );
                                                    });
                                              },
                                              child: commentIco(
                                                color: Color(0xff474747),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 30,
                                            ),
                                            InkWell(
                                              onTap: () async {
                                                var res =
                                                    await vm.clickLike(item);
                                                if (res["code"] == 200) {
                                                  item['likesNumber'] = item[
                                                              'isLike'] ==
                                                          1
                                                      ? item['likesNumber'] - 1
                                                      : item['likesNumber'] + 1;
                                                  item['isLike'] =
                                                      item['isLike'] == 1
                                                          ? 0
                                                          : 1;
                                                  vm.notifyListeners();
                                                }
                                              },
                                              child: Row(
                                                children: [
                                                  likeIco(
                                                    color: item['isLike'] == 0
                                                        ? Color(0xff474747)
                                                        : AppTheme.themeBlue,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 6),
                                                  Text(
                                                    "${item['likesNumber']}",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: item['isLike'] == 0
                                                          ? Color(0xff474747)
                                                          : AppTheme.themeBlue,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            EdgeInsets.fromLTRB(50, 10, 10, 20),
                                        color: Color(0xffF1F1F1),
                                        width: getWidthPx(750),
                                        height: 1,
                                      ),
                                      i + 1 == vm.commentList.length &&
                                              vm.presentList.length > 9
                                          ? FlatButton(
                                              textColor: Colors.blue,
                                              child: Text("点击加载更多"),
                                              onPressed: () {
                                                vm.getCommentTwo();
                                              },
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                );
                              },
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).padding.bottom +
                                  getWidthPx(98),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border:
                            Border(top: BorderSide(color: Color(0xffF1F1F1))),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              InkWell(
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      backgroundColor: Colors.transparent,
                                      builder: (BuildContext context) {
                                        return Container(
                                          color: Colors.white,
                                          height: getWidthPx(180),
                                          width: getWidthPx(750),
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  G.pop();
                                                  shareToWeChat(
                                                      WeChatShareWebPageModel(
                                                    "https://sc.njguochu.com:9222/?shareFlutter",
                                                    thumbnail: WeChatImage.asset(
                                                        "lib/assets/images/logo2.jpg"),
                                                    description:
                                                        "${widget.arguments['title']}",
                                                    title: "公证社区行业动态",
                                                    scene: WeChatScene.SESSION,
                                                  ));
                                                },
                                                child: Column(
                                                  children: [
                                                    weChatGoIco(
                                                        color: Colors.green,
                                                        size: 30),
                                                    SizedBox(height: 8),
                                                    Text("微信好友")
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  G.pop();
                                                  shareToWeChat(
                                                      WeChatShareWebPageModel(
                                                    "https://sc.njguochu.com:9222/?shareFlutter",
                                                    thumbnail: WeChatImage.asset(
                                                        "lib/assets/images/logo2.jpg"),
                                                    description:
                                                        "${widget.arguments['title']}",
                                                    title: "公证社区行业动态",
                                                    scene: WeChatScene.TIMELINE,
                                                  ));
                                                },
                                                child: Column(
                                                  children: [
                                                    friendIco(
                                                        color: Colors.green,
                                                        size: 30),
                                                    SizedBox(height: 8),
                                                    Text("朋友圈")
                                                  ],
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  G.pop();
                                                  Clipboard.setData(ClipboardData(
                                                      text:
                                                          "详情请搜索微信小程序远程公证或者下载青桐智盒APP:https://sc.njguochu.com:46/index.html"));
                                                  ToastUtil.showSuccessToast(
                                                      "复制到粘贴板成功");
                                                },
                                                child: Column(
                                                  children: [
                                                    linkIco(
                                                        color: Colors.green,
                                                        size: 30),
                                                    SizedBox(height: 8),
                                                    Text("复制链接")
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      });
                                },
                                child: Container(
                                  width: getWidthPx(150),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: transpondIco(
                                      color: Color(0xff474747), size: 22),
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                width: 1,
                                height: 20,
                                color: Color(0xffF1F1F1),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog<String>(
                                      context: context, //BuildContext对象
                                      builder: (BuildContext context) {
                                        return GestureDetector(
                                          onTap: () {
                                            G.pop(); //点击背景透明层，退出弹出框
                                          },
                                          child: CommentDialog(
                                              params: "",
                                              callback: (o) {
                                                vm.addComment(o,
                                                    type: 1,
                                                    parentId: widget.arguments[
                                                        'createUser'],
                                                    parentName: widget
                                                        .arguments['userName']);
                                              }),
                                        );
                                      });
                                },
                                child: Container(
                                  width: getWidthPx(150),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: commentIco(
                                    color: Color(0xff474747),
                                  ),
                                ),
                              ),
                              Container(
                                // margin: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                width: 1,
                                height: 20,
                                color: Color(0xffF1F1F1),
                              ),
                              InkWell(
                                onTap: () async {
                                  var res = await vm.clickLike(widget.arguments,
                                      category: 2);
                                  if (res["code"] == 200) {
                                    widget.arguments['likesNumber'] = widget
                                                .arguments['isLike'] ==
                                            1
                                        ? widget.arguments['likesNumber'] - 1
                                        : widget.arguments['likesNumber'] + 1;
                                    widget.arguments['isLike'] =
                                        widget.arguments['isLike'] == 1 ? 0 : 1;
                                    vm.notifyListeners();
                                  }
                                },
                                child: Container(
                                  width: getWidthPx(150),
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: likeIco(
                                    color: widget.arguments['isLike'] == 0
                                        ? Color(0xff474747)
                                        : AppTheme.themeBlue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).padding.bottom,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}

class NewsPersistensHeaderDelegate extends SliverPersistentHeaderDelegate {
  final int amount;

  NewsPersistensHeaderDelegate(this.amount);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    // TODO: implement build
    return Container(
      height: 45,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      // margin: EdgeInsets.fromLTRB(0, 15, 0, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1, color: Color(0xffEFEFEF))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text("评论 ${amount.toString()}",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18)),
          //Text("赞 ${widget.arguments['likesNumber']}",style: TextStyle(color:Color(0xff8C8C8C),fontSize: 16)),
        ],
      ),
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => 45;

  @override
  // TODO: implement minExtent
  double get minExtent => 45;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    // TODO: implement shouldRebuild
    return true;
  }
}
