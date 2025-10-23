import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/page/home/vm/notary_extract_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:umeng_apm_sdk/umeng_apm_sdk.dart';

class NotaryExtractWidget extends StatefulWidget {
  final String unitGuid;
  final String unionnotaritionid;
  final String userName;
  final String idCard;
  final String token;
  final String notaryName;

  const NotaryExtractWidget(
      {Key key,
      this.unitGuid,
      this.unionnotaritionid,
      this.token,
      this.userName,
        this.notaryName,
      this.idCard})
      : super(key: key);

  @override
  State<NotaryExtractWidget> createState() => _NotaryExtractWidgetState();
}

class _NotaryExtractWidgetState extends State<NotaryExtractWidget> {
  NotaryExtractViewModel notaryExtractViewModel;

  @override
  void dispose() {
    notaryExtractViewModel.controller.dispose();
    notaryExtractViewModel.timer1?.cancel();
    notaryExtractViewModel.timer?.cancel();
    notaryExtractViewModel.timer2?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("案件办理", style: TextStyle(color: Colors.black)),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_outlined,
              color: Colors.black,
            ),
            onPressed: () {
              try {
                if (notaryExtractViewModel.filePath.isEmpty) {
                  FlutterScreenRecording.stopRecordScreen;
                }
                G.getCurrentState().pushNamedAndRemoveUntil(
                    RoutePaths.judicialExpertiseList, (route) => false);
              } catch (e) {
                ExceptionTrace.captureException(
                    exception: Exception(e),
                    extra: {"tag": "摇号界面返回时录屏报错", "error": e.toString()});
              }
            },
          ),
        ),
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF86B0F4), Color(0xFF5886EA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
          child: ProviderWidget<NotaryExtractViewModel>(
            builder: (context, viewModel, child) {
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: [
                        topWidgetAndTimer('${widget.notaryName ?? "南京市石城公证处"}'),
                        cardWidget(),
                        const Spacer(),
                        Padding(
                          padding: EdgeInsets.only(bottom: 40, top: 50),
                          child: Text(
                            "南京市涉保理赔司法鉴定公证摇号系统",
                            style: TextStyle(
                                color: AppTheme.white.withOpacity(0.8),
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
            model: NotaryExtractViewModel(
                unitGuid: widget.unitGuid,
                unionnotaritionid: widget.unionnotaritionid,
                notaryName: widget.notaryName,
                token: widget.token),
            onModelReady: (model) {
              notaryExtractViewModel = model;
              notaryExtractViewModel.loadData();
            },
          ),
        ),
      ),
    );
  }

  // 顶部文字展示和计时器
  Widget topWidgetAndTimer(String notaryName) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 25),
          child: Text(
            '本案件由$notaryName进行公证',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Text(
            '司法鉴定机构抽取',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // 中间card widget
  Widget cardWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      padding: const EdgeInsets.only(left: 5, right: 5, bottom: 30, top: 10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 15,left: 10,right: 10),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: Color(0xFF6F7988),
                  size: 20,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  widget.userName ?? '',
                  style: TextStyle(fontSize: 15, color: AppTheme.textBlack),
                ),
                const Spacer(),
                Image.asset(
                  "lib/assets/images/idcard_icon.png",
                  width: 20,
                  height: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  widget.idCard ?? '',
                  textAlign: TextAlign.end,
                  style: TextStyle(fontSize: 15, color: AppTheme.textBlack),
                ),
              ],
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                  height: 359,
                  width: 333,
                  padding: EdgeInsets.only(top: 88, bottom: 15),
                  margin: EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    // fit: BoxFit.fitHeight,
                    image: AssetImage(
                        'lib/assets/images/extract_background_select.png'),
                  )),
                  child: MediaQuery.removePadding(
                      removeTop: true,
                      removeBottom: true,
                      context: context,
                      child: PageView(
                        controller: notaryExtractViewModel.pageController,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          towRowListWidget(),
                          oneRowListWidget(),
                        ],
                      ))),
              Container(
                margin: const EdgeInsets.only(top: 15, right: 15),
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Color(0xFF7EA8F2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'lib/assets/images/timer_decrease.png',
                      width: 14,
                      height: 14,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      notaryExtractViewModel.tranTimer.isNotEmpty
                          ? notaryExtractViewModel.tranTimer.substring(1, 2)
                          : "0",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Text(
                        ':',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Text(
                      notaryExtractViewModel.tranTimer.isNotEmpty
                          ? notaryExtractViewModel.tranTimer.substring(2, 3)
                          : "0",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      notaryExtractViewModel.tranTimer.isNotEmpty
                          ? notaryExtractViewModel.tranTimer.substring(3, 4)
                          : "0",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          DebounceButton(
            isEnable: notaryExtractViewModel.isEnable,
            backgroundColor: AppTheme.themeBlue,
            disableColor: Colors.grey,
            padding: EdgeInsets.symmetric(vertical: 15),
            margin: EdgeInsets.symmetric(horizontal: 20),
            borderRadius: BorderRadius.circular(10),
            clickTap: () async {
              if (notaryExtractViewModel.btnString == '开始抽取') {
                notaryExtractViewModel.initAnimationTimer();
                notaryExtractViewModel.beginExtract();
              } else {
                notaryExtractViewModel.endLottery();
              }
            },
            child: Text(
              notaryExtractViewModel.btnString,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
          )
        ],
      ),
    );
  }

  Widget oneRowListWidget() {
    return IgnorePointer(
      child: CupertinoPicker(
        itemExtent: 70,
        scrollController: notaryExtractViewModel.fixedExtentScrollController,
        backgroundColor: Colors.transparent,
        selectionOverlay: const SizedBox(),
        diameterRatio: 5.0,
        magnification: 1.08,
        offAxisFraction: 0.0,
        squeeze: 1.1,
        looping: true,
        onSelectedItemChanged: (int index) {
          // 处理选择项变化的逻辑
        },
        children: notaryExtractViewModel.notaryList.map((notaryName) {
          int index = notaryExtractViewModel.notaryList.indexOf(notaryName);
          return Container(
            padding: notaryExtractViewModel.selectIndex == index
                ? const EdgeInsets.symmetric(horizontal: 10, vertical: 10)
                : const EdgeInsets.all(10),
            margin: notaryExtractViewModel.selectIndex == index
                ? const EdgeInsets.symmetric(horizontal: 15, vertical: 5)
                : const EdgeInsets.symmetric(horizontal: 10),
            width: MediaQuery.of(context).size.width - 40,
            height: notaryExtractViewModel.selectIndex == index ? 70 : 50,
            decoration: notaryExtractViewModel.selectIndex == index
                ? BoxDecoration(
                    image: DecorationImage(
                    fit: BoxFit.fitWidth,
                    image: AssetImage('lib/assets/images/notary_select.png'),
                  ))
                : null,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: notaryExtractViewModel.selectIndex == index
                          ? Color(0xFF1B65F0)
                          : Color(0xFF519AFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5),
                      )),
                  child: Text(
                    "${index + 1 > 9 ? index + 1 : "0${index + 1}"}",
                    style: TextStyle(
                        fontSize: notaryExtractViewModel.selectIndex == index
                            ? 18
                            : 12,
                        fontWeight: notaryExtractViewModel.selectIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: AppTheme.nearlyWhite),
                  ),
                ),
                Expanded(
                    child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  decoration: BoxDecoration(
                      color: notaryExtractViewModel.selectIndex == index
                          ? Color(0xFF4081FB)
                          : Color(0xFF7EA8F2),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(5),
                      )),
                  child: Text(
                    notaryName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: notaryExtractViewModel.selectIndex == index
                            ? 18
                            : 12,
                        fontWeight: notaryExtractViewModel.selectIndex == index
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: AppTheme.nearlyWhite),
                  ),
                ))
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // 中间 card widget tow row
  Widget towRowListWidget() {
    return ListView.builder(
      key: Key("twoRow"),
      itemCount: (notaryExtractViewModel.notaryList.length / 2).ceil(),
      controller: notaryExtractViewModel.controller,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(
            left: 11,
            right: 11,
            bottom: 15,
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [
                      Container(
                        width: 30,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFF519AFF),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            )),
                        child: Text(
                          "${index * 2 + 1 > 9 ? index * 2 + 1 : "0${index * 2 + 1}"}",
                          style: TextStyle(
                              fontSize: 12, color: AppTheme.nearlyWhite),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Color(0xFF7EA8F2),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(5),
                              bottomRight: Radius.circular(5),
                            )),
                        child: Text(
                          notaryExtractViewModel.notaryList[index * 2],
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14, color: AppTheme.nearlyWhite),
                        ),
                      ))
                    ],
                  )),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  flex: 1,
                  child:
                      index * 2 + 1 < notaryExtractViewModel.notaryList.length
                          ? Row(
                              children: [
                                Container(
                                  width: 30,
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF519AFF),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        bottomLeft: Radius.circular(5),
                                      )),
                                  child: Text(
                                    "${index * 2 + 2 > 9 ? index * 2 + 2 : "0${index * 2 + 2}"}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.nearlyWhite),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 40,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF7EA8F2),
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5),
                                        bottomRight: Radius.circular(5),
                                      )),
                                  child: Text(
                                    notaryExtractViewModel
                                        .notaryList[index * 2 + 1],
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: AppTheme.nearlyWhite),
                                  ),
                                ))
                              ],
                            )
                          : SizedBox())
            ],
          ),
        );
      },
    );
  }
}
