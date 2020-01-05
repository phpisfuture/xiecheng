import 'package:flutter/material.dart';
import 'package:xiecheng/widget/webview.dart';

class MyPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyPageState();
  }
}

class _MyPageState extends State<MyPage> {
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
      url: "https://m.ctrip.com/webapp/myctrip/",
      hideAppBar: true,
      backForbid: true,
      statusBarColor: "4c5bca",
    ));
  }
}
