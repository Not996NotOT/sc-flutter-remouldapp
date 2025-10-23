import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/global.dart';

class GuidePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GuidePageState();
  }
}

class GuidePageState extends BaseState<GuidePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "办证指引"),
      backgroundColor: AppTheme.chipBackground,
      body: Container(
        width: getWidthPx(750),
        child: Column(
          children: [
            Container(
              height: getHeightPx(350),
              width: getWidthPx(750),
              padding: EdgeInsets.only(
                  left: getWidthPx(90),
                  top: getWidthPx(10),
                  right: getWidthPx(90),
                  bottom: getWidthPx(40)),
              decoration: BoxDecoration(
                  image: new DecorationImage(
                      image: new AssetImage("lib/assets/images/bzzn.png"),
                      fit: BoxFit.fill)),
              child: Center(
                  child: Text("    清楚自己办理的哪种公证的可以选择“自助公证”，不清楚的可以选择视频公证。",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.left)),
            ),
            InkWell(
              onTap: () {
                G.pushNamed(RoutePaths.GuideDetailPage, arguments: 1);
              },
              child: Container(
                height: getHeightPx(160),
                width: getWidthPx(650),
                margin: EdgeInsets.only(
                  top: getWidthPx(50),
                  left: getWidthPx(50),
                  right: getWidthPx(50),
                ),
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("lib/assets/images/自助公证_bg.png"),
                        fit: BoxFit.fill)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: getHeightPx(60),
                      width: getWidthPx(80),
                      margin: EdgeInsets.only(left: getWidthPx(40)),
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                              image:
                                  new AssetImage("lib/assets/images/自助公证.png"),
                              fit: BoxFit.contain)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "自助公证",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "自助公证是在明确自己所需公证的事项时，提供的快速办理通道。",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    )),
                    SizedBox(width: 10),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                G.pushNamed(RoutePaths.GuideDetailPage, arguments: 2);
              },
              child: Container(
                height: getHeightPx(160),
                width: getWidthPx(650),
                margin: EdgeInsets.only(
                  top: getWidthPx(50),
                  left: getWidthPx(50),
                  right: getWidthPx(50),
                ),
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("lib/assets/images/视频公证_bg.png"),
                        fit: BoxFit.fill)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: getHeightPx(60),
                      width: getWidthPx(80),
                      margin: EdgeInsets.only(left: getWidthPx(40)),
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                              image:
                                  new AssetImage("lib/assets/images/视频公证.png"),
                              fit: BoxFit.contain)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "视频公证",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "视频公证是与公证员面对面的进行你所需业务的快捷公证通道。",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    )),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                // G.pushNamed(RoutePaths.GuideDetailPage, arguments: 2);
                ToastUtil.showWarningToast("暂无介绍");
              },
              child: Container(
                height: getHeightPx(160),
                width: getWidthPx(650),
                margin: EdgeInsets.only(
                  top: getWidthPx(50),
                  left: getWidthPx(50),
                  right: getWidthPx(50),
                ),
                decoration: BoxDecoration(
                    image: new DecorationImage(
                        image: new AssetImage("lib/assets/images/合同公证_bg.png"),
                        fit: BoxFit.fill)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      height: getHeightPx(60),
                      width: getWidthPx(80),
                      margin: EdgeInsets.only(left: getWidthPx(40)),
                      decoration: BoxDecoration(
                          image: new DecorationImage(
                              image:
                                  new AssetImage("lib/assets/images/合同公证.png"),
                              fit: BoxFit.contain)),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "合同公证",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "合同公证是提供给合同双方的快捷视频公证通道。",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    )),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
