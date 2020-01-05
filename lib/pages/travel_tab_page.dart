import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:xiecheng/dao/travel_item_dao.dart';
import 'package:xiecheng/model/travel_item_model.dart';
import 'package:xiecheng/widget/loading_container.dart';
import 'package:xiecheng/widget/webview.dart';

const int Page_Size = 10;

const String kURL = "http://m.ctrip.com/restapi/soa2/16189/json/searchTripShootListForHomePageV2?_fxpcqlniredt=09031014111431397988&__gw_appid=99999999&__gw_ver=1.0&__gw_from=10650013707&__gw_platform=H5";

/// 旅拍页面
class TravelTabPage extends StatefulWidget {

  final String travelUrl;
  final String groupChannelCode;


  TravelTabPage({Key key,this.travelUrl, this.groupChannelCode}):super(key:key);

  @override
  State<StatefulWidget> createState() {
    return _TravelTabPageState();
  }
}

// AutomaticKeepAliveClientMixin保持页面加载
class _TravelTabPageState extends State<TravelTabPage> with AutomaticKeepAliveClientMixin{

  List<TravelItem> travelItems;
  int pageIndex = 1;
  bool _loading = true;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _loadData();

    /// 监听页面滚动到底部
    _scrollController.addListener((){
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _loadData(loadMore: true);
      }
    });
    super.initState();
  }

  /// 加载网络数据
  _loadData({loadMore = false}) {

    if (loadMore) {
      pageIndex++;
    } else {
      pageIndex = 1;
    }

    /// 不管成功失败 加载_loading都要结束
    TravelItemDao.fetch(widget.travelUrl ?? kURL, widget.groupChannelCode, pageIndex, Page_Size).then((TravelItemModel model){
      _loading = false;
      setState(() {
        List<TravelItem> items = _filterItems(model.resultList);
        if (travelItems != null) {
          travelItems.addAll(items);
        } else {
          travelItems = items;
        }
      });
    }).catchError((e){
      _loading = false;
      print("获取单页旅拍数据异常:$e");
    });
  }

  List<TravelItem> _filterItems(List<TravelItem> resultList) {
    if (resultList == null) {
      return [];
    }

    List<TravelItem> filterItems = [];
    resultList.forEach((item){
      /// 移除article为空的
      if (item.article != null) {
        filterItems.add(item);
      }
    });
    return filterItems;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoadingContainer(
        isLoading: _loading,
        child: RefreshIndicator(
            child: MediaQuery.removeViewPadding(
              removeTop: true,
              context: context,
              // 瀑布流布局。StaggeredGridView与staggeredTileBuilder配合使用
              child: StaggeredGridView.countBuilder(
                controller: _scrollController,
                // 瀑布流布局一共有几列
                crossAxisCount: 4,//列数
                // 瀑布流布局一共有多少项
                itemCount: travelItems?.length??0,
                // 构建没项样式
                itemBuilder: (BuildContext context, int index) => _TravelItem(index:index, item:travelItems[index]),
                // 指定每项占多少
                staggeredTileBuilder: (int index) =>
                    // 每个item固定占两列
                    StaggeredTile.fit(2),
                //mainAxisSpacing: 4.0,
                //crossAxisSpacing: 4.0,
              ),
            ),
            onRefresh: _handleRefresh
        ),
      ),
    );
  }

  Future<Null> _handleRefresh() async {
    _loadData();
    return null;
  }

  @override
  bool get wantKeepAlive => true;
}

// 卡片整体
class _TravelItem extends StatelessWidget {

  final int index;
  final TravelItem item;

  _TravelItem({this.index, this.item});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        if (item.article.urls != null && item.article.urls.length > 0) {
          Navigator.push(context, MaterialPageRoute(builder: (conetxt){
            return WebView(url: item.article.urls[0].h5Url,title: "详情",);
          }));
        }
      },
      child: Card(//卡片
        /// 裁剪效果
        child: PhysicalModel(
          color: Colors.transparent,
          // 锯齿效果
          clipBehavior: Clip.antiAlias,
          borderRadius: BorderRadius.circular(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _itemImage(),
              Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  item.article.articleTitle,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14,color: Colors.black),
                ),
              ),
              _infoText(),
            ],
          ),
        ),
      ),
    );
  }

  _itemImage() {
    return Stack(
      children: <Widget>[
        Image.network(item.article.images[0]?.dynamicUrl),
        // 定位固定在图片的位置
        Positioned(
          left: 8,
          bottom: 8,
          // 定位黑色背景
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 1, 5, 1),
            decoration: BoxDecoration(color: Colors.black54),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 3),
                  child: Icon(Icons.location_on,color: Colors.white,size: 12,),
                ),
                // 有限制的盒子，可以根据内里内容大小自动撑开
                LimitedBox(
                  maxWidth: 130,
                  child: Text(
                    _poiName(),
                    //最大列数
                    maxLines: 1,
                    // 超出显示方式（省略号）
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12,color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _poiName() {
    return (item.article.pois == null || item.article.pois.length == 0) ? "未知" :
    item.article.pois[0]?.poiName ?? "未知";
  }

  _infoText() {
    return Container(
      padding: EdgeInsets.fromLTRB(6, 0, 6, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              PhysicalModel(
                color: Colors.transparent,
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(12),
                child: Image.network(item.article.author?.coverImage?.dynamicUrl,width: 24,height: 24,),
              ),
              Container(
                padding: EdgeInsets.all(5),
                width: 90,
                child: Text(
                  item.article.author?.nickName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12),
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.thumb_up,
                size: 14,
                color: Colors.grey,
              ),
              Padding(
                padding: EdgeInsets.only(left: 3),
                child: Text(
                  item.article.likeCount.toString(),
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}