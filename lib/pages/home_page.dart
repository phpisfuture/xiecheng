import 'package:flutter/material.dart';
import 'package:xiecheng/dao/home_dao.dart';
import 'package:xiecheng/model/common_model.dart';
import 'package:xiecheng/model/grid_nav_model.dart';
import 'package:xiecheng/model/home_model.dart';
import 'package:xiecheng/model/sales_box_model.dart';
import 'package:xiecheng/pages/search_page.dart';
import 'package:xiecheng/widget/banner_nav.dart';
import 'package:xiecheng/widget/grid_nav.dart';
import 'package:xiecheng/widget/loading_container.dart';
import 'package:xiecheng/widget/local_nav.dart';
import 'package:xiecheng/widget/sales_box.dart';
import 'package:xiecheng/widget/search_bar.dart';
import 'package:xiecheng/widget/sub_nav.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  double _appBarAlpha = 0;

  List<CommonModel> bannerList = [];
  List<CommonModel> localNavList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _refreshHandler();
  }

  Future<Null> _refreshHandler() async {
    try {
      HomeModel model = await HomeDao.fetch();
      setState(() {
        localNavList = model.localNavList;
        gridNavModel = model.gridNav;
        bannerList = model.bannerList;
        subNavList = model.subNavList;
        salesBoxModel = model.salesBox;
        loading = false;
      });
    } catch (e) {
      print(e);
      loading = false;
    }
    return null;
  }

  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      _appBarAlpha = alpha;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoadingContainer(
        isLoading: loading,
        child: Scaffold(
          backgroundColor: Color(0xfff2f2fa),
          body: Stack(
            children: <Widget>[
              // 移除widget的padding
              MediaQuery.removePadding(
                  removeTop: true,
                  context: context,
                  child: RefreshIndicator(
                    child: NotificationListener(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollUpdateNotification
                            // 当第0个元素（在child中找，及ListView）触发滚动时才生效
                            // depth代码wedget层级
                            &&
                            scrollNotification.depth == 0) {
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                      },
                      child: ListView(
                        children: <Widget>[
                          BannerNav(bannerList: bannerList),
                          Padding(
                            padding: EdgeInsets.fromLTRB(7, 6, 7, 6),
                            child: LocalNav(localNavList: localNavList),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(7, 0, 7, 6),
                            child: GridNav(gridNavModel: gridNavModel),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(7, 0, 7, 6),
                            child: SubNav(subNavList: subNavList),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(7, 0, 7, 6),
                            child: SalesBox(salesBoxModel: salesBoxModel),
                          ),
                        ],
                      ),
                    ),
                    onRefresh: _refreshHandler,
                  ),
              ),
              _appBar,
            ],
          ),
        ));
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            // appbar 渐变遮罩背景
            gradient: LinearGradient(
                    colors: [Color(0x66000000), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
          ),
          // 输入框背景渐变
          child: Container(
            padding: EdgeInsets.only(top: 30),
            height: 70,
            decoration: BoxDecoration(
              color: Color.fromARGB((_appBarAlpha * 255).toInt(), 255, 255, 255),
            ),
            child: SearchBar(
              searchBarType: _appBarAlpha > 0.2 ? SearchBarType.homeLight : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakClick: _jumpToSpeak,
              defaultText: '网红打卡地 景点 酒店 美食',
              leftButtonClick: () {

              },
            ),
          ),
        ),
        // 底部阴影
        Container(
          // 首页listView滑动一定距离才会出现底部阴影
          height: _appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(
              color: Colors.black12,
              blurRadius: 0.5,
            )],
          ),
        ),
      ],
    );
  }

  _jumpToSearch() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(hint: '网红打卡地 景点 酒店 美食')));
  }

  _jumpToSpeak() {}

  @override
  bool get wantKeepAlive => true;
}
