import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:notarization_station_app/base_framework/widget_state/base_state.dart';
import 'package:notarization_station_app/utils/global.dart';

class FlutterInappwebviewPage extends StatefulWidget {
  final String url;
  final String title;
  FlutterInappwebviewPage({Key key, this.url, this.title}) : super(key: key);
  @override
  _FlutterInappwebviewPageState createState() => _FlutterInappwebviewPageState();
}

class _FlutterInappwebviewPageState extends BaseState<FlutterInappwebviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: widget.title),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
        initialOptions: InAppWebViewGroupOptions(
            crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false),
            android: AndroidInAppWebViewOptions(
              useHybridComposition: true,
            ),
            ios: IOSInAppWebViewOptions(
              allowsInlineMediaPlayback: true,
            )),
          androidOnPermissionRequest: (InAppWebViewController controller, String origin, List<String> resources) async {
            return PermissionRequestResponse(resources: resources, action: PermissionRequestResponseAction.GRANT);//主要是这行代码是授权的
          },

    onWebViewCreated: (controller) {
            // 注入 JS，把 window.postMessage 映射到 flutter_inappwebview
      controller.evaluateJavascript(source: """
    (function() {
      var originalPostMessage = window.postMessage;
      window.parent.postMessage = function(message) {
        flutter_inappwebview.callHandler('flutter_inappwebview', message);
        return originalPostMessage.apply(window, arguments);
      };
    })();
  """);
      controller.addJavaScriptHandler(
        handlerName: 'flutter_inappwebview',
        callback: (args) {
          print('收到消息: $args');
          if (args is List  && args.length > 0) {
            try {
              var data = args[0];
              if (data is Map) {
                var res=data['data'];
                if( res != null && res is Map){
                  var action=res['arg'];
                  if(action != null && action is Map && action['action'] == "message"){
                    Navigator.pop(context,true);
                  }
                }
              }
            } catch (e) {
              print(e);
          }
          }
        },
      );
    },
        onConsoleMessage: (controller, consoleMessage) {
          print(consoleMessage);
        },
        onLoadStop: (controller, url) async {
               controller.evaluateJavascript(source: """
    (function() {
      var originalPostMessage = window.postMessage;
      window.parent.postMessage = function(message) {
        flutter_inappwebview.callHandler('flutter_inappwebview', message);
        return originalPostMessage.apply(window, arguments);
      };
    })();
  """);
  }),
    );
  }
}