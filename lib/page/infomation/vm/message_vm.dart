import 'package:flutter/cupertino.dart';
import 'package:notarization_station_app/base_framework/utils/toast_util.dart';
import 'package:notarization_station_app/base_framework/view_model/single_view_state_model.dart';
import 'package:notarization_station_app/page/login/vm/user_view_model.dart';
import 'package:notarization_station_app/service_api/infomation_api.dart';

import '../../../utils/common_tools.dart';

class MessageModel extends SingleViewStateModel {
  UserViewModel userModel;
  TextEditingController textEditingController = TextEditingController();
  List friendList = [];
  int applyNum = 0;
  int likeNum = 0;
  int commentNum = 0;
  int isOperation = 0;
  List applyList = [];
  List chatList = [];
  MessageModel(this.userModel) {
    // if(SpUtil.getObjectList(userModel.unitGuid)!=null){
    //   chatList = SpUtil.getObjectList(userModel.unitGuid);
    //   notifyListeners();
    // }
  }

  getFriend() async {
    Map<String, dynamic> map = {
      // "userId":userModel.unitGuid
    };
    var res = await InformationApi.getSingleton().getFriend(map);
    if (res["code"] == 200) {
      friendList = res['item'];
      notifyListeners();
    } else {
      ToastUtil.showErrorToast(res["msg"]);
    }
  }

  applyFriend() async {
    Map<String, dynamic> map = {
      // "approvaler":userModel.unitGuid
    };
    var res = await InformationApi.getSingleton().applyFriend(map);
    if (res["code"] == 200) {
      applyNum = res["items"].length;
      applyList = res["items"];
      notifyListeners();
    }
  }

  approvalFriend(String unitGuid, int state) async {
    Map<String, dynamic> map = {
      "unitGuid": unitGuid, //主键ID
      "state": state //审批状态  1是待审批 2是通过 3是不通过 4是已删除
    };
    var res = await InformationApi.getSingleton().approvalFriend(map);
    if (res["code"] == 200) {
      applyFriend();
    } else {
      ToastUtil.showErrorToast("出现了问题，请稍后再试");
    }
  }

  addChatList(item) {
    bool isChat = true;
    chatList.forEach((e) {
      if (e['unitGuid'] == item['friendId']) {
        isChat = false;
      }
    });
    if (isChat) {
      chatList.add({
        "name": item['userName'],
        "headIcon": item['headIcon'],
        "unitGuid": item['friendId'],
        "newest": "",
        "newestTime":
            "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
        "messageNum": 0,
        "messageId": ''
      });
      //SpUtil.putObjectList(userModel.unitGuid, chatList);
    }
    notifyListeners();
  }

  removeChatList(int num) {
    chatList.removeAt(num);
    //SpUtil.putObjectList(userModel.unitGuid,chatList);
    notifyListeners();
  }

  getUnread() async {
    Map<String, dynamic> map = {
      //"recipient":userModel.unitGuid,//主键ID
    };
    var res = await InformationApi.getSingleton().getUnread(map);
    if (res["code"] == 200) {
      res['item'].forEach((i) {
        bool isChat = true;
        chatList.forEach((e) {
          if (i['sender'] == e['unitGuid']) {
            e['newest'] = i['img'] == 1.0 ? "图片" : i['message'];
            e['headIcon'] = i['headIcon'];
            e["newestTime"] = i['createDate'];
            e["messageNum"] = e["messageNum"] + 1;
            e["messageId"] = i['unitGuid'];
            isChat = false;
          }
        });
        if (isChat) {
          chatList.add({
            "name": i['sendName'],
            "headIcon": i['headIcon'],
            "unitGuid": i['sender'],
            "newest": i['img'] == 1.0 ? "图片" : i['message'],
            "newestTime": i['createDate'],
            "messageNum": 1,
            "messageId": i['unitGuid'],
          });
        }
      });
      //SpUtil.putObjectList(userModel.unitGuid, chatList);
    } else {
      ToastUtil.showErrorToast("出现了问题，请稍后再试");
    }
  }

  getUnreadUpdate(item) async {
    Map<String, dynamic> map = {
      "unitGuid": item['messageId'], //主键ID
      "type": 2
    };
    var res = await InformationApi.getSingleton().getUnreadUpdate(map);
  }

  getLike() async {
    Map<String, dynamic> map = {
      //"createUser":userModel.unitGuid,//主键ID
      "isRead": 0
    };
    wjPrint(".....$map");
    var res = await InformationApi.getSingleton().getLikerecord(map);
    if (res['code'] == 200) {
      likeNum = res['items'];
      // SpUtil.putInt(userModel.unitGuid+"2", res['page']['total']);
      notifyListeners();
    }
  }

  getComment() async {
    Map<String, dynamic> map = {
      //"parentId":userModel.unitGuid,//主键ID
      "isRead": 0
    };
    var res = await InformationApi.getSingleton().getRecordCount(map);
    if (res['code'] == 200) {
      wjPrint("...........$res");
      commentNum = res['items'];
      // SpUtil.putInt(userModel.unitGuid+"2", res['page']['total']);
      notifyListeners();
    }
  }

  @override
  onCompleted(data) {}

  @override
  Future loadData() {
    // openCallback();
    getLike();
    getComment();
    // SocketManage.instance.connect(userModel.unitGuid+"-3");
    // getUnread();
    return null;
  }

  // openCallback(){
  //   wjPrint("----------------------9899999");
  //   SocketManage.instance.setCallback(this);
  //   notifyListeners();
  // }

  // @override
  // void socketDataHandler(onData) {
  //
  //   wjPrint('...2$onData');
  //   var data = json.decode(onData);
  //   if(data['code']=="chat") {
  //       bool isChat = true;
  //       chatList.forEach((e) {
  //         if (data['sender'] == e['unitGuid']) {
  //           isChat = false;
  //           e['newest'] = data['img'] == 1 ? "图片" : data['msg'];
  //           e['headIcon'] = data['headIcon'];
  //           e["newestTime"] = "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}";
  //           e["messageNum"] = e["messageNum"] + 1;
  //           e["messageId"] = "";
  //           //SpUtil.putObjectList(userModel.unitGuid, chatList);
  //         }
  //       });
  //       if (isChat) {
  //         wjPrint("111111111111111111111111");
  //         chatList.add({
  //           "name": data['senderName'],
  //           "headIcon": data['headIcon'],
  //           "unitGuid": data['sender'],
  //           "newest": data['img'] == 1 ? "图片" : data['msg'],
  //           "newestTime": "${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}",
  //           "messageNum": 1,
  //           "messageId": "",
  //         });
  //         //SpUtil.putObjectList(userModel.unitGuid, chatList);
  //       }
  //       notifyListeners();
  //   }
  // }
}
