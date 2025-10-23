import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:provider/provider.dart';

class DianziNamePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return DianziNamePageState();
  }
}

class DianziNamePageState extends BaseState<DianziNamePage>
    with AutomaticKeepAliveClientMixin {
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
    return Scaffold(
      appBar: commonAppBar(title: "电子签名服务告知条款"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return SingleChildScrollView(
            padding:
                EdgeInsets.only(left: getWidthPx(20), right: getWidthPx(10)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: getHeightPx(20),
                ),
                Text(
                    """   当您选择开始公证的时候，您同意采用电子签名的方式，签署公证过程中所形成的法律文书，并同意由您或授权他人向江苏智慧数字认证申请电子签名认证证书，自愿遵守其电子认证业务规则。您保证提交的申请资料真实、准确、完整，愿意承担由于资料虚假失实而导致的一切后果。"""),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
