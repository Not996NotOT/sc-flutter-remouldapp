import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluwx/fluwx.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/infomation/vm/community_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/common_tools.dart';

class CommunityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CommunityPageState();
  }
}

class CommunityPageState extends BaseState<CommunityPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  CommunityModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      floatingActionButtonLocation: CustomFloatingActionButtonLocation(
          FloatingActionButtonLocation.endDocked, 15, 0),
      floatingActionButton: viewModel != null && viewModel.isShow
          ? null
          : InkWell(
              onTap: () {
                Navigator.pushNamed(context, RoutePaths.Quiz)
                    .then((value) => viewModel.getList(0));
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xE8329DFD),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(60)),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(6, 10, 0, 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "lib/assets/images/ask_icon.png",
                        width: 18,
                        height: 18,
                        fit: BoxFit.fill,
                      ),
                      Text(
                        "我要提问",
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      appBar: AppBar(
        leading: null,
        backgroundColor: AppTheme.themeBlue,
        centerTitle: true,
        title: Row(
          children: [
            Text(
              "南京市",
              style: TextStyle(fontSize: 14),
            ),
            Icon(
              Icons.expand_more,
              size: 18,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 35),
                  child: Text(
                    "公证社区",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
            child: Container(
              width: getWidthPx(750),
              margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
              child: InkWell(
                onTap: () {
                  G.pushNamed(RoutePaths.Search);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    border: Border.all(width: 1, color: AppTheme.Text_a),
                  ),
                  padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: AppTheme.Text_a),
                      Text(
                        "  搜索公证处",
                        style: TextStyle(color: AppTheme.Text_a),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            preferredSize: Size(50, 50)),
        actions: [
          InkWell(
            onTap: () {
              G.pushNamed(RoutePaths.Message);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(Icons.mail_outline),
            ),
          )
        ],
      ),
      backgroundColor: AppTheme.chipBackground,
      body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
        return ProviderWidget<CommunityModel>(
          model: CommunityModel(userModel),
          onModelReady: (model) {
            viewModel = model;
            // model.getNearbyNotary();
          },
          builder: (ctx, vm, child) {
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: HomeRefreshHeader(Colors.black),
              footer: RefresherFooter(),
              controller: vm.refreshController,
              onRefresh: vm.refresh,
              onLoading: vm.loadMore,
              child: SingleChildScrollView(
                child: Container(
                  width: getWidthPx(750),
                  color: Colors.white,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          G.pushNamed(RoutePaths.NotaryDetail,
                              arguments: vm.notarialInfo);
                        },
                        child: Container(
                          padding: EdgeInsets.all(10),
                          color: Color(0xffEEFBFF),
                          child: Row(
                            children: [
                              Image.asset(
                                "lib/assets/images/logo.png",
                                width: 70,
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${vm.notarialInfo['notarialName']}",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${vm.notarialInfo['address']}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xffA9AFB1)),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${vm.notarialInfo['contactNumber']}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xffA9AFB1)),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: mineAddressIco(
                                    color: AppTheme.themeBlue, size: 30),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 120.0,
                        padding: EdgeInsets.fromLTRB(6, 10, 6, 10),
                        child: Swiper(
                          // 横向
                          scrollDirection: Axis.horizontal,
                          //条目个数
                          itemCount: 6,
                          // 自动翻页
                          autoplay: true,
                          // 相邻子条目视窗比例
                          viewportFraction: 1,
                          // 布局方式
                          autoplayDisableOnInteraction: true,
                          // 无线轮播
                          loop: true,
                          //当前条目的缩放比例
                          scale: 1,
                          // 分页指示
                          pagination: SwiperPagination(
                            //指示器显示的位置
                            alignment: Alignment
                                .bottomCenter, // 位置 Alignment.bottomCenter 底部中间
                            // 距离调整
                            margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            // 指示器构建
                            builder: DotSwiperPaginationBuilder(
                                // 点之间的间隔
                                space: 2,
                                // 没选中时的大小
                                size: 4,
                                // 选中时的大小
                                activeSize: 8,
                                // 没选中时的颜色
                                color: Colors.black54,
                                //选中时的颜色
                                activeColor: Colors.white),
                          ),
                          //点击事件
                          onTap: (index) {
                            wjPrint(" 点击 " + index.toString());
                          },
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadiusDirectional.circular(8)),
                                clipBehavior: Clip.antiAlias,
                                child: Image.asset(
                                  "lib/assets/images/banner.png",
                                  fit: BoxFit.fill,
                                ));
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xffEEFBFF),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                G.pushNamed(RoutePaths.MatterList);
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "lib/assets/images/gzsx.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "公证事项",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                G.pushNamed(RoutePaths.Guide);
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    "lib/assets/images/gzzn.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "办证指南",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                G.pushNamed(RoutePaths.NotaryOffice);
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    "lib/assets/images/fjgzc.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    "附近公证处",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        color: Color(0xffF5F5F5),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                vm.isShow = false;
                                vm.getList(0);
                                setState(() {});
                                // vm.notifyListeners();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Text(
                                    "公证问答",
                                    style: TextStyle(
                                        fontSize: !vm.isShow ? 16 : 14,
                                        fontWeight: !vm.isShow
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  )),
                            ),
                            InkWell(
                              onTap: () {
                                vm.isShow = true;
                                vm.getList(1);
                                setState(() {});
                                // vm.notifyListeners();
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                                  child: Text("行业动态",
                                      style: TextStyle(
                                          fontSize: vm.isShow ? 16 : 14,
                                          fontWeight: vm.isShow
                                              ? FontWeight.bold
                                              : FontWeight.normal))),
                            )
                          ],
                        ),
                      ),
                      Offstage(
                          offstage: vm.isShow,
                          child: Container(
                            color: Color(0xffF5F5F5),
                            child: vm.busy
                                ? loadingWidget()
                                : vm.questionList.length > 0
                                    ? ListView.builder(
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: vm.questionList.length,
                                        itemBuilder: (ctx, i) {
                                          var item = {};
                                          if (vm.questionList.length != 0) {
                                            item = vm.questionList[i];
                                          }
                                          return InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(context,
                                                      RoutePaths.QuestionDetail,
                                                      arguments: item)
                                                  .then((value) {
                                                wjPrint("-------9----$value");
                                                if (value == "refresh") {
                                                  vm.getList(0);
                                                }
                                              });
                                            },
                                            child: Container(
                                              margin: EdgeInsets.fromLTRB(
                                                  10, 10, 10, 0),
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8)),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          constraints:
                                                              BoxConstraints
                                                                  .expand(
                                                            width: 30.0,
                                                            height: 30.0,
                                                          ),
                                                          decoration:
                                                              BoxDecoration(
                                                            image: DecorationImage(
                                                                image: item['headIcon'] ==
                                                                        null
                                                                    ? AssetImage(
                                                                        "lib/assets/images/on-boy.jpg")
                                                                    : NetworkImage(
                                                                        Config.splicingImageUrl(
                                                                            item['headIcon']))),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                            child: Text(
                                                                "${item['userName']}")),
                                                        Text(
                                                          "${item['createDate']}",
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0xff797979)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Text(
                                                        "${item['question']}",
                                                        style: TextStyle(
                                                            color: Color(
                                                                0xff494949))),
                                                  ),
                                                  item['picture'] == null ||
                                                          item['picture'] == ""
                                                      ? SizedBox()
                                                      : GridView.builder(
                                                          shrinkWrap: true,
                                                          physics:
                                                              NeverScrollableScrollPhysics(),
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount:
                                                                3, //每行三列
                                                            childAspectRatio:
                                                                1.0, //显示区域宽高相等
                                                            mainAxisSpacing: 10,
                                                            crossAxisSpacing:
                                                                10,
                                                          ),
                                                          itemCount:
                                                              item['picture']
                                                                  .split(',')
                                                                  .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            var i = item[
                                                                    'picture']
                                                                .split(
                                                                    ',')[index];
                                                            return Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                              child: Image.network(
                                                                  Config
                                                                      .splicingImageUrl(
                                                                          i),
                                                                  fit: BoxFit
                                                                      .fill),
                                                            );
                                                          }),
                                                  Container(
                                                    margin: EdgeInsets.fromLTRB(
                                                        8, 0, 8, 0),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                          top: BorderSide(
                                                              color: Color(
                                                                  0xffE8E8E8))),
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            showModalBottomSheet(
                                                                context:
                                                                    context,
                                                                backgroundColor:
                                                                    Colors
                                                                        .transparent,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Container(
                                                                    color: Colors
                                                                        .white,
                                                                    height:
                                                                        getWidthPx(
                                                                            180),
                                                                    width:
                                                                        getWidthPx(
                                                                            750),
                                                                    padding:
                                                                        EdgeInsets.all(
                                                                            10),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            G.pop();
                                                                            shareToWeChat(WeChatShareWebPageModel(
                                                                              "https://shicheng.njguochu.com:9222?1&${item['unitGuid']}",
                                                                              thumbnail: WeChatImage.asset("lib/assets/images/logo2.jpg"),
                                                                              description: "${item['question']}",
                                                                              title: "公证社区公证问答",
                                                                              scene: WeChatScene.SESSION,
                                                                            ));
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              weChatGoIco(color: Colors.green, size: 30),
                                                                              SizedBox(height: 8),
                                                                              Text("微信好友")
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            G.pop();
                                                                            shareToWeChat(WeChatShareWebPageModel(
                                                                              "https://shicheng.njguochu.com:9222?1&${item['unitGuid']}",
                                                                              thumbnail: WeChatImage.asset("lib/assets/images/logo2.jpg"),
                                                                              description: "${item['question']}",
                                                                              title: "公证社区公证问答",
                                                                              scene: WeChatScene.TIMELINE,
                                                                            ));
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              friendIco(color: Colors.green, size: 30),
                                                                              SizedBox(height: 8),
                                                                              Text("朋友圈")
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            G.pop();
                                                                            Clipboard.setData(ClipboardData(text: "${item['question']} 详情请打开链接：https://shicheng.njguochu.com:9222?1&${item['unitGuid']}"));
                                                                            ToastUtil.showSuccessToast("复制到粘贴板成功");
                                                                          },
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              linkIco(color: Colors.green, size: 30),
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
                                                            width:
                                                                getWidthPx(150),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: transpondIco(
                                                                color: Color(
                                                                    0xff474747),
                                                                size: 24),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pushNamed(
                                                                    context,
                                                                    RoutePaths
                                                                        .QuestionDetail,
                                                                    arguments:
                                                                        item)
                                                                .then((value) {
                                                              wjPrint(
                                                                  "-------9----$value");
                                                              if (value ==
                                                                  "refresh") {
                                                                vm.getList(0);
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            width:
                                                                getWidthPx(150),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                commentIco(
                                                                  color: Color(
                                                                      0xff474747),
                                                                ),
                                                                Text(
                                                                  " ${item['commentsNumber']}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xff474747),
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            vm.clickLike(item);
                                                          },
                                                          child: Container(
                                                            width:
                                                                getWidthPx(150),
                                                            padding: EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              textBaseline:
                                                                  TextBaseline
                                                                      .ideographic,
                                                              children: [
                                                                likeIco(
                                                                    color: item['isLike'] ==
                                                                            1
                                                                        ? AppTheme
                                                                            .themeBlue
                                                                        : Color(
                                                                            0xff474747),
                                                                    size: 20),
                                                                Text(
                                                                  " ${item['likesNumber']}",
                                                                  style: TextStyle(
                                                                      color: item['isLike'] == 1
                                                                          ? AppTheme
                                                                              .themeBlue
                                                                          : Color(
                                                                              0xff474747)),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    : Center(child: Text("暂无记录")),
                          )),
                      Offstage(
                        offstage: !vm.isShow,
                        child: Container(
                          color: Color(0xffF5F5F5),
                          child: vm.busy
                              ? loadingWidget()
                              : vm.industryList.length > 0
                                  ? ListView.builder(
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: vm.industryList.length,
                                      itemBuilder: (ctx, i) {
                                        var item = vm.industryList[i];
                                        List imgList =
                                            item["picture"].split(",");
                                        return InkWell(
                                          onTap: () {
                                            G.pushNamed(RoutePaths.News,
                                                arguments: item);
                                          },
                                          child: Container(
                                            margin: EdgeInsets.fromLTRB(
                                                10, 0, 10, 10),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8)),
                                            ),
                                            child: Padding(
                                              padding: const EdgeInsets.all(15),
                                              child: imgList.length > 1
                                                  ? Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text("${item['title']}",
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 2,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: 16,
                                                                color: Color(
                                                                    0xff4B4B4B))),
                                                        // SizedBox(height: 8),
                                                        // Expanded(
                                                        //   child: Text(
                                                        //     "${item['content']}",
                                                        //     style: TextStyle(fontSize: 14,color: Color(0xff4B4B4B)),
                                                        //     overflow: TextOverflow.ellipsis,),
                                                        // ),
                                                        // Expanded(
                                                        //   child: Html(
                                                        //       data:item['content'],
                                                        //       defaultTextStyle:TextStyle(fontSize: 14,color: Color(0xff4B4B4B)),
                                                        //   ),
                                                        // ),
                                                        SizedBox(height: 8),
                                                        GridView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                NeverScrollableScrollPhysics(),
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  3, //每行三列
                                                              childAspectRatio:
                                                                  1.0, //显示区域宽高相等
                                                              mainAxisSpacing:
                                                                  10,
                                                              crossAxisSpacing:
                                                                  10,
                                                            ),
                                                            itemCount:
                                                                imgList.length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              var i = imgList[
                                                                  index];
                                                              return Image
                                                                  .network(i,
                                                                      fit: BoxFit
                                                                          .fill);
                                                            }),
                                                        SizedBox(height: 8),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "${item['notarialName']}",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff888888)),
                                                            ),
                                                            Text(
                                                              "${item['createDate']}",
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff888888)),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )
                                                  : Row(
                                                      children: [
                                                        Image.network(
                                                          Config.splicingImageUrl(
                                                              item['picture']),
                                                          width:
                                                              getWidthPx(200),
                                                          height:
                                                              getWidthPx(200),
                                                          fit: BoxFit.fill,
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Expanded(
                                                          child: Container(
                                                            height:
                                                                getWidthPx(200),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Expanded(
                                                                  child: Text(
                                                                      "${item['title']}",
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      maxLines:
                                                                          2,
                                                                      style: TextStyle(
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              16,
                                                                          color:
                                                                              Color(0xff4B4B4B))),
                                                                ),
                                                                SizedBox(
                                                                    height: 8),
                                                                Text(
                                                                  "${item['notarialName']}",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff888888)),
                                                                ),
                                                                Text(
                                                                  "${item['createDate']}",
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff888888)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        );
                                      })
                                  : Center(child: Text("暂无记录")),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX; // X方向的偏移量
  double offsetY; // Y方向的偏移量
  CustomFloatingActionButtonLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}
