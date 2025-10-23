// import 'dart:async';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
// import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
// import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
// import 'package:notarization_station_app/service_api/home_api.dart';
// import 'package:notarization_station_app/service_api/infomation_api.dart';
// import 'package:notarization_station_app/service_api/helper_api.dart';
// import 'package:notarization_station_app/utils/global.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:http_parser/http_parser.dart';
//
// class StarModel extends SingleViewStateModel {
//   UserViewModel userModel;
//   TextEditingController textEditingController = TextEditingController();
//   StarModel(this.userModel);
//
//   String orderId='';
//   String remarks='';
//   String score ='';
//   bool isBool = true;
//
//   addScore(){
//       if(!isBool){
//         return ;
//       }
//       // ToastUtil.showWarningToast(" orderId:"+orderId+
//       //     " remarks:"+textEditingController.text+
//       //     " score:"+score);
//
//       if(textEditingController.text.isNotEmpty){
//         isBool = false;
//
//         Map<String, dynamic> map = {
//           "orderId":orderId, //订单id
//           "remarks":textEditingController.text, //备注
//           "score":score, //评分
//           // "updateUserId":'', //修改用户Id
//         };
//         HelperApi.getSingleton().getEvaluateAdd(map).then((res){
//           isBool = true;
//           wjPrint('===============================');
//           ToastUtil.showErrorToast("执行这里说明可以调网络");
//           ToastUtil.showErrorToast("res['code']:"+res["code"]);
//           if(res["code"]==200){
//             ToastUtil.showErrorToast("评价已提交");
//             G.getCurrentState().pop("refresh");
//           }else if(res["code"]==4001){
//             ToastUtil.showErrorToast(res["message"]);
//           }else{
//             ToastUtil.showErrorToast(res["data"]);
//           }
//         });
//       }else{
//         ToastUtil.showWarningToast("请填写评价"+textEditingController.text);
//       }
//   }
//
//   @override
//   onCompleted(data) {}
//
//   @override
//   Future loadData() {
//     return null;
//   }
// }
