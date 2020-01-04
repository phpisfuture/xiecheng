import 'package:xiecheng/model/common_model.dart';
import 'package:xiecheng/model/config_model.dart';
import 'package:xiecheng/model/grid_nav_model.dart';
import 'package:xiecheng/model/sales_box_model.dart';

class HomeModel {
  final ConfigModel config;

  final List<CommonModel> bannerList;

  final List<CommonModel> localNavList;

  final List<CommonModel> subNavList;

  final GridNavModel gridNav;

  final SalesBoxModel salesBox;

  HomeModel(
      {this.subNavList,
      this.gridNav,
      this.salesBox,
      this.bannerList,
      this.localNavList,
      this.config});

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList = bannerListJson
        .map((covariant) => CommonModel.fromJson(covariant))
        .toList();

    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList = localNavListJson
        .map((covariant) => CommonModel.fromJson(covariant))
        .toList();

    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList = subNavListJson
        .map((covariant) => CommonModel.fromJson(covariant))
        .toList();

    return HomeModel(
      config: ConfigModel.fromJson(json['config']),
      bannerList: bannerList,
      subNavList: subNavList,
      localNavList: localNavList,
      gridNav: GridNavModel.fromJson(json['gridNav']),
      salesBox: SalesBoxModel.fromJson(json['salesBox']),
    );
  }
}
