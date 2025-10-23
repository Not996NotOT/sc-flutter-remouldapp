import 'package:flutter/material.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';
import 'package:notarization_station_app/utils/ServiceLocator.dart';
import 'package:notarization_station_app/utils/TelAndSmsService.dart';
import 'package:provider/provider.dart';

class NotaryDetailPage extends StatefulWidget {
  final arguments;
  NotaryDetailPage({Key key, this.arguments}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return NotaryDetailPageState();
  }
}

class NotaryDetailPageState extends BaseState<NotaryDetailPage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  final TelAndSmsService _service = locator<TelAndSmsService>();
  List notaryPublicList = [];
  String isOnTap = "";
  @override
  void initState() {
    super.initState();
    getNotaryOffice();
  }

  getNotaryOffice() async {
    Map<String, dynamic> map = {"notaryId": widget.arguments['unitGuid']};
    var res = await InformationApi.getSingleton()
        .getNotaryPublic(map, errorCallBack: (e) {});
    if (res['code'] == 200) {
      notaryPublicList = res['item'];
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        appBar:
            commonAppBar(title: "${widget.arguments['notarialName'] ?? ''}"),
        backgroundColor: AppTheme.white,
        body: Consumer<UserViewModel>(builder: (ctx, userModel, child) {
          return SingleChildScrollView(
            child: ColoredBox(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                      colors: AppTheme.App_bar,
                    )),
                    child: Row(
                      children: [
                        Image.asset("lib/assets/images/logo.png",
                            width: getWidthPx(160)),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.arguments['notarialName'] ?? ''}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4),
                                  child: Row(
                                    children: [
                                      Image.asset("lib/assets/images/位置详情.png",
                                          width: 12),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Expanded(
                                          child: Text(
                                              "${widget.arguments['address'] ?? ''}",
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white)))
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Image.asset("lib/assets/images/距离详情.png",
                                        width: 12),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                        "距你${double.parse(widget.arguments['distance'] ?? "0") / 1000}km",
                                        style: const TextStyle(
                                            fontSize: 14, color: Colors.white))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                            onTap: () {
                              if (widget.arguments['contactNumber'] != null &&
                                  widget
                                      .arguments['contactNumber'].isNotEmpty) {
                                _service.call(
                                    "${widget.arguments['contactNumber']}");
                              }
                            },
                            child: Image.asset("lib/assets/images/电话详情.png",
                                width: 28)),
                        const SizedBox(
                          width: 18,
                        )
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    constraints: BoxConstraints(
                      minHeight: 100.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "公证处简介",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "    ${widget.arguments['description'] ?? "暂无简介"}",
                          style: const TextStyle(color: Color(0xff8C8C8C)),
                        )
                      ],
                    ),
                  ),
                  Container(
                      width: getWidthPx(750),
                      padding: EdgeInsets.all(10),
                      child: const Text(
                        "公证员",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      )),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: notaryPublicList.length < 1
                        ? const Text("暂无人员")
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: notaryPublicList.length,
                            itemBuilder: (ctx, a) {
                              var item = notaryPublicList[a];
                              return Container(
                                width: getWidthPx(750),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: const Border(
                                      bottom: BorderSide(
                                          width: 1, color: AppTheme.bg_b)),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: getWidthPx(120),
                                      height: getWidthPx(120),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(getWidthPx(81))),
                                        border: Border.all(
                                            width: getWidthPx(10),
                                            color: Colors.white),
                                      ),
                                      child: ClipOval(
                                        child: item['headIcon'] == null
                                            ? Image.asset(
                                                "lib/assets/images/on-boy.jpg",
                                                width: getWidthPx(100),
                                                fit: BoxFit.fill)
                                            : Image.network(
                                                Config.splicingImageUrl(
                                                    item['headIcon']),
                                                width: getWidthPx(100),
                                                fit: BoxFit.fill),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "${item['userName'] ?? "某某公证员"}",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4),
                                              child: Text(
                                                  "${item['mobile'] ?? '暂无'}",
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      color:
                                                          AppTheme.Text_min)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              //   Stack(
                              //   children: [
                              //     item['headIcon']==null?InkWell(
                              //         child: Image.asset("lib/assets/images/on-boy.jpg",width: (getWidthPx(750)-46)/3,height: (getWidthPx(750)-46)/3,fit: BoxFit.fill))
                              //         :InkWell(
                              //         child: Image.network(Config.splicingImageUrl(item['headIcon']),width: (getWidthPx(750)-46)/3,height: (getWidthPx(750)-46)/3,fit: BoxFit.fill)),
                              //     Positioned(
                              //       bottom: 0,
                              //       child: Container(
                              //         width: (getWidthPx(750)-46)/3,
                              //         height: 40,
                              //         color: Color(0xbb21B5FF),
                              //         padding: EdgeInsets.symmetric(horizontal: 10),
                              //         child: Column(
                              //           mainAxisSize : MainAxisSize.min,
                              //           mainAxisAlignment : MainAxisAlignment.center,
                              //           children: [
                              //             Expanded(child: Text("${item['userName']}",style: TextStyle(color: Colors.white,fontSize: getSp(28)),)),
                              //             Text("${item['mobile']}",style: TextStyle(color: Colors.white,fontSize: getSp(28))),
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //     InkWell(
                              //       onTap: (){
                              //         isOnTap = isOnTap==item['unitGuid']?"":item['unitGuid'];
                              //         setState(() {});
                              //       },
                              //       child: AnimatedOpacity(
                              //         opacity: isOnTap==item['unitGuid']?1.0:0.0,
                              //         duration: new Duration(seconds: 1),
                              //         child: Container(
                              //           width: (getWidthPx(750)-46)/3,
                              //           height: (getWidthPx(750)-46)/3,
                              //           color: Color(0xDD2A5082),
                              //           child: Column(
                              //             mainAxisAlignment : MainAxisAlignment.center,
                              //             children: [
                              //               Text("${item['userName']}",style: TextStyle(color: Colors.white),),
                              //               Text("${item['mobile']}",style: TextStyle(color: Colors.white)),
                              //               SizedBox(height: 10),
                              //               InkWell(
                              //                 onTap: (){
                              //                   showDialog(
                              //                       context: context,
                              //                       builder: (context) {
                              //                         return AlertDialog(
                              //                           title: Text("提示"),
                              //                           content: Text(
                              //                               "您确定要向公证员${item['userName']}发起好友申请？"),
                              //                           actions: <Widget>[
                              //                             FlatButton(
                              //                               child: Text("取消"),
                              //                               onPressed: () =>
                              //                                   Navigator.of(context)
                              //                                       .pop(), //关闭对话框
                              //                             ),
                              //                             FlatButton(
                              //                               child: Text("确定"),
                              //                               onPressed: () async {
                              //                                 Map<String, dynamic> map = {
                              //                                   "applicant": userModel.unitGuid, //申请人Id
                              //                                   "approvaler": item['unitGuid']
                              //                                 };
                              //                                 var res = await InformationApi.getSingleton().addFriend(map);
                              //                                 if (res['code'] == 200) {
                              //                                   ToastUtil.showNormalToast("已发送申请，等待同意");
                              //                                 }else{
                              //                                   ToastUtil.showNormalToast("已在审核中或已添加好友了");
                              //                                 }
                              //                                 Navigator.of(context).pop();
                              //                               },
                              //                             ),
                              //                           ],
                              //                         );
                              //                       });
                              //                 },
                              //                   child: Image.asset("lib/assets/images/好友申请.png",width: 24,height: 24, fit: BoxFit.fill,)
                              //               ),
                              //             ],
                              //           ),
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // );
                            }),
                  )
                ],
              ),
            ),
          );
        }));
  }

  @override
  bool get wantKeepAlive => true;
}
