
import 'package:flutter/material.dart';
import 'package:xiecheng/model/common_model.dart';
import 'package:xiecheng/model/sales_box_model.dart';
import 'package:xiecheng/widget/webview.dart';

/// 底部卡片入口
class SalesBox extends StatelessWidget {
  final SalesBoxModel salesBoxModel;

  const SalesBox({Key key, this.salesBoxModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      // 透明
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      // 裁剪
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {
    if (salesBoxModel == null) {
      return null;
    }

    var items = <Widget>[];
    items.add(_buildTitle(context, salesBoxModel.icon, salesBoxModel.moreUrl));
    items.add(_doubleItems(
        context, salesBoxModel.bigCard1, salesBoxModel.bigCard2, false));
    items.add(_doubleItems(
        context, salesBoxModel.smallCard1, salesBoxModel.smallCard2, false));
    items.add(_doubleItems(
        context, salesBoxModel.smallCard3, salesBoxModel.smallCard4, true));

    return Column(
      children: items,
    );
  }

  Widget _buildTitle(BuildContext context, String icon, String moreUrl) {
    return Container(
      margin: EdgeInsets.only(left: 10),
      height: 44,
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(width: 1, color: Color(0xfff2f2f2)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image.network(icon, height: 15, fit: BoxFit.fill,),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebView(
                        url: moreUrl,
                        title: '更多活动',
                      )));
            },
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xffff4e63), Color(0xffff6cc9)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight),
                  borderRadius: BorderRadius.circular(50)),
              padding: EdgeInsets.fromLTRB(10, 1, 8, 1),
              margin: EdgeInsets.only(right: 7),
              child: Text(
                "获取更多福利 >",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _doubleItems(BuildContext context, CommonModel leftModel,
      CommonModel rightModel, bool isLast) {
    return Row(
      children: <Widget>[
        _item(context, leftModel, isLast, true),
        _item(context, rightModel, isLast, false),
      ],
    );
  }

  Widget _item(
      BuildContext context, CommonModel model, bool isLast, bool isCenter) {
    return Expanded(
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebView(
                      url: model.url,
                      title: model.title,
                      statusBarColor: model.statusBarColor,
                      hideAppBar: model.hideAppBar,
                    )));
          },
          child: Container(
              decoration: BoxDecoration(
                  border: BorderDirectional(
                      bottom: isLast
                          ? BorderSide.none
                          : BorderSide(width: 1, color: Color(0xfff2f2f2)),
                      end: isCenter
                          ? BorderSide(width: 1, color: Color(0xfff2f2f2))
                          : BorderSide.none)),
              child: Image.network(model.icon)),
        ));
  }
}
