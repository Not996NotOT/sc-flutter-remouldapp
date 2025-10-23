/*
 * @Author: wangshibo1689@gmail.com WSBwsb123!@#
 * @Date: 2023-10-21 13:19:57
 * @LastEditors: wangshibo1689@gmail.com WSBwsb123!@#
 * @LastEditTime: 2023-10-21 15:06:26
 * @FilePath: /remouldApp/lib/page/home/vm/judicail_view_model.dart
 * @Description: 
 * 
 * Copyright (c) 2023 by ${git_name_email}, All Rights Reserved. 
 */

import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:notarization_station_app/service_api/home_api.dart';
import 'package:notarization_station_app/utils/global.dart';

class JudicialViewModel extends SingleViewStateModel {
  TextEditingController nameTextEditingController = TextEditingController();

  TextEditingController idCardTextEditingController = TextEditingController();

  bool isEndable = true;

  UserViewModel userViewModel;

  JudicialViewModel(UserViewModel viewModel) {
    userViewModel = viewModel;
    if (userViewModel.hasUser) {
      nameTextEditingController.text = userViewModel.userName;
      idCardTextEditingController.text = userViewModel.idCard;
      notifyListeners();
    }
  }
  
  /// 进入
   login(){
     // G.pushNamed(RoutePaths.caseHandle,arguments: {"idCard":idCardTextEditingController.text.replaceAll(" ", ""),"name":nameTextEditingController.text.replaceAll(" ", "")});
     // // print("---------${RegExp("[\u4e00-\u9fa5]").hasMatch(nameTextEditingController.text)}");
     // print("${nameTextEditingController.text.replaceAll(" ", "").replaceAll("•", "·")}");
     G.userIdCard = idCardTextEditingController.text.replaceAll(" ", "");
     G.userName = nameTextEditingController.text.replaceAll(" ", "").replaceAll("•", "·");
    if(G.userName.isEmpty){
      ToastUtil.showToast('请输入您的姓名');
    }else if(G.userIdCard.isEmpty || !RegexUtil.isIDCard18(G.userIdCard)){
      ToastUtil.showToast("请输入正确的证件号");
    }else{
      G.pushNamed(RoutePaths.caseHandle,arguments: {"idCard":G.userIdCard,"name":G.userName});
    }
   }

  selectHaveOrder(){
    EasyLoading.show();
    Map<String,dynamic> data = {
      "pageSize":999,
      'currentPage':1,
      'name':G.userName,
      'idCard': G.userIdCard,
    };
    HomeApi.getSingleton().selectHaveOrder(data,errorCallBack: (error){
      ToastUtil.showErrorToast("网络出错了，请稍后再试！");
      EasyLoading.dismiss();
      isEndable = true;
      notifyListeners();
    }).then((value){
      EasyLoading.dismiss();
      if(value!=null){
        if(value['code'] == 200){
          if(value['data'] !=null && value['data'].length > 0){
            G.userIdCard = idCardTextEditingController.text.replaceAll(" ", "");
            G.userName = nameTextEditingController.text.replaceAll(" ", "").replaceAll("•", "·");
            G.pushNamed(RoutePaths.caseHandle,arguments: {"idCard":idCardTextEditingController.text.replaceAll(" ", ""),"name":nameTextEditingController.text.replaceAll(" ", "")});
            isEndable = true;
            notifyListeners();
          }else{
            isEndable = true;
            notifyListeners();
            ToastUtil.showToast("没有查询到与您相关的司法鉴定信息");
          }
        }else{
          isEndable = true;
          notifyListeners();
          ToastUtil.showErrorToast("网络出错了，请稍后在试");
        }
      }else{
        isEndable = true;
        notifyListeners();
        ToastUtil.showErrorToast("网络出错了，请稍后在试");
      }
    });
  }

  @override
  Future loadData() {
    // throw UnimplementedError();
  }

  @override
  onCompleted(data) {
    throw UnimplementedError();
  }
  
  
}
