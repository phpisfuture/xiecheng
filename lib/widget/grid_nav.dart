import 'package:flutter/material.dart';
import 'package:xiecheng/model/common_model.dart';
import 'package:xiecheng/model/grid_nav_model.dart';
import 'package:xiecheng/widget/webview.dart';

// 网格卡片
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 裁剪工具类
    return PhysicalModel(
        // 透明
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        // 裁剪
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: _gridItems(context),
        ),
    );
  }

  _gridItems(BuildContext context) {
    List<Widget> items = [];
    if (gridNavModel == null) {
      return items;
    }
    if (gridNavModel.hotel != null) {
      items.add(_gridItem(context, gridNavModel.hotel, true));
    }

    if (gridNavModel.hotel != null) {
      items.add(_gridItem(context, gridNavModel.flight, false));
    }

    if (gridNavModel.hotel != null) {
      items.add(_gridItem(context, gridNavModel.travel, false));
    }
    return items;
  }

  _gridItem(BuildContext context, GridNavItem gridNavItem, bool isTop) {
    List<Widget> items = [];
    items.add(_mainItem(context, gridNavItem.mainItem, isTop));
    items.add(_doubleItem(context, gridNavItem.item1, gridNavItem.item2));
    items.add(_doubleItem(context, gridNavItem.item3, gridNavItem.item4));
    List<Widget> expands = [];
    items.forEach((widget) {
      expands.add(Expanded(child: widget));
    });
    return Container(
      height: 88,
      margin: isTop ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        // 线性渐变
        gradient: LinearGradient(colors: [
          Color(int.parse('0xff' + gridNavItem.startColor)),
          Color(int.parse('0xff' + gridNavItem.endColor)),
        ]),
      ),
      child: Row(
        children: expands,
      ),
    );
  }

  _mainItem(BuildContext context, CommonModel commonModel, bool isTop) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Image.network(
              commonModel.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: Alignment.bottomCenter,
            ),
            Container(
              margin: EdgeInsets.only(top: 11),
              child: Text(
                commonModel.title,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ],
        ),
        commonModel);
  }

  _doubleItem(
      BuildContext context, CommonModel topCommonModel, buttomCommonModel) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: Colors.white,
            width: 0.8,
          ),
        ),
      ),
      child: Column(
        children: <Widget>[
          Expanded(child: _item(context, topCommonModel, true)),
          Expanded(child: _item(context, buttomCommonModel, false)),
        ],
      ),
    );
  }

  _wrapGesture(BuildContext context, Widget widget, CommonModel commonModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (content) => WebView(
                      title: commonModel.title,
                      url: commonModel.url,
                      statusBarColor: commonModel.statusBarColor,
                      hideAppBar: commonModel.hideAppBar,
                    )));
      },
      child: widget,
    );
  }

  _item(BuildContext context, CommonModel commonModel, bool isTop) {
    return _wrapGesture(
        context,
        // 撑满父布局
        FractionallySizedBox(
          widthFactor: 1,
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              border: isTop
                  ? Border(
                      bottom: BorderSide(
                        color: Colors.white,
                        width: 0.8,
                      ),
                    )
                  : null,
            ),
            child: Center(
              child: Text(
                commonModel.title,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        commonModel);
  }
}
