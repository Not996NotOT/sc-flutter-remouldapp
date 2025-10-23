import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:notarization_station_app/appTheme.dart';
import 'package:notarization_station_app/base_framework/widget/provider_widget.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/config.dart';
import 'package:notarization_station_app/page/infomation/vm/message_vm.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/routes/router.dart';
import 'package:provider/provider.dart';

import '../../utils/common_tools.dart';

class MessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MessagePageState();
  }
}

class MessagePageState extends BaseState<MessagePage>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
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
    return Consumer<UserViewModel>(builder: (ctx, userModel, child) {
      return ProviderWidget<MessageModel>(
          model: MessageModel(userModel),
          onModelReady: (model) {
            // model.getFriend();
            model.loadData();
          },
          builder: (ctx, vm, child) {
            return Scaffold(
              appBar: AppBar(
                elevation: 0.0,
                leading: Container(),
                backgroundColor: Colors.white,
                centerTitle: true,
                title: Text(
                  "消息通知",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
                // actions: [
                //   InkWell(
                //     onTap: (){
                //
                //     },
                //     child: Container(
                //       padding: EdgeInsets.symmetric(horizontal: 10),
                //       child: Icon(
                //           Icons.mail_outline,
                //         color: Colors.red,
                //       ),
                //     ),
                //   )
                // ],
              ),
              // endDrawer: Drawer(
              //     child: Column(
              //       crossAxisAlignment : CrossAxisAlignment.start,
              //       children: <Widget>[
              //         Container(
              //           height: getHeightPx(300),
              //           decoration: BoxDecoration(
              //             image: DecorationImage(
              //               fit: BoxFit.cover,
              //               image: NetworkImage(Config.splicingImageUrl(userModel.headIcon)),
              //             ),
              //           ),
              //           child: ClipRRect(
              //             child: BackdropFilter(
              //               filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              //               child: Container(
              //                 width: getWidthPx(750),
              //                color: Colors.black.withOpacity(0.2),
              //                child: Column(
              //                  mainAxisAlignment : MainAxisAlignment.center,
              //                  children: [
              //                    Container(
              //                      width: 70,
              //                      height: 70,
              //                      child: CircleAvatar(
              //                          backgroundImage: NetworkImage(Config.splicingImageUrl(userModel.headIcon))
              //                      ),
              //                    ),
              //                    Text("${userModel.userName}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
              //                    Text("${userModel.address}"),
              //                  ],
              //                ),
              //               ),
              //             ),
              //           ),
              //         ),
              //         Container(
              //           width: getWidthPx(750),
              //           padding: EdgeInsets.all(10),
              //           decoration: BoxDecoration(
              //             color: Colors.white,
              //             border: Border(
              //               bottom: BorderSide(width: 1,color: Color(0xffEBEBEB)),
              //             ),
              //           ),
              //           child: Text("好友列表",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 16),),
              //         ),
              //         MediaQuery.removePadding(
              //           removeTop: true,
              //           context: context,
              //           child: ListView.builder(
              //               shrinkWrap: true,
              //               physics:NeverScrollableScrollPhysics(),
              //               itemCount:  vm.friendList.length,
              //               itemBuilder: (ctx,a){
              //                 var item = vm.friendList[a];
              //                 return Container(
              //                   width: getWidthPx(750),
              //                   padding: EdgeInsets.all(10),
              //                   decoration: BoxDecoration(
              //                     color: Colors.white,
              //                     border: Border(
              //                       bottom: BorderSide(width: 1,color: Color(0xffEBEBEB)),
              //                     ),
              //                   ),
              //                   child: Row(
              //                     children: [
              //                       Expanded(
              //                           child: Text("${item['userName']}",style: TextStyle(fontSize: 14),)
              //                       ),
              //                       InkWell(
              //                         onTap: (){
              //                           vm.addChatList(item);
              //                           G.pop();
              //                           var map = {
              //                             "name": item['userName'],
              //                             "headIcon": item['headIcon'],
              //                             "unitGuid": item['friendId'],
              //                             "newest": "",
              //                             "newestTime": "16:47:13",
              //                             "messageNum": 0
              //                           };
              //                           Navigator.pushNamed(context, RoutePaths.Chat,arguments: map).then((value){
              //                             if(value=="refresh"){
              //                               // vm.openCallback();
              //                             }
              //                           });
              //                         },
              //                         child:  commentIco(
              //                           color:Color(0xff474747),
              //                         ),
              //                       )
              //                     ],
              //                   ),
              //                 );
              //               }
              //           ),
              //         )
              //       ],
              //     )),
              backgroundColor: AppTheme.chipBackground,
              body: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  width: getWidthPx(750),
                  color: Color(0xffEDEDED),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          // G.pushNamed(RoutePaths.MsgInform,arguments: 2);
                          Navigator.pushNamed(context, RoutePaths.MsgInform,
                                  arguments: 2)
                              .then((value) {
                            vm.getComment();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xffEBEBEB))),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "lib/assets/images/评论.png",
                                width: 18,
                                height: 18,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                "评论",
                                style: TextStyle(fontSize: 16),
                              )),
                              vm.commentNum > 0
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            width: 0, style: BorderStyle.none),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "${vm.commentNum}",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // G.pushNamed(RoutePaths.MsgInform,arguments: 1);
                          Navigator.pushNamed(context, RoutePaths.MsgInform,
                                  arguments: 1)
                              .then((value) {
                            vm.getLike();
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1, color: Color(0xffEBEBEB))),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                "lib/assets/images/点赞(2).png",
                                width: 18,
                                height: 18,
                                fit: BoxFit.fill,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: Text(
                                "点赞",
                                style: TextStyle(fontSize: 16),
                              )),
                              vm.likeNum > 0
                                  ? Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            width: 0, style: BorderStyle.none),
                                      ),
                                      child: Center(
                                          child: Text(
                                        "${vm.likeNum}",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    )
                                  : SizedBox()
                            ],
                          ),
                        ),
                      ),
                      // InkWell(
                      //   onTap: (){
                      //     // Navigator.pushNamed(context, RoutePaths.AddFriend).then((value){
                      //     //   vm.isOperation = 0;
                      //     //   if(value=="refresh"){
                      //     //     vm.applyFriend();
                      //     //     // vm.getFriend();
                      //     //   }
                      //     // });
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.all(15),
                      //     decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       border: Border(bottom: BorderSide(width: 1, color: Color(0xffEBEBEB))),
                      //     ),
                      //     child: Row(
                      //       children: [
                      //         Image.asset("lib/assets/images/好友申请.png",width: 18,height: 18, fit: BoxFit.fill,),
                      //         SizedBox(width: 10,),
                      //         Expanded(
                      //             child: Text("好友申请",style: TextStyle(fontSize: 16),)),
                      //         vm.applyNum==0?SizedBox():Container(
                      //           width: 20,
                      //           height: 20,
                      //           decoration: BoxDecoration(
                      //             color: Colors.red,
                      //             borderRadius: BorderRadius.all(
                      //                 Radius.circular(10)),
                      //             border: Border.all(width: 0, style: BorderStyle.none),
                      //           ),
                      //           child: Center(child: Text("${vm.applyNum}",style: TextStyle(color:Colors.white),)),
                      //         )
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.all(10),
                      //   width: getWidthPx(750),
                      //   decoration: BoxDecoration(
                      //     color: AppTheme.bg_b,
                      //     border: Border(bottom: BorderSide(width: 1, color: AppTheme.Text_a)),
                      //   ),
                      //   child: Text("会话列表",style: TextStyle(fontSize: 18),),
                      // ),
                      SizedBox(
                        height: 8,
                      ),
                      vm.chatList.length > 0
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: vm.chatList.length,
                              itemBuilder: (ctx, a) {
                                var item = vm.chatList[a];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(
                                            context, RoutePaths.Chat,
                                            arguments: item)
                                        .then((value) {
                                      wjPrint("-------9----$value");
                                      if (value == "refresh") {
                                        // vm.openCallback();
                                      }
                                    });
                                    if (item['messageId'] != "") {
                                      vm.getUnreadUpdate(item);
                                    }
                                    item['messageNum'] = 0;
                                    //SpUtil.putObjectList(userModel.unitGuid, vm.chatList);
                                    vm.notifyListeners();
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          width: 1, color: Color(0xffEBEBEB)),
                                    ),
                                    child: Slidable(
                                      actionPane:
                                          SlidableScrollActionPane(), //滑出选项的面板 动画
                                      actionExtentRatio: 0.25,
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          children: [
                                            Container(
                                              constraints:
                                                  BoxConstraints.expand(
                                                width: 50.0,
                                                height: 50.0,
                                              ),
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: item['headIcon'] ==
                                                            null
                                                        ? AssetImage(
                                                            "lib/assets/images/on-boy.jpg")
                                                        : NetworkImage(Config
                                                            .splicingImageUrl(item[
                                                                'headIcon']))),
                                                borderRadius:
                                                    BorderRadius.circular(25.0),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      "${item['name']}",
                                                      style: TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                    Text(
                                                      "${item['newestTime']}",
                                                      style: TextStyle(
                                                          color:
                                                              AppTheme.Text_a),
                                                    )
                                                  ],
                                                ),
                                                Text(
                                                  "${item['newest']}",
                                                  style: TextStyle(
                                                      color: AppTheme.Text_a),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )
                                              ],
                                            )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            item['messageNum'] != 0
                                                ? Container(
                                                    width: 20,
                                                    height: 20,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                      border: Border.all(
                                                          width: 0,
                                                          style:
                                                              BorderStyle.none),
                                                    ),
                                                    child: Center(
                                                        child: Text(
                                                      "${item['messageNum']}",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )),
                                                  )
                                                : SizedBox()
                                          ],
                                        ),
                                      ),
                                      secondaryActions: <Widget>[
                                        //右侧按钮列表
                                        // IconSlideAction(
                                        //   caption: 'More',
                                        //   color: Colors.black45,
                                        //   icon: Icons.more_horiz,
                                        //   onTap: (){
                                        //
                                        //   },
                                        // ),
                                        IconSlideAction(
                                          caption: '删除',
                                          color: Colors.red,
                                          icon: Icons.delete,
                                          closeOnTap: false,
                                          onTap: () {
                                            if (item['messageId'] != "") {
                                              vm.getUnreadUpdate(item);
                                            }
                                            vm.removeChatList(a);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : SizedBox()
                    ],
                  ),
                ),
              ),
            );
          });
    });
  }

  @override
  bool get wantKeepAlive => true;
}
