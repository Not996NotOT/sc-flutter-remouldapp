import 'package:flutter/material.dart';
import 'package:notarization_station_app/utils/javascript_channel_method.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPageWidget extends StatefulWidget {
  final String url;
  final String title;
  const WebViewPageWidget({Key key, this.url, this.title}) : super(key: key);

  @override
  State<WebViewPageWidget> createState() => _WebViewPageWidgetState();
}

class _WebViewPageWidgetState extends State<WebViewPageWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text(widget.title)),
      body: WebView(
        initialUrl: widget.url.toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebResourceError: (error) {},
        javascriptChannels:
            JavascriptChannelMethod().loadJavascriptChannel(context),
        onWebViewCreated: (contro) {},
        onPageFinished: (url) {},
      ),
    );
  }
}
