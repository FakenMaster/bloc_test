import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Webview extends StatefulWidget {
  final String url;
  final String title;

  Webview({Key key, this.url, this.title}) : super(key: key);

  @override
  _WebviewState createState() => _WebviewState();
}

class _WebviewState extends State<Webview>  {
  WebViewController webViewController;
  bool _loading = true;
  JavascriptChannel _jsBridge(BuildContext context) => JavascriptChannel(
      name: 'JstPark', // 与h5 端的一致 不然收不到消息
      onMessageReceived: (JavascriptMessage msg) async {
        String jsonStr = msg.message;
        // JsBridgeUtil.executeMethod(
        //   context,
        //   webViewController,
        //   JsBridgeUtil.parseJson(jsonStr),
        // );
      });

  @override
  void dispose() {
    // webViewController.dis
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? '集商通园区版'),
      ),
      body: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: WebView(
            key: Key('webview_content'),
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onPageFinished: (val) {
              _loading = false;
              this.setState((){});
            },
            gestureNavigationEnabled: true,
            userAgent:
                'Mozilla/5.0 (Linux; Android 5.0;) > AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 > Chrome/37.0.0.0 Mobile Safari/537.36 > 86Links/3.2.1 NetType/WIFI',
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>[
              _jsBridge(context) // 与h5 通信
            ].toSet(),
            // url编码，防止url含有中文导致空白
            initialUrl: Uri.encodeFull(widget.url),
            initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
          ),
        ),
      
    );
  }

}
