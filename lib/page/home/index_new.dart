import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/refresh_helper.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/infomation/vm/community_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config.dart';

class IndexNew extends StatefulWidget {
  const IndexNew();

  @override
  State<IndexNew> createState() => _IndexNewState();
}

class _IndexNewState extends BaseState<IndexNew> with AutomaticKeepAliveClientMixin{
  UserViewModel _userModel;
  CommunityModel communityModel;

  TelAndSmsService _service = locator<TelAndSmsService>();

  SharedPreferences prefs;

  List menuData = [
    {
      'image': 'lib/assets/images/self_service_certificate.png',
      'title': '自助办证',
    },
    {
      'image': 'lib/assets/images/video_certification.png',
      'title': '视频办证',
    },
    {
      'image': 'lib/assets/images/multi_party_notarization.png',
      'title': '多方公证',
    },
    {
      'image': 'lib/assets/images/appointment_certificate.png',
      'title': '预约办证',
    },
    {
      'image': 'lib/assets/images/notary_meeting.png',
      'title': '公证会议',
    },
    {
      'image': 'lib/assets/images/judicial_expertise.png',
      'title': '司法鉴定',
    },
    // {
    //   'image': 'lib/assets/images/qukuailian.png',
    //   'title': '金融赋强',
    // },
  ];
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
          G.isColorFiltered ? Colors.grey : Colors.transparent,
          BlendMode.color),
      child: Consumer<UserViewModel>(builder: (context, userModel, child) {
        return ProviderWidget<CommunityModel>(
          model: CommunityModel(userModel),
          onModelReady: (model) {
            _userModel = userModel;
            communityModel = model;
            model.getList(1);
          },
          builder: (context, vm, child) {
            return SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: HomeRefreshHeader(Colors.black),
              footer: RefresherFooter(),
              controller: vm.refreshController,
              onRefresh: vm.refresh,
              onLoading: vm.loadMore,
              child: SingleChildScrollView(
                child: Stack(
                  children: [
                    Image.asset(
                      "lib/assets/images/home_back_new.png",
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      fit: BoxFit.fill,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        topTitle,
                        bonerContainer,
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // 顶部文字显示
  Widget get topTitle => Row(
        children: [
          Padding(
            padding:
                EdgeInsets.only(top: getHeightPx(110), left: getWidthPx(50)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '青桐智盒',
                  style: TextStyle(fontSize: 28),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  '智慧公证MINI一体机',
                  style: TextStyle(fontSize: 17, color: Color(0xFFB8C1CE)),
                ),
              ],
            ),
          ),
          const Spacer()
        ],
      );

  // 下方圆角显示
  Widget get bonerContainer => Container(
        padding: EdgeInsets.only(left: getWidthPx(30), right: getWidthPx(30)),
        margin: EdgeInsets.only(top: getWidthPx(60)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15), topRight: Radius.circular(15)),
          boxShadow: [
            BoxShadow(
                color: AppTheme.dark_grey.withAlpha(10),
                blurRadius: 8,
                offset: Offset(0, -10))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _gridWidget,
            _guideWidget,
            guideAndIntroduceWidget,
            _tabTitle(),
            _professionWidget(),
          ],
        ),
      );

  // 菜单视图
  Widget get _gridWidget => ColoredBox(
        color: Colors.transparent,
        child: MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: GridView.builder(
              itemCount: menuData.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    if (index != 5) {
                      _judgeLogin(judgeResult: () {
                        switch (index) {
                          case 0:
                            if(_userModel.idCard != null && _userModel.idCard.length == 18){
                              String userBirthDay = G.getBirthDayFromCardId(_userModel.idCard);
                              int userAge = G.getAgeFromBirthday(userBirthDay);
                              if (userAge >= 18){
                                G.pushNamed(RoutePaths.Explain, arguments: 1);
                              } else {
                                ToastUtil.showToast('当前检测到你的年龄未满18周岁暂无法办理当前业务');
                              }
                            } else {
                              G.pushNamed(RoutePaths.Explain, arguments: 1);
                            }
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
                          // case 6:
                          //   G.pushNamed(RoutePaths.financialNotarization);
                          //   break;
                        }
                      }, loginCallBack: () {
                        G.getCurrentState().pushNamedAndRemoveUntil(
                            RoutePaths.LOGIN, (router) => router == null);
                      }, alertResult: () {
                        return ToastUtil.showWarningToast("请先实名认证");
                      });
                    } else {
                     var prefs = await SharedPreferences.getInstance();
                      bool isOne = prefs.getBool("isOne");
                      if(isOne!=null && !isOne){
                        G.pushNamed(RoutePaths.judicialExpertise);
                      }else{
                        requestPrivacy();
                      }
                    }
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
                            fontSize: getWidthPx(28)),
                      ),
                    ],
                  ),
                );
              }),
        ),
      );

  /// 申办帮助或业务咨询：4008001820
  Widget get _guideWidget => InkWell(
        child: Container(
          margin: EdgeInsets.only(
              left: getWidthPx(20), right: getWidthPx(20), top: getWidthPx(40)),
          height: 45,
          decoration: BoxDecoration(
              color: Color(0xFFF6F9FE),
              borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: getWidthPx(16), right: getWidthPx(30)),
                child: Image.asset(
                  "lib/assets/images/announcement.png",
                  width: getWidthPx(40),
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                  child: Text(
                "申办帮助或业务咨询：4008001820",
                style: TextStyle(
                    color: AppTheme.textBlack_3, fontSize: getWidthPx(30)),
              )),
            ],
          ),
        ),
        onTap: () {
          _service.call("4008001820");
        },
      );

  /// 办证帮助或公证介绍
  Widget get guideAndIntroduceWidget => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: getWidthPx(20), vertical: getWidthPx(40)),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                  height: 85,
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("lib/assets/images/home_guide.png"),
                        fit: BoxFit.fill),
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "办证指引",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height:3,
                        ),
                        Text(
                          "查看公证申办指引 >",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFF5681D8), fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  G.pushNamed(RoutePaths.Guide);
                },
              ),
            ),
            const SizedBox(
              width: 11,
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                child: Container(
                  height: 85,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image:
                            AssetImage("lib/assets/images/home_introduce.png"),
                        fit: BoxFit.fill),
                    color: Colors.transparent,
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10, bottom: 10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "公证介绍",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Text(
                          "公证处及公证事项信息 >",
                          style:
                              TextStyle(fontSize: 12, color: Color(0xFFAF9065),fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  ),
                ),
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
              ),
            )
          ],
        ),
      );

  Widget _tabTitle() => Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: getWidthPx(20), bottom: getWidthPx(20)),
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
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withAlpha(10),
                          offset: Offset(0, 10))
                    ]),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        Config.splicingImageUrl(item['picture']),
                        errorBuilder: (ctx,obj,tra){
                          return SizedBox(
                            width: getWidthPx(200),
                            height: getWidthPx(200),
                            child: ColoredBox(
                              color: AppTheme.bg_b,
                            ),
                          );
                        },
                        width: getWidthPx(200),
                        height: getWidthPx(200),
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      width: 20,
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
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
