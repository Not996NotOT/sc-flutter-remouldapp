
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:webview_flutter_plus/webview_flutter_plus.dart';

import '../../utils/common_tools.dart';

class PrivacyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PrivacyPageState();
  }
}

class PrivacyPageState extends BaseState<PrivacyPage> {
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "隐私政策"),
      body: Container(
        color: Colors.white,
        width: getWidthPx(750),
        child: Stack(
          children: [
            WebViewPlus(
              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (controller) {
                controller.loadUrl("https://sc.njguochu.com:46/yszc.html",
                    headers: {});
                wjPrint('2136512315643514');
              },
              javascriptChannels: <JavascriptChannel>[].toSet(),
              onPageStarted: (urlString) {
                wjPrint("urlString-------$urlString");
              },
              onPageFinished: (url) {
                wjPrint("url-------$url");
                setState(() {
                  isLoading = true;
                });
              },
            ),
            Offstage(
              offstage: isLoading,
              child: loadingWidget(),
            )
          ],
        ),
      ),
    );
  }
}
