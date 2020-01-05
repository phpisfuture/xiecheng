import 'package:flutter/material.dart';
import 'package:xiecheng/dao/travel_tab_dao.dart';
import 'package:xiecheng/model/travel_tab_model.dart';
import 'package:xiecheng/pages/travel_tab_page.dart';

const String kURL =
    "http://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5";

class TravelPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TravelPageState();
  }
}

class _TravelPageState extends State<TravelPage> with TickerProviderStateMixin {
  TabController _tabController;
  List<TravelTab> tabs = [];
  TravelTabModel travelTabModel;

  @override
  void initState() {
    // tabcontroller需要复用TickerProviderStateMixin，通过mixin、with关键字
    // 初始化为0个长度
    _tabController = TabController(length: 0, vsync: this);
    TravelTabDao.fetch().then((TravelTabModel model) {
      // 解决tabbar初始化为空白。数据加载回来之后，需要重新初始化tabcontroller的长度
      _tabController = TabController(length: model.tabs.length, vsync: this);
      setState(() {
        tabs = model.tabs;
        travelTabModel = model;
      });
    }).catchError((e) {
      print("获取旅拍tab失败$e");
    });

    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 30),
            // 左右滑动的导航
            child: TabBar(
                // 每项颜色
                labelColor: Colors.black,
                // 每项之间的padding
                labelPadding: EdgeInsets.fromLTRB(20, 0, 10, 5),
                // 是否允许左右滑动
                isScrollable: true,
                // 导航控制器tabController
                controller: _tabController,
                // 指示器（当前选中的样式）
                  // UnderlineTabIndicator(下划线样式)
                indicator: UnderlineTabIndicator(
                    // 下划线样式
                    borderSide: BorderSide(width: 3, color: Color(0xff2fcfbb)),
                    // 下划线相对布局（下划线距离边界10、及在边界上方10）
                    insets: EdgeInsets.only(bottom: 10)),
                // 指定每项tab内容
                tabs: tabs.map<Tab>((TravelTab tab) {
                  return Tab(
                    text: tab.labelName,
                  );
                }).toList()),
          ),
          // 不指定高度时无法显示，用Flexible撑开父布局
          Flexible(
            // TabBar与TabBarView配合使用，TabBarView指定选中每一项要展示的内容
            child: TabBarView(
              // 导航控制器tabController(与上面一样)
              controller: _tabController,
              children: tabs.map((TravelTab tab) {
                return TravelTabPage(
                  travelUrl: travelTabModel.url,
                  groupChannelCode: tab.groupChannelCode,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
