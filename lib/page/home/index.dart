import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/infomation/vm/community_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../utils/common_tools.dart';

class HomeIndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    wjPrint('Platform.version-----${Platform.version}');
    return HomeIndexState();
  }
}

class HomeIndexState extends BaseState<HomeIndexPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  TelAndSmsService _service = locator<TelAndSmsService>();
  ScrollController scrollController = ScrollController();
  List imgList = [
    "lib/assets/images/banner1.png",
    // "lib/assets/images/banner.png"
  ];

  List menuData = [
    {
      'image': 'lib/assets/images/自助办证.png',
      'title': '自助办证',
    },
    {
      'image': 'lib/assets/images/视频办证.png',
      'title': '视频办证',
    },
    {
      'image': 'lib/assets/images/多方公证.png',
      'title': '多方公证',
    },
    {
      'image': 'lib/assets/images/预约办证.png',
      'title': '预约办证',
    },
    {
      'image': 'lib/assets/images/公证会议室.png',
      'title': '公证会议',
    },
    // {
    //   'image': 'lib/assets/images/qukuailian.png',
    //   'title': '金融赋强',
    // },
  ];

  UserViewModel _userModel;
  CommunityModel communityModel;

  bool offstage = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          G.isColorFiltered ? Colors.grey : Colors.transparent,
          BlendMode.color),
      child: Scaffold(
        body: Consumer<UserViewModel>(
          builder: (ctx, userModel, child) {
            return ProviderWidget<CommunityModel>(
              model: CommunityModel(userModel),
              onModelReady: (model) {
                _userModel = userModel;
                communityModel = model;
                model.getList(1);
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
                      child: Column(
                        children: [
                          _topSwiperWidget,
                          _gridWidget,
                          _guideWidget,
                          _tabTitle(),
                          // _appBottomView(),
                          _professionWidget(),
                        ],
                      ),
                    ));
              },
            );
          },
        ),
      ),
    );
  }

  // 顶部轮播图
  Widget get _topSwiperWidget => SizedBox(
      height: getWidthPx(378),
      child: Image.asset(
        imgList[0],
        fit: BoxFit.fill,
      ));

  // 菜单视图
  Widget get _gridWidget => ColoredBox(
        color: Colors.white,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: GridView.builder(
              itemCount: menuData.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 0,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    _judgeLogin(judgeResult: () {
                      switch (index) {
                        case 0:
                          G.pushNamed(RoutePaths.Explain, arguments: 1);
                          break;
                        case 1:
                          G.pushNamed(RoutePaths.Explain, arguments: 2);
                          break;
                        case 2:
                          G.pushNamed(RoutePaths.Explain, arguments: 3);
                          break;
                        case 3:
                          G.pushNamed(RoutePaths.Appointment);
                          break;
                        case 4:
                          G.pushNamed(RoutePaths.VideoConference);
                          break;
                          // default:
                          //   G.pushNamed(RoutePaths.financialNotarization);
                          // G.pushNamed(RoutePaths.SmallMoneyPage);
                          break;
                      }
                    }, loginCallBack: () {
                      G.getCurrentState().pushNamedAndRemoveUntil(
                          RoutePaths.LOGIN, (router) => router == null);
                    }, alertResult: () {
                      return ToastUtil.showWarningToast("请先实名认证");
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        menuData[index]['image'],
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Text(
                        menuData[index]['title'],
                        style: TextStyle(
                            color: AppTheme.textBlack_3,
                            fontSize: getWidthPx(24)),
                      ),
                    ],
                  ),
                );
              }),
        ),
      );

  /// 办证指引
  Widget get _guideWidget => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: getWidthPx(18),
          ),
          InkWell(
            onTap: () {
              _service.call("4008001820");
            },
            child: SizedBox(
              height: getWidthPx(85),
              child: ColoredBox(
                color: Colors.white,
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: getWidthPx(30), right: getWidthPx(30)),
                      child: Image.asset(
                        "lib/assets/images/news_icon.png",
                        width: getWidthPx(40),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Expanded(
                        child: Text(
                      "申办帮助或业务咨询：4008001820",
                      style: TextStyle(
                          color: AppTheme.textBlack_3,
                          fontSize: getWidthPx(30)),
                    )),
                    // Image.asset(
                    //   "lib/assets/images/more.png",
                    //   width: getWidthPx(26),
                    //   height: getWidthPx(26),
                    // ),
                    // SizedBox(
                    //   width: getWidthPx(20),
                    // ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: getWidthPx(18),
          ),
          SizedBox(
            height: getWidthPx(224),
            child: ColoredBox(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      G.pushNamed(RoutePaths.Guide);
                    },
                    child: Container(
                      height: getWidthPx(160),
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      decoration: BoxDecoration(
                          color: AppTheme.textBlue_1,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "办证指引",
                                style: TextStyle(
                                    color: AppTheme.textBlue_3,
                                    fontSize: getSp(30)),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  "查看公证申办指引",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: getSp(24),
                                      color: AppTheme.textBlack_4),
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: getWidthPx(10)),
                          Image.asset("lib/assets/images/guide.png",
                              width: getWidthPx(80), height: getWidthPx(80)),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _judgeLogin(judgeResult: () {
                        G.pushNamed(RoutePaths.NotaryOffice);
                      }, loginCallBack: () {
                        G.getCurrentState().pushNamedAndRemoveUntil(
                            RoutePaths.LOGIN, (router) => router == null);
                      }, alertResult: () {
                        G.pushNamed(RoutePaths.NotaryOffice);
                      });
                    },
                    child: Container(
                      height: getWidthPx(160),
                      padding: EdgeInsets.fromLTRB(10, 8, 10, 8),
                      decoration: BoxDecoration(
                          color: AppTheme.textOrange,
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          )),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "公证介绍",
                                style: TextStyle(
                                    color: AppTheme.textOrange_1,
                                    fontSize: getSp(30)),
                              ),
                              const SizedBox(height: 4),
                              Expanded(
                                child: Text(
                                  "公证处及公证事项\n信息",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: getSp(24),
                                      color: AppTheme.textBlack_4),
                                ),
                              )
                            ],
                          ),
                          SizedBox(width: getWidthPx(10)),
                          Image.asset("lib/assets/images/int.png",
                              width: getWidthPx(80), height: getWidthPx(80)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  /// appBar bottomView
  ///
  ///
  // Widget _appBottomView() => SizedBox(
  //       width: MediaQuery.of(context).size.width,
  //       height: getWidthPx(90),
  //       child: ColoredBox(
  //         color: Colors.white,
  //         child: Row(children: [
  //           Padding(
  //             padding: const EdgeInsets.only(left: 15),
  //             child: InkWell(
  //               onTap: () {
  //                 communityModel.isShow = false;
  //                 communityModel.getList(0);
  //                 setState(() {});
  //               },
  //               child: Container(
  //                   alignment: Alignment.center,
  //                   padding: EdgeInsets.symmetric(vertical: 10),
  //                   decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       border: Border(
  //                           bottom: BorderSide(
  //                               width: 3,
  //                               color: communityModel.isShow
  //                                   ? Colors.white
  //                                   : AppTheme.textBlue))),
  //                   child: Text(
  //                     "公证问答",
  //                     style: TextStyle(
  //                         fontSize:
  //                             !communityModel.isShow ? getSp(30) : getSp(28),
  //                         fontWeight: !communityModel.isShow
  //                             ? FontWeight.bold
  //                             : FontWeight.normal),
  //                   )),
  //             ),
  //           ),
  //           InkWell(
  //             onTap: () {
  //               communityModel.isShow = true;
  //               communityModel.getList(1);
  //               setState(() {});
  //             },
  //             child: Container(
  //                 alignment: Alignment.center,
  //                 margin: EdgeInsets.symmetric(horizontal: 15),
  //                 padding: EdgeInsets.symmetric(vertical: 10),
  //                 decoration: BoxDecoration(
  //                     color: Colors.white,
  //                     border: Border(
  //                         bottom: BorderSide(
  //                             width: 3,
  //                             color: communityModel.isShow
  //                                 ? AppTheme.textBlue
  //                                 : Colors.white))),
  //                 child: Text("行业动态",
  //                     style: TextStyle(
  //                         fontSize:
  //                             communityModel.isShow ? getSp(30) : getSp(28),
  //                         fontWeight: communityModel.isShow
  //                             ? FontWeight.bold
  //                             : FontWeight.normal))),
  //           ),
  //           const Spacer(),
  //           InkWell(
  //             onTap: () {
  //               // _judgeIdentify(judgeResult: () {
  //               //   Navigator.pushNamed(context, RoutePaths.Quiz)
  //               //       .then((value) => communityModel.getList(0));
  //               // }, alertResult: () {
  //               //   return ToastUtil.showWarningToast("请先实名认证后，再进行提问");
  //               // });
  //               _judgeLogin(judgeResult: () {
  //                 // G.pushNamed(RoutePaths.NotaryOffice);
  //                 Navigator.pushNamed(context, RoutePaths.Quiz)
  //                     .then((value) => communityModel.getList(0));
  //               }, loginCallBack: () {
  //                 G.getCurrentState().pushNamedAndRemoveUntil(
  //                     RoutePaths.LoginTypeFile, (router) => router == null);
  //               }, alertResult: () {
  //                 return ToastUtil.showWarningToast("请先实名认证后，再进行提问");
  //               });
  //             },
  //             child: const Padding(
  //                 padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
  //                 child: Text("进入提问",
  //                     style:
  //                         TextStyle(fontSize: 14, color: AppTheme.textBlue))),
  //           ),
  //         ]),
  //       ),
  //     );

  Widget _tabTitle() => Container(
    color: Colors.white,
    margin: EdgeInsets.only(top: getWidthPx(20)),
    padding:  EdgeInsets.only(left: getWidthPx(30),bottom: getWidthPx(20)),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: getWidthPx(20),
          ),
          Text(
            "行业动态",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );


  /// 行业动态
  Widget _professionWidget() => MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: communityModel.industryList.length,
          itemBuilder: (ctx, i) {
            var item = communityModel.industryList[i];
            List imgList = item["picture"].split(",");
            return InkWell(
              onTap: () {
                // _judgeIdentify(alertResult: () {
                //   return ToastUtil.showWarningToast("请先实名认证!");
                // }, judgeResult: () {
                //   G.pushNamed(RoutePaths.News, arguments: item);
                // });
                _judgeLogin(judgeResult: () {
                  // G.pushNamed(RoutePaths.NotaryOffice);
                  G.pushNamed(RoutePaths.News, arguments: item);
                }, loginCallBack: () {
                  G.getCurrentState().pushNamedAndRemoveUntil(
                      RoutePaths.LOGIN, (router) => router == null);
                }, alertResult: () {
                  return ToastUtil.showWarningToast("请先实名认证！");
                });
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: imgList.length > 1
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${item['title'] ?? ''}",
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                  color: Color(0xff4B4B4B))),
                          const SizedBox(height: 8),
                          GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3, //每行三列
                                childAspectRatio: 1.0, //显示区域宽高相等
                                mainAxisSpacing: 10,
                                crossAxisSpacing: 10,
                              ),
                              itemCount: imgList.length,
                              itemBuilder: (context, index) {
                                var i = imgList[index];
                                return Image.network(i, fit: BoxFit.fill);
                              }),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item['notarialName'] ?? ''}",
                                style: TextStyle(color: Color(0xff888888)),
                              ),
                              Text(
                                "${item['createDate'] ?? ''}",
                                style: TextStyle(color: Color(0xff888888)),
                              ),
                            ],
                          ),
                        ],
                      )
                    : Row(
                        children: [
                          Image.network(
                            Config.splicingImageUrl(item['picture']),
                            width: getWidthPx(200),
                            height: getWidthPx(200),
                            fit: BoxFit.fill,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: getWidthPx(200),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text("${item['title'] ?? ''}",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 16,
                                            color: Color(0xff4B4B4B))),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "${item['notarialName'] ?? ''}",
                                    style: TextStyle(color: Color(0xff888888)),
                                  ),
                                  Text(
                                    "${item['createDate'] ?? ''}",
                                    style: TextStyle(color: Color(0xff888888)),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            );
          }));

  /// 是否实名
  void _judgeIdentify({Function alertResult, Function judgeResult}) {
    if (_userModel.idCard == null || _userModel.idCard == "") {
      //未实名
      if (alertResult != null) {
        alertResult.call();
      }
    } else {
      // 实名
      if (judgeResult != null) {
        judgeResult.call();
      }
    }
  }

  /// 是否登录
  /// judgeResult: 登录和实名认证成功后进入回调
  /// loginCallBack：进入登录界面
  /// alertResult
  void _judgeLogin(
      {Function judgeResult, Function loginCallBack, Function alertResult}) {
    /// 未登录
    if (!_userModel.hasUser) {
      if (loginCallBack != null) {
        loginCallBack.call();
      }
      // _judgeIdentify(judgeResult: judgeResult, alertResult: alertResult);
      /// 登录
    } else {
      _judgeIdentify(judgeResult: judgeResult, alertResult: alertResult);
    }
  }

  @override
  bool get wantKeepAlive => true;
}
