import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/page/mine/vm/add_address_view_model.dart';
import 'package:notarization_station_app/utils/debounce_button.dart';
import 'package:provider/provider.dart';

import '../../appTheme.dart';
// import 'widget/a_checkbox.dart';

class AddAddressPage extends StatefulWidget {
  final addressInfo;

  const AddAddressPage({Key key, this.addressInfo}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _AddAddressPageState();
  }
}

class _AddAddressPageState extends BaseState<AddAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: widget.addressInfo == null ? "新增地址" : "修改地址"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return ProviderWidget<AddAddressViewModel>(
            model: AddAddressViewModel(
                context, userModel.user, widget.addressInfo),
            onModelReady: (model) {},
            builder: (ctx, addressModel, child) {
              if (userModel.hasUser) {}
              return SingleChildScrollView(
                  child: Container(
                padding: EdgeInsets.only(
                    left: getWidthPx(20),
                    right: getWidthPx(20),
                    top: getWidthPx(20)),
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "联系人",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: addressModel.controllerName,
                            maxLength: 15,
                            decoration: const InputDecoration(
                              hintText: '请输入联系人',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppTheme.themeBlue),
                              ),
                            ),
                            style: const TextStyle(fontSize: 14),
                            // validator: (value) {
                            //   RegExp reg =
                            //       new RegExp("^[a-zA-Z\u4e00-\u9fa5]+\$");
                            //   if (!reg.hasMatch(value)) {
                            //     return '请输入汉字或英文';
                            //   }
                            //   return null;
                            // },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            "手机号",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: addressModel.controllerPhone,
                            maxLength: 18,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                            ], //只允许输入数字
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: '请输入手机号',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppTheme.themeBlue),
                              ),
                            ),
                            style: TextStyle(fontSize: 14),
                            //                              validator: (value) {
                            //                                RegExp reg = new RegExp(
                            //                                    '^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$');
                            //                                if (!reg.hasMatch(value)) {
                            //                                  return '请输入11位手机号码';
                            //                                }
                            //                                return null;
                            //                              },
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "详细地址",
                            style: TextStyle(fontSize: 16),
                          ),
                          TextFormField(
                            controller: addressModel.controllerDetail,
                            maxLength: 50,
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              hintText: '请输入详细地址',
                              focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppTheme.themeBlue),
                              ),
                            ),
                            style: TextStyle(fontSize: 14),
                            // validator: (value) {
                            //   // RegExp reg = new RegExp(
                            //   //     '^[,.，。（）()#-a-zA-Z0-9\u4e00-\u9fa5]+\$');
                            //   // if (value.isEmpty) {
                            //   //   return '请输入详细地址';
                            //   // } else if (!reg.hasMatch(value)) {
                            //   //   return '不能含有特殊字符';
                            //   // }
                            //   // return null;
                            // },
                          ),
                        ],
                      ),
                      SizedBox(height: getHeightPx(20)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: addressModel.isDefAddress,
                              onChanged: (value) {
                                addressModel
                                    .setDefAddress(!addressModel.isDefAddress);
                              }),
                          Text('默认地址',
                              style: TextStyle(
                                color: addressModel.isDefAddress
                                    ? AppTheme.themeBlue
                                    : AppTheme.deactivatedText,
                                fontSize: getSp(28),
                              ))
                        ],
                      ),
                      DebounceButton(
                        clickTap: addressModel.isEnable
                            ? () {
                                if (_formKey.currentState.validate()) {
                                  widget.addressInfo == null
                                      ? addressModel.addAddress()
                                      : addressModel.editAddress();
                                }
                              }
                            : null,
                        isEnable: addressModel.isEnable,
                        margin: EdgeInsets.only(top: 40),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        borderRadius: BorderRadius.circular(10),
                        child: Text(
                          widget.addressInfo == null ? "确认新增" : "确认修改",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ));
            },
          );
        },
      ),
    );
  }
}
