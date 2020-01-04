
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:xiecheng/model/common_model.dart';
import 'package:xiecheng/widget/webview.dart';

class BannerNav extends StatelessWidget {

  final List<CommonModel> bannerList;

  const BannerNav({@required this.bannerList});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      child: Swiper(
        // 轮播图数量
        itemCount: bannerList.length,
        // 自动播放
        autoplay: bannerList.isNotEmpty,
        // 分页样式
        pagination: SwiperPagination(),
        // 构建子项
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              // 跳转到对应的webview页面
              Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(
                title: bannerList[index].title,
                url: bannerList[index].url,
                statusBarColor: bannerList[index].statusBarColor,
                hideAppBar: bannerList[index].hideAppBar,
              )));
            },
            child: Image.network(bannerList[index].icon,
                fit: BoxFit.fill),
          );
        },
      ),
    );
  }

}