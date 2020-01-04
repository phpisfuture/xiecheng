import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

const CATCH_URLs = ['m.ctrip.com/', 'm.ctrip.com/html5/', 'm.ctrip.com/html5'];

class WebView extends StatefulWidget {
  final String url;

  final String statusBarColor;

  final String title;

  final bool hideAppBar;

  final bool backForbid;

  const WebView(
      {Key key,
      this.url,
      this.statusBarColor,
      this.title,
      this.hideAppBar,
      this.backForbid = false})
      : super(key: key);

  @override
  _WebViewState createState() => _WebViewState();
}

class _WebViewState extends State<WebView> {
  final flutterWebviewPlugin = new FlutterWebviewPlugin();

  StreamSubscription<String> _onUrlChanged;
  StreamSubscription<WebViewStateChanged> _onStateChanged;
  StreamSubscription<WebViewHttpError> _onHttpError;
  bool exiting = false;

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.close();
    _onUrlChanged = flutterWebviewPlugin.onUrlChanged.listen((String url) {});
    _onStateChanged =
        flutterWebviewPlugin.onStateChanged.listen((WebViewStateChanged state) {
      switch (state.type) {
        case WebViewState.shouldStart:
          if (_isToMain(state.url) && !exiting) {
            // 如果禁止返回，就加载本页面
            if (widget.backForbid) {
              flutterWebviewPlugin.launch(widget.url);
            } else {
              // 返回上一层
              Navigator.pop(context);
              // 防止重复返回
              exiting = true;
              flutterWebviewPlugin.close();
              return;
            }
          }
          break;
        case WebViewState.startLoad:
          break;
        case WebViewState.finishLoad:
          // TODO: Handle this case.
          break;
        case WebViewState.abortLoad:
          // TODO: Handle this case.
          break;
      }
    });
    _onHttpError =
        flutterWebviewPlugin.onHttpError.listen((WebViewHttpError error) {
      print(error);
    });
  }

  bool _isToMain(String url) {
    bool contain = false;
    for (final value in CATCH_URLs) {
      if (url?.endsWith(value) ?? false) {
        contain = true;
      }
    }
    return contain;
  }

  @override
  void dispose() {
    _onHttpError.cancel();
    _onUrlChanged.cancel();
    _onStateChanged.cancel();
    flutterWebviewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String statusBarColorStr = widget.statusBarColor ?? 'ffffff';
    Color backButtonColor;
    if (statusBarColorStr == 'ffffff') {
      backButtonColor = Colors.blue;
    } else {
      backButtonColor = Colors.white;
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          // 字符串颜色转int颜色
          _appBar(
              Color(int.parse('0xff' + statusBarColorStr)), backButtonColor),
          // 水平展开充满屏幕
          Expanded(
            child: WebviewScaffold(
              url: widget.url,
              // 是否可以缩放
              withZoom: true,
              // 是否开启本地缓存
              withLocalStorage: true,
              // 页面等待时是否隐藏，默认展示CircularProgressIndicator。
              hidden: true,
              // 页面等待时展示的child
              initialChild: Container(
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appBar(Color backgroundColor, Color backButtonColor) {
    if (widget.hideAppBar ?? false) {
      return Container(
        color: backgroundColor,
        height: 30,
      );
    }
    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(0, 40, 0, 10),
      // FractionallySizedBox 撑满父布局
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Stack(
          children: <Widget>[
            // 创建手势探测器，可以捕捉事件
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                // 防止重复返回
                exiting = true;
                flutterWebviewPlugin.close();
              },
              child: Container(
                margin: EdgeInsets.only(left: 10),
                child: Icon(Icons.close, color: backButtonColor, size: 26),
              ),
            ),
            // Positioned 绝对定位
            Positioned(
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  widget.title ?? '',
                  style: TextStyle(color: backButtonColor, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
