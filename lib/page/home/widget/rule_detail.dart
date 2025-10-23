import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:provider/provider.dart';

class RuleDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RuleDetailPageState();
  }
}

class RuleDetailPageState extends BaseState<RuleDetailPage>
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
      appBar: commonAppBar(title: "在线受理服务使用规则"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return SingleChildScrollView(
            padding:
                EdgeInsets.only(left: getWidthPx(20), right: getWidthPx(10)),
//            width: getWidthPx(750),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: getHeightPx(20),
                ),
                Text(
                    """   在此特别提醒您（用户）在注册成为青桐智盒用户之前，请认真阅读本《用户服务协议》（以下简称“协议”），确保您充分理解本协议中各条款。请您审慎阅读并选择接受或不接受本协议。除非您接受本协议所有条款，否则您无权注册、登录或使用本协议所涉服务。
     您的注册、登录、使用等行为将视为对本协议的接受，并同意接受本协议各项条款的约束。
   一、账号注册
      1、鉴于青桐智盒账号的绑定注册方式，您同意青桐智盒在注册时将允许您的手机号码及手机设备识别码等信息用于注册。
      2、在用户注册及使用本服务时，青桐智盒需要搜集能识别用户身份的个人信息以便青桐智盒可以在必要时联系用户，或为用户提供更好的使用体验。青桐智盒搜集的信息包括但不限于用户的姓名、身份证号。
      3、为了确保用户可以正常使用该服务，用户需保证正常授权。
   二、账户安全
      1、用户一旦注册成功，成为青桐智盒的用户，将得到一个用户名和密码，并有权利使用自己的用户名及密码随时登录青桐智盒APP。
   三、服务内容
      1、青桐智盒具体服务内容由青桐智盒提供。
      2、青桐智盒将根据实际情况发布推送各类信息。
      3、所有发给用户的通告及其他消息都可通过App或者用户所提供的联系方式发送。
   四、服务的终止
      1、在下列情况下，青桐智盒有权终止向用户提供服务：
       1）在用户违反本服务协议相关规定时，青桐智盒有权终止向该用户提供服务。
       2）用户不得通过程序或人工方式进行对本App破解及其它危害本App的操作，若发现用户有该类行为，青桐智盒将立即终止服务，并有权追究法律责任。
   五、免责与赔偿声明
      1、请用户在使用过程中，对自己的账号密码妥善保管，不要告知他人，避免给您带来不必要的损失。
      2、本协议最终解释权归青桐智盒所有。
      3、本协议从2020年4月15日起适用。"""),
                SizedBox(
                  height: getHeightPx(40),
                ),
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
