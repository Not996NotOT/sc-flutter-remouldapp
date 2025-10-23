import 'package:color_dart/RgbaColor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/widget/a_button/index.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/iconfont/Icon.dart';
import 'package:notarization_station_app/page/login/vm/modify_psd_view_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/utils/common_tools.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
import '../../utils/ServiceLocator.dart';
import '../../utils/TelAndSmsService.dart';

class ModifyPasswordPage extends StatefulWidget {

 final  String title;
 final  String phoneNumber;

  ModifyPasswordPage({Key key,this.title = '找回密码',this.phoneNumber}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _ModifyPasswordPageState();
  }
}

class _ModifyPasswordPageState extends BaseState<ModifyPasswordPage>
    with SingleTickerProviderStateMixin {
  UserViewModel userModel;
  ModifyPsdViewModel viewModel;

  TelAndSmsService _service = locator<TelAndSmsService>();

  TabController _tabController;

  String titleString = '';

  String isAbroad = '';

  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    titleString = widget.title;
    isAbroad = "手机号";
    phoneNumber = widget.phoneNumber;
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    viewModel.countdownTimer?.cancel();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: titleString),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          this.userModel = userModel;
          return ProviderWidget<ModifyPsdViewModel>(
            model: ModifyPsdViewModel(userModel),
            onModelReady: (model) {
              viewModel = model;
              viewModel.setSelectData(isAbroad,phoneNumber: phoneNumber);
              viewModel.isCodeTap = true;
              _tabController.animateTo(0);
            },
            builder: (ctx, mineModel, child) {
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ColoredBox(
                    color: Colors.white,
                    child: Column(
                      children: [
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
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30),
                          child: TabBar(
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.grey,
                            indicatorColor: Colors.blue,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorWeight: 3,
                            labelStyle: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                            unselectedLabelStyle: TextStyle(fontSize: 15),
                            indicatorPadding: EdgeInsets.only(
                                bottom: getHeightPx(10), top: getHeightPx(10)),
                            labelPadding: EdgeInsets.only(
                                bottom: getHeightPx(10), top: getHeightPx(10)),
                            controller: _tabController,
                            tabs: [
                              Tab(
                                text: "手机号",
                              ),
                              Tab(
                                text: "邮箱",
                              ),
                            ],
                            onTap:  (index) {
                              index == 0
                                  ? viewModel.setSelectData('手机号',phoneNumber: phoneNumber)
                                  : viewModel.setSelectData('邮箱',phoneNumber: phoneNumber);
                            },
                          ),
                        ),
                        buildWidget(),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget buildSecondWidget() {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
            child: Text(
              "     非大陆11位手机号账号，需要重置密码请联系4008001820",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          DebounceButton(
            isEnable: !viewModel.isLoading,
            borderRadius: BorderRadius.circular(5),
            margin: EdgeInsets.only(
                top: getWidthPx(50),
                left: getWidthPx(110),
                right: getWidthPx(100)),
            padding: EdgeInsets.all(10),
            child: Text(
              '立即拨打',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
            clickTap: () {
              _service.call("4008001820");
            },
          ),
        ],
      ),
    );
  }

  Widget buildWidget() {
    return Column(
      children: <Widget>[
       viewModel.selectData == '手机号' ? Row(
         mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidthPx(40)),
              child: RichText(
                  text: TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      children: [
                    TextSpan(
                        text: '手机号码',
                        style: TextStyle(fontSize: 14, color: Colors.black))
                  ])),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(
                     right: getWidthPx(30)),
                height: 45,
                decoration: BoxDecoration(border: borderBottom()),
                child: TextField(
                  keyboardType: TextInputType.number,
                  maxLength: 11,
                  readOnly: isEditing("手机号"),
                  // ignore: deprecated_member_use
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ], //只允许输入数字
                  controller: viewModel.phoneC,
                  decoration: InputDecoration(
                    counterText: "",
                    border: InputBorder.none,
                    hintText: '请输入手机号码',
                    hintStyle: TextStyle(
                      fontSize: getSp(26),
                    ),
                  ),
                  onChanged: (v) {
                    viewModel.phoneBool =
                        viewModel.phoneC.text.length < 11 ? false : true;
                    viewModel.notifyListeners();
                  },
                ),
              ),
            )
          ],
        ) : Row(
         children: [
           Padding(
             padding: EdgeInsets.symmetric(horizontal: getWidthPx(40)),
             child: RichText(
                 text: TextSpan(
                     text: '*',
                     style: TextStyle(color: Colors.red, fontSize: 14),
                     children: [
                       TextSpan(
                           text: '账      号',
                           style: TextStyle(fontSize: 14, color: Colors.black))
                     ])),
           ),
           Expanded(
             child: Container(
               margin: EdgeInsets.only(
                    right: getWidthPx(30)),
               height: 45,
               decoration: BoxDecoration(border: borderBottom()),
               child: TextField(
                 keyboardType: TextInputType.number,
                 // ignore: deprecated_member_use
                 inputFormatters: [
                   FilteringTextInputFormatter.digitsOnly
                 ], //只允许输入数字
                 readOnly: isEditing('邮箱'),
                 controller: viewModel.phoneC,
                 decoration: InputDecoration(
                   counterText: "",
                   border: InputBorder.none,
                   hintText: '请输入账号',
                   hintStyle: TextStyle(
                     fontSize: getSp(26),
                   ),
                 ),
               ),
             ),
           )
         ],
       ),

        /// 验证码
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidthPx(40)),
              child: RichText(
                  text: TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      children: [
                    TextSpan(
                        text: '验  证  码',
                        style: TextStyle(fontSize: 14, color: Colors.black))
                  ])),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: getWidthPx(30)),
                height: 45,
                decoration: BoxDecoration(border: borderBottom()),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: viewModel.selectData == '手机号' ?  TextField(
                        controller: viewModel.codeC,
                        inputFormatters: [
                          // ignore: deprecated_member_use
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: '请输入短信验证码',
                            hintStyle: TextStyle(
                              fontSize: getSp(26),
                            )),
                      ) : TextField(
                        controller: viewModel.emailCodeController,
                        maxLength: 6,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          // ignore: deprecated_member_use
                          FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                        ],
                        decoration: InputDecoration(
                            counterText: '',
                            border: InputBorder.none,
                            hintText: '请输入邮箱验证码',
                            hintStyle: TextStyle(
                              fontSize: getSp(26),
                            )),
                      ),
                    ),
                    Container(
                      height: 25,
                      decoration: BoxDecoration(
                          border: Border(
                              left: BorderSide(color: rgba(242, 242, 242, 1)))),
                    ),
                  viewModel.selectData == '手机号' ? buildGetEmailCode() : buildAbroadGetEmailCode(),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidthPx(40)),
              child: RichText(
                  text: TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      children: [
                    TextSpan(
                        text: '设置密码',
                        style: TextStyle(fontSize: 14, color: Colors.black))
                  ])),
            ),
            Expanded(
              child: Container(
                  margin: EdgeInsets.only(right: getWidthPx(30)),
                  height: 45,
                  decoration: BoxDecoration(border: borderBottom()),
                  child: TextField(
                    maxLength: 20,
                    controller: viewModel.selectData == '手机号' ? viewModel.psdC : viewModel.abroadPswC,
                    keyboardType: TextInputType.text,
                    obscureText: viewModel.selectData == '手机号' ? !viewModel.passwordShow : !viewModel.abroadPasswordShow,
                    decoration: InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                        hintText: '输入8位以上有效密码',
                        hintStyle: TextStyle(
                          fontSize: getSp(26),
                        ),
                        suffixIcon: IconButton(
                            icon: '手机号' == viewModel.selectData ? (viewModel.passwordShow
                                ? visibilityIco(color: Colors.grey)
                                : visibilityOffIco(color: Colors.grey)) : (viewModel.abroadPasswordShow
                                ? visibilityIco(color: Colors.grey)
                                : visibilityOffIco(color: Colors.grey)),
                            onPressed: () {
                             '手机号' == viewModel.selectData ? viewModel.passwordShow = !viewModel.passwordShow : viewModel.abroadPasswordShow = !viewModel.abroadPasswordShow;
                              viewModel.notifyListeners();
                            })),
                  )),
            ),
          ],
        ),
        // 确认密码
        Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: getWidthPx(40)),
              child: RichText(
                  text: TextSpan(
                      text: '*',
                      style: TextStyle(color: Colors.red, fontSize: 14),
                      children: [
                    TextSpan(
                        text: '确认密码',
                        style: TextStyle(fontSize: 14, color: Colors.black))
                  ])),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(right: getWidthPx(30)),
                height: 45,
                decoration: BoxDecoration(border: borderBottom()),
                child: TextField(
                  maxLength: 20,
                  controller: viewModel.selectData == "手机号" ? viewModel.psdAgainC : viewModel.abroadPswAgainC,
                  keyboardType: TextInputType.text,
                  obscureText: viewModel.selectData == "手机号" ? !viewModel.password2Show : !viewModel.abroadPassword2Show,
                  decoration: InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                      hintText: '请再次输入密码',
                      hintStyle: TextStyle(
                        fontSize: getSp(26),
                      ),
                      suffixIcon: IconButton(
                          icon: viewModel.selectData =='手机号' ? (viewModel.password2Show
                              ? visibilityIco(color: Colors.grey)
                              : visibilityOffIco(color: Colors.grey)) : (viewModel.abroadPassword2Show ? visibilityIco(color: Colors.grey)
                              : visibilityOffIco(color: Colors.grey)),
                          onPressed: () {
                           viewModel.selectData == "手机号" ? viewModel.password2Show = !viewModel.password2Show : viewModel.abroadPassword2Show = !viewModel.abroadPassword2Show;
                            viewModel.notifyListeners();
                          })),
                ),
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(top: 10, left: 40, right: 20),
          child: Center(
            child: Text(
              '''密码必须包含大写字母、小写字母、数字、特殊字符其中三种''',
              style: TextStyle(
                fontSize: getSp(26),
              ),
            ),
          ),
        ),

        DebounceButton(
          isEnable: !viewModel.isLoading,
          borderRadius: BorderRadius.circular(5),
          margin: EdgeInsets.only(
              top: getWidthPx(50),
              left: getWidthPx(110),
              right: getWidthPx(100)),
          padding: EdgeInsets.all(10),
          child: Text(
            '确认修改',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          clickTap: () {
            viewModel.amendPsw();
          },
        ),
      ],
    );
  }

  /// 判断用户账号是否可以编辑
  bool  isEditing(String nationType){
    bool isEdit;
    if(titleString == "重置密码" && phoneNumber!=null && phoneNumber.isNotEmpty == true ){
      isEdit = true;
    }else{
      isEdit =  false;
    }
    wjPrint("$nationType ----- $isEdit");
    return isEdit;
  }

  /// 国内手机获取验证码
  Container buildGetEmailCode() {
    return Container(
        child: AButton.normal(
            onPressed: viewModel.isCodeTap
                ? () {
              viewModel.getImageCode(context);
                  }
                : null,
            child: Text(viewModel.codeCountdownStr),
            color: viewModel.isCodeTap
                ? AppTheme.themeBlue
                : AppTheme.themeBlue.withOpacity(0.8)));
  }

  /// 国外邮箱获取验证码
  Container buildAbroadGetEmailCode() {
    return Container(
        child: AButton.normal(
            onPressed: viewModel.isAbroadCodeTap
                ? () {
              viewModel.getImgCode(notSetEmail: (){
                showEmailAlert(context);
              },myContext: context);
            }
                : null,
            child: Text(viewModel.abroadCodeCountdownStr),
            color: viewModel.isAbroadCodeTap
                ? AppTheme.themeBlue
                : AppTheme.themeBlue.withOpacity(0.8)));
  }

  void showEmailAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return Material(
            color: Colors.black.withAlpha(100),
            child: Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  children: [
                    const Spacer(),
                    Text(
                      '温馨提示',
                      style:
                      TextStyle(fontSize: 20, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Text(
                      titleString == '找回密码' ? '您尚未绑定邮箱，请联系公证员进行绑定' : '您尚未绑定邮箱，请进行邮箱绑定',
                      style:
                      TextStyle(fontSize:  15, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),

                            decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              '取消',
                              style: TextStyle(
                                  fontSize:  15, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            if(titleString == "找回密码"){
                              viewModel.service.call("4008001820");
                            }else{
                              G.pushNamed(RoutePaths.bindEmailAddress,arguments: {"phoneNumber":phoneNumber});
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                            decoration: BoxDecoration(
                                color: AppTheme.themeBlue,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              '确认',
                              style: TextStyle(
                                  fontSize:  15, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Border borderBottom() {
    return Border(bottom: BorderSide(color: Color(0xFF999999), width: 1));
  }
}
