import 'package:flutter/material.dart';
import 'package:xiecheng/pages/home_page.dart';
import 'package:xiecheng/pages/my_page.dart';
import 'package:xiecheng/pages/search_page.dart';
import 'package:xiecheng/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => new _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {

  final _defaultCode = Colors.grey;
  final _activeCode = Colors.blue;
  int _currentIndex = 0;
  // 分页控制器
  final PageController _controller = PageController(
    // 初始显示第0个
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        // 当页面发生改变时，重新构建底部导航栏
        onPageChanged: (index) {
          if (index != 1) {
            // 收起键盘
            FocusScope.of(context).requestFocus(new FocusNode());
          }
          setState(() {
            _currentIndex = index;
          });
        },
        // 禁止pageview左右滑动
        physics: NeverScrollableScrollPhysics(),
        // 指定控制器
        controller: _controller,
        // 指定子项
        children: <Widget>[
          HomePage(),
          SearchPage(hideLeft: true),
          TravelPage(),
          MyPage(),
        ],
      ),
      // 底部导航栏
      bottomNavigationBar: BottomNavigationBar(
          // 默认显示第几个
          currentIndex: _currentIndex,
          // 导航栏类型
          type: BottomNavigationBarType.fixed,
          // 当触摸时
          onTap: (index) {
            // 跳转到对应page
            _controller.jumpToPage(index);
            // 重新构建导航
            setState(() {
              _currentIndex = index;
            });
          },
          // 导航子项
          items: [
            BottomNavigationBarItem(
              // 图标
              icon: Icon(Icons.home, color: _defaultCode),
              // 选中图标
              activeIcon: Icon(Icons.home, color: _activeCode),
              // 文字
              title: Text(
                "首页",
                style: TextStyle(
                  color: _currentIndex != 0 ? _defaultCode : _activeCode,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search, color: _defaultCode),
              activeIcon: Icon(Icons.search, color: _activeCode),
              title: Text(
                "搜索",
                style: TextStyle(
                  color: _currentIndex != 1 ? _defaultCode : _activeCode,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.camera_alt, color: _defaultCode),
              activeIcon: Icon(Icons.camera_alt, color: _activeCode),
              title: Text(
                "旅怕",
                style: TextStyle(
                  color: _currentIndex != 2 ? _defaultCode : _activeCode,
                ),
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, color: _defaultCode),
              activeIcon: Icon(Icons.account_circle, color: _activeCode),
              title: Text(
                "我的",
                style: TextStyle(
                  color: _currentIndex != 3 ? _defaultCode : _activeCode,
                ),
              ),
            ),
          ]),
    );
  }
}
