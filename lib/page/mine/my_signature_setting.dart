import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/login/entity/userInfo.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:provider/provider.dart';
import 'vm/signature_view_model.dart';
import 'widget/signature_card.dart';

class MySignatureSettingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MySignatureSettingPageState();
  }
}

class MySignatureSettingPageState extends BaseState<MySignatureSettingPage> {

  SignatureViewModel _viewModel;

  UserInfoEntity _userInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "我的签章"),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          _userInfo = userViewModel.user;
          return ProviderWidget<SignatureViewModel>(
            model: SignatureViewModel(),
            onModelReady: (model) {
              _viewModel = model;
              _viewModel.getSignatureList();
            },
            builder: (context, vm, child) {
              return ColoredBox(
                color: AppTheme.bg_b,
                child: Column(
                  children: [
                    Expanded(
                      child: _viewModel.signatures.isNotEmpty ?  ListView.builder(
                        itemCount: vm.signatures.length,
                        itemBuilder: (context, index) {
                          final entity = vm.signatures[index];
                          return SignatureCard(
                            entity: entity,
                            onToggle: (value){
                              vm.updateSignatureStatus(index);
                            },
                            userInfo: _userInfo,
                            onEdit: () {
                              Navigator.pushNamed(context, RoutePaths.mySignatureApply,arguments: {"isUpdate":true,"entity":entity}).then((value){
                                _viewModel.getSignatureList();
                              });
                            },
                            onDelete: (){
                              vm.deleteSignature(index);
                            },
                          );
                        },
                      ) : GestureDetector(
                        onTap: (){
                          _viewModel.getSignatureList();
                        },
                        child: Container(
                          color: AppTheme.bg_b,
                          alignment: Alignment.center,
                            child: Text('暂无数据')),
                      ),
                    ),
                     Container(
                      margin:
                      EdgeInsets.only(bottom: 32, top: 10, left: 16, right: 16),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF1890FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 0,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RoutePaths.mySignatureApply,arguments: {"isUpdate":false,"entity":null}).then((value){
                            _viewModel.getSignatureList();
                          });
                        },
                        child: Text('申请签章'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

