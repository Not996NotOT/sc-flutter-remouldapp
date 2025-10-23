import 'package:flutter/material.dart';
import 'package:fluwx/fluwx.dart';

import 'common_tools.dart';

class FluwxPay {
  static initFluwx(String appId) async {
    var value = await registerWxApi(
        appId: appId,
        doOnAndroid: true,
        doOnIOS: true,
        universalLink: "https://0oyh2i.xinstall.com.cn/tolink/"); //
    if (value) {
      if (await isWeChatInstalled) {
        return true;
      } else {
        wjPrint('系统未检测到微信应用');
        return false;
      }
    } else {
      wjPrint('微信初始化失败！');
      return false;
    }
  }

  //微信支付
  static pay(
      {String appId,
      String partnerId,
      String prepayId,
      String packageValue,
      String nonceStr,
      int timeStamp,
      String sign,
      Function result}) {
    try {
      payWithWeChat(
              appId: appId,
              partnerId: partnerId,
              prepayId: prepayId,
              packageValue: packageValue,
              nonceStr: nonceStr,
              timeStamp: timeStamp,
              sign: sign)
          .then((value) => result(value));
    } catch (e) {
      wjPrint('微信支付e===$e');
    }
  }

  ///微信分享 注意参数配置
  static bool share(Map<String, dynamic> data) {
    // this.title,
    // this.scene = WeChatScene.SESSION,
    // this.description,
    // this.mediaTagName,
    // this.messageAction,
    // this.messageExt,
    // this.compressThumbnail = true})
    //   : this.thumbnail = thumbnail ?? source;
    ///[WeChatScene.SESSION]会话
    ///[WeChatScene.TIMELINE]朋友圈
    ///[WeChatScene.FAVORITE]收藏
    WeChatScene scene;
    if (data["toFriendsCircleFlag"] == 1) {
      scene = WeChatScene.SESSION;
    } else {
      scene = WeChatScene.TIMELINE;
    }

    // shareToWeChat(WeChatShareTextModel("source text", scene: WeChatScene.SESSION));

    // WeChatImage.asset(HelpTool.getImageName('login/icon.png'))
    String urlString = data['url'];
    int index = urlString.indexOf('#');
    String subString = urlString.substring(0, index);
    subString = subString + '&identification=1' + '#/inviteLink';
    shareToWeChat(WeChatShareWebPageModel(
      subString,
      title: data['title'],
      description: data['description'],
      thumbnail: WeChatImage.network(
          'http://test.future-better.com/h5/imgSrc/puxinShare.png'),
      compressThumbnail: true,
      scene: scene,
    )).then((value) {
      if (value) {
        wjPrint('分享成功');
      } else {
        wjPrint('分享失败');
      }
      return value;
    });
  }

  //微信支付回调
  static weChatPayResponse(ValueChanged<bool> payResult) {
    // 监听支付结果
    weChatResponseEventHandler.listen((event) async {
      wjPrint('微信支付结果回调====${event.errCode}');
      payResult(event.isSuccessful);
    });
  }
}
