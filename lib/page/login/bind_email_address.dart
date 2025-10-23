

import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/widget/a_button/index.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/bind_email_address_viewmodel.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';

class BindEmailAddress extends StatefulWidget {
  final String phoneNumber;
  const BindEmailAddress({Key key,this.phoneNumber}) : super(key: key);

  @override
  State<BindEmailAddress> createState() => _BindEmailAddressState();
}

class _BindEmailAddressState extends BaseState<BindEmailAddress> {

  BindEmailAddressViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: commonAppBar(title: '绑定邮箱'),
      body: Consumer<UserViewModel>(builder: (context,userViewModel,child){
        return ProviderWidget(
          builder: (context,viewModel,child){
          return Container(
            color: Colors.white,
            width: getWidthPx(750),
            height: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: getWidthPx(40)),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: [
                      const Spacer(),
                      Container(
                        margin: EdgeInsets.only(
                            top: getHeightPx(10), bottom: getHeightPx(10)),
                        alignment: Alignment.center,
                        width: 250,
                        height: 250,
                        child: Image.asset('lib/assets/images/logoimg.png',
                            fit: BoxFit.contain),
                      ),
                      const Spacer(),
                    ],
                  ),
                  mainWidget(),
                  /// 注册
                  DebounceButton(
                    isEnable: viewModel.isEnable,
                    clickTap: () {
                      viewModel.bindEmail();
                    },
                    margin: EdgeInsets.only(
                        top: getWidthPx(50),
                        left: getWidthPx(40),
                        right: getWidthPx(40)),
                    padding: EdgeInsets.all(10),
                    backgroundColor: AppTheme.themeBlue,
                    disableColor: Colors.grey,
                    borderRadius:
                    BorderRadius.all(Radius.circular(5)),
                    child: Text('确认',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppTheme.nearlyWhite)),
                  ),
                ],
              ),
            ),
          );
        },
          model: BindEmailAddressViewModel(),
          onModelReady: (viewModel){
            this.viewModel = viewModel;
            this.viewModel.phoneNumber = widget.phoneNumber;
          },
          child: child,
        );
      }),
    );
  }

  Widget mainWidget() {
    return Column(
      children: <Widget>[
        //手机号码
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    children: [
                      TextSpan(
                          text: '邮        箱',
                          style: TextStyle(fontSize: 14, color: Colors.black))
                    ])),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: getWidthPx(30), right: getWidthPx(30)),
                height: 40,
                decoration: BoxDecoration(border: borderBottom()),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: this.viewModel.emailController,
                  maxLength: 50,
                  decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    hintText: '请输入邮箱',
                    hintStyle: TextStyle(
                        fontSize: getSp(26),
                        color: Color(0xFF999999)
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            RichText(
                text: TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                    children: [
                      TextSpan(
                          text: '验  证  码',
                          style:
                          TextStyle(fontSize: 14, color: Colors.black))
                    ])),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                    left: getWidthPx(30), right: getWidthPx(30)),
                height: 40,
                decoration: BoxDecoration(border: borderBottom()),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: viewModel.emailCodeController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        // inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9]'))],//只允许输入数字
                        decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: '请输入邮箱验证码',
                            hintStyle: TextStyle(
                                fontSize: getSp(26),
                                color: Color(0xFF999999)
                            )),
                      ),
                    ),
                    Container(
                      height: 25,
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(
                                  color: rgba(242, 242, 242, 1)))),
                    ),
                    buildGetEmailCode(0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// 获取验证码
  Container buildGetEmailCode(int index) {
    return Container(
        child: AButton.normal(
            onPressed: viewModel.codeCountdownStr == "获取验证码"
                ? () {
              // 邮箱验证码
              viewModel.getImgCode(myContext: context);
            }
                : null,
            child: Text(
               viewModel.codeCountdownStr,
              style: TextStyle(fontSize: getSp(26)),
            ),
            color: AppTheme.themeBlue));
  }

  Border borderBottom() {
    return Border(bottom: BorderSide(color: Color(0xFFD7D7D7), width: 1));
  }
}
