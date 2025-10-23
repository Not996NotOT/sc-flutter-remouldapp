import 'package:amap_location_fluttify/amap_location_fluttify.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/page/home/entity/small_list_entity.dart';
import 'package:notarization_station_app/page/home/entity/small_material_entity.dart';
import 'package:notarization_station_app/page/home/small/small_new_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/utils/global.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SmallNewPage extends StatefulWidget {
  final SmallListItems route;

  const SmallNewPage({Key key, this.route}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SmallNewPageState();
  }
}

class SmallNewPageState extends BaseState<SmallNewPage>
    with AutomaticKeepAliveClientMixin {
  SmallNewModel viewModel;
  @override
  void initState() {
    super.initState();
  }

  // List<TextInputFormatter> keyType(String keyWordType){
  //   List<TextInputFormatter> verifyList = [];
  //   if(keyWordType=="1"){
  //     verifyList.add(WhitelistingTextInputFormatter(RegExp("[\u4e00-\u9fa5]")));
  //     verifyList.add(LengthLimitingTextInputFormatter(10));
  //   }else if(keyWordType=="2"){
  //     verifyList.add(WhitelistingTextInputFormatter(RegExp("[a-zA-Z]")));
  //     verifyList.add(LengthLimitingTextInputFormatter(10));
  //   } else if(keyWordType=="3"){
  //     verifyList.add(WhitelistingTextInputFormatter.digitsOnly);
  //     verifyList.add(LengthLimitingTextInputFormatter(10));
  //   }else if(keyWordType=="4"){
  //     verifyList.add(WhitelistingTextInputFormatter(RegExp("[0-9\u4e00-\u9fa5]")));
  //     verifyList.add(LengthLimitingTextInputFormatter(10));
  //   }else if(keyWordType=="5"){
  //     verifyList.add( WhitelistingTextInputFormatter(RegExp("[A-Za-z0-9]")));
  //     verifyList.add(LengthLimitingTextInputFormatter(10));
  //   }else if(keyWordType=="6"){
  //     verifyList.add(WhitelistingTextInputFormatter(RegExp("[A-Za-z0-9\u4e00-\u9fa5]")));
  //     verifyList.add(LengthLimitingTextInputFormatter(10));
  //   }
  //   return verifyList;
  // }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: commonAppBar(title: "区块链赋强详情"),
      body: Consumer<UserViewModel>(
        builder: (ctx, userModel, child) {
          return ProviderWidget<SmallNewModel>(
            model: SmallNewModel(userModel, widget.route),
            onModelReady: (model) {
              viewModel = model;
            },
            builder: (ctx, viewModel, child) {
              List<SmallListItemsHtml> infoList = widget.route.html;
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.all(getWidthPx(20)),
                        decoration: BoxDecoration(border: borderBottom()),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: 5,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: AppTheme.themeBlue,
                                    borderRadius: BorderRadius.circular(10))),
                            SizedBox(width: getWidthPx(10)),
                            Expanded(
                              child: Text(
                                "小额信息",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        )),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Text('用途',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Expanded(
                              child: Text(
                            widget.route.purpose,
                            style: TextStyle(
                                fontSize: 16, color: AppTheme.deactivatedText),
                            textAlign: TextAlign.right,
                          )),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Text('借款起始时间',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Expanded(
                              child: Text("${widget.route.loanStartDate ?? ""}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.deactivatedText),
                                  textAlign: TextAlign.right)),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Text("借款结束时间"),
                          Expanded(
                            child: Text(
                              "${widget.route.loanEndDate ?? ""}",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppTheme.deactivatedText),
                              textAlign: TextAlign.right,
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Text('期限',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Expanded(
                              child: Text("${widget.route.term ?? ""}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.deactivatedText),
                                  textAlign: TextAlign.right)),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Text('还款方式',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Expanded(
                              child: Text(widget.route.repaymentType,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.deactivatedText),
                                  textAlign: TextAlign.right)),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: AppTheme.bg_c)),
                      ),
                      margin: EdgeInsets.symmetric(horizontal: getWidthPx(10)),
                      padding: EdgeInsets.fromLTRB(getWidthPx(40),
                          getWidthPx(20), getWidthPx(40), getWidthPx(20)),
                      child: Row(
                        children: <Widget>[
                          Text('金额',
                              style: TextStyle(
                                fontSize: 16,
                              )),
                          Expanded(
                              child: Text("${widget.route.fee}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: AppTheme.deactivatedText),
                                  textAlign: TextAlign.right)),
                        ],
                      ),
                    ),
                    Container(
                      color: AppTheme.bg_e,
                      height: getWidthPx(20),
                    ),
                    infoList.length > 0
                        ? Container(
                            padding: EdgeInsets.all(getWidthPx(20)),
                            decoration: BoxDecoration(border: borderBottom()),
                            child: Row(
                              children: <Widget>[
                                Container(
                                    width: 5,
                                    height: 15,
                                    decoration: BoxDecoration(
                                        color: AppTheme.themeBlue,
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                SizedBox(width: getWidthPx(10)),
                                Expanded(
                                  child: Text(
                                    "财产信息",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                ),
                              ],
                            ))
                        : SizedBox(),
                    infoList.length > 0
                        ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: infoList.length,
                            itemBuilder: (ctx, i) {
                              return Column(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: AppTheme.bg_c)),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: getWidthPx(10)),
                                    padding: EdgeInsets.fromLTRB(
                                        getWidthPx(40),
                                        getWidthPx(20),
                                        getWidthPx(40),
                                        getWidthPx(20)),
                                    child: Row(
                                      children: <Widget>[
                                        Text('用户名',
                                            style: TextStyle(
                                              fontSize: 16,
                                            )),
                                        Expanded(
                                            child: Text("${infoList[i].name}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppTheme
                                                        .deactivatedText),
                                                textAlign: TextAlign.right)),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              width: 1, color: AppTheme.bg_c)),
                                    ),
                                    margin: EdgeInsets.symmetric(
                                        horizontal: getWidthPx(10)),
                                    padding: EdgeInsets.fromLTRB(
                                        getWidthPx(40),
                                        getWidthPx(20),
                                        getWidthPx(40),
                                        getWidthPx(20)),
                                    child: Row(
                                      children: <Widget>[
                                        Text('担保方式',
                                            style: TextStyle(
                                              fontSize: 16,
                                            )),
                                        Expanded(
                                            child: Text(
                                                "${infoList[i].mortgageType}",
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: AppTheme
                                                        .deactivatedText),
                                                textAlign: TextAlign.right)),
                                      ],
                                    ),
                                  ),
                                  infoList[i].mortgageType != "连带保证"
                                      ? Container(
                                          decoration: BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1,
                                                    color: AppTheme.bg_c)),
                                          ),
                                          margin: EdgeInsets.symmetric(
                                              horizontal: getWidthPx(10)),
                                          padding: EdgeInsets.fromLTRB(
                                              getWidthPx(40),
                                              getWidthPx(20),
                                              getWidthPx(40),
                                              getWidthPx(20)),
                                          child: Row(
                                            children: <Widget>[
                                              Text('财产',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  )),
                                              Expanded(
                                                  child: Text(
                                                      "${infoList[i].property}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: AppTheme
                                                              .deactivatedText),
                                                      textAlign:
                                                          TextAlign.right)),
                                            ],
                                          ),
                                        )
                                      : SizedBox(),
                                  Container(
                                    color: AppTheme.bg_e,
                                    height: getWidthPx(20),
                                  ),
                                ],
                              );
                            })
                        : SizedBox(),
                    Container(
                        padding: EdgeInsets.all(getWidthPx(20)),
                        decoration: BoxDecoration(border: borderBottom()),
                        child: Row(
                          children: <Widget>[
                            Container(
                                width: 5,
                                height: 15,
                                decoration: BoxDecoration(
                                    color: AppTheme.themeBlue,
                                    borderRadius: BorderRadius.circular(10))),
                            SizedBox(width: getWidthPx(10)),
                            Expanded(
                              child: Text(
                                "材料",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                            ),
                          ],
                        )),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: viewModel.materialList.length,
                        itemBuilder: (ctx, i) {
                          SmallMaterialEntity item = viewModel.materialList[i];
                          return Column(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(getWidthPx(10)),
                                  width: double.infinity,
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.name,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  )),
                              GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, //每行三列
                                    childAspectRatio: 1.0, //显示区域宽高相等
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10,
                                  ),
                                  itemCount: item.data.length + 1,
                                  itemBuilder: (context, index) {
                                    return releaseImage(
                                        index == item.data.length,
                                        index != item.data.length
                                            ? item.data
                                            : null,
                                        index,
                                        item.name);
                                  }),
                            ],
                          );
                        }),
                    SizedBox(
                      height: getWidthPx(30),
                    ),
                    InkWell(
                      onTap: () async {
                        if(!await Permission.speech.status.isGranted || !await Permission.camera.status.isGranted || !await Permission.storage.status.isGranted){
                          G.showCustomToast(
                              context: context,
                              titleText: "相机、麦克风、存储权限说明：",
                              subTitleText: "用于视频通话、语音录制、拍照、录像、文件存储等场景",
                              time: 2
                          );
                        }
                        final status = await Permission.speech.request();
                        if (status == PermissionStatus.granted) {
                          final cameraS = await Permission.camera.request();
                          if (cameraS == PermissionStatus.granted) {
                            final storageS = await Permission.storage.request();
                            if (storageS == PermissionStatus.granted) {
                              final status1 =
                                  await Permission.location.request();
                              if (status1 == PermissionStatus.granted) {
                                Location location =
                                    await AmapLocation.instance.fetchLocation();
                                viewModel.latLng =
                                    "${location.latLng.longitude},${location.latLng.latitude}";
                                viewModel.submitVideo();
                              }
                            }
                          }
                        }
                      },
                      child: Container(
                        width: getWidthPx(670),
                        margin: EdgeInsets.fromLTRB(
                            getWidthPx(40), 0, getWidthPx(40), getWidthPx(10)),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: AppTheme.themeBlue,
                        ),
                        child: Center(
                          child: Text('发起公证',
                              style: TextStyle(
                                  fontSize: 16, color: AppTheme.nearlyWhite)),
                        ),
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

  @override
  bool get wantKeepAlive => false;

  Widget releaseImage(
      bool isDef, List<SmallMaterialData> img, int num, String name) {
    return isDef
        ? InkWell(
            onTap: () {
              viewModel.isUpdate = true;
              viewModel.requestCameraPermission(name);
            },
            child: Image.asset("lib/assets/images/add_img.png",
                width: 400, height: 400))
        : Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    img[num].annexId,
                    width: 400,
                    height: 400,
                  ),
                ),
              ),
              !isDef
                  ? Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                          onTap: () {
                            viewModel.isUpdate = true;
                            viewModel.delImg(img[num].imgPath, num, name);
                            viewModel.notifyListeners();
                          },
                          child: Icon(Icons.clear, color: Colors.redAccent)))
                  : SizedBox(width: 0, height: 0)
            ],
          );
  }

  Border borderBottom() {
    return Border(bottom: BorderSide(color: AppTheme.bg_c, width: 1));
  }
}
