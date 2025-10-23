/*
* 全局性provider
* 可以在此配置 全局性model
* eg: user.model et.
*
* */

import 'package:notarization_station_app/page/mine/vm/apk_update_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../page/login/vm/user_view_model.dart';

List<SingleChildWidget> providers = [
  ...independentServices,
  ...dependentServices,
];

/// 应用级 独立 model(通过consumer 可以在任意页面获取到)
List<SingleChildWidget> independentServices = [
//  ///这里应该放入一个购物车
//  ChangeNotifierProvider<GlobalCartGoodsModel>.value(value:
//  GlobalCartGoodsModel()),
  ///2020.3.10  目前应该没有购物车等可以与用户绑定,这里将用户model抽到上层
  ChangeNotifierProvider<UserViewModel>.value(value: UserViewModel()),
  ChangeNotifierProvider<ApkUpdateModel>.value(value: ApkUpdateModel()),
];

/// 需要依赖的model,下方注释代码为例子
/// eg :UserModel 购物车model的组合（如购物车与用户ID绑定）
List<SingleChildWidget> dependentServices = [
//  ChangeNotifierProxyProvider<GlobalCartGoodsModel, UserModel>(
//    update: (context, globalCartGoodsModel, userModel) =>
//    userModel ?? UserModel(globalCartGoodsModel: globalCartGoodsModel),
//  ),
//
//  ChangeNotifierProxyProvider<UserModel,StoreModel>(
//    update: (context,userModel,storeModel)
//    => storeModel ?? StoreModel(userModel: userModel,cartGoodsModel: userModel.globalCartGoodsModel),
//  ),
];
