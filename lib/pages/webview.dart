import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iv2ex/widgets/system/safeArea/safeArea.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget webview(BuildContext context, String url) {
  return Material(
      child: Column(
    children: [
      safeAreaTop(context),
      Expanded(
        child: WebView(
          initialUrl: url,
          onPageFinished: (e) {
            print(e);
          },
        ),
      )
    ],
  ));
}

class MyWebView extends StatefulWidget {
  final String url;
  MyWebView({Key key, @required this.url});
  @override
  State<MyWebView> createState() => MyWebViewState();
}

class MyWebViewState extends State<MyWebView> {
  @override
  Widget build(BuildContext context) {
    return webview(context, widget.url);
  }
}
