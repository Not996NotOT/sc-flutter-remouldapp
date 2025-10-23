import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/infomation/vm/detail_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:provider/provider.dart';

class InfoDetailPage extends StatefulWidget {
  final arguments;
  const InfoDetailPage({Key key, this.arguments}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return InfoDetailPageState();
  }
}

class InfoDetailPageState extends BaseState<InfoDetailPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: commonAppBar(title: "消息详情"),
      backgroundColor: AppTheme.chipBackground,
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return ProviderWidget<InfoDetailPageModel>(
            model: InfoDetailPageModel(widget.arguments),
            onModelReady: (model) {
              model.loadData();
            },
            builder: (ctx, viewModel, child) {
              ///我顶层定义的有 refresh的属性，可以用这个方法获得，并不一定非要这么写
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        margin: EdgeInsets.only(
                            top: getHeightPx(40),
                            left: getWidthPx(40),
                            right: getWidthPx(40)),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                child: Text(
                              viewModel.arguments["title"] ?? '',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                            )),
                          ],
                        )),
                    Container(
                        margin: EdgeInsets.only(
                            top: getHeightPx(20), left: getWidthPx(40)),
                        child: Row(
                          children: <Widget>[
                            Text(
                              viewModel.arguments["notaryName"] ?? '',
                              style: TextStyle(
                                  color: Color(0xff5496e0),
                                  fontWeight: FontWeight.w700),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: getWidthPx(20)),
                              child: Text(
                                viewModel.arguments["date"] ??
                                    ''.toString().substring(0, 10),
                                style: TextStyle(
                                    color: Colors.black54,
                                    fontWeight: FontWeight.w500),
                              ),
                            )
                          ],
                        )),
                    SizedBox(
                      height: getHeightPx(20),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            left: getWidthPx(40), right: getWidthPx(40)),
                        child: Html(
                          data: viewModel.arguments["content"] ?? '',
                        )),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
