import 'package:flutter/material.dart';
import 'package:xiecheng/model/common_model.dart';
import 'package:xiecheng/widget/webview.dart';

class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key key, this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(6)),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
    if (subNavList == null) {
      return null;
    }
    List<Widget> items = [];
    subNavList.forEach((commonModel) {
      items.add(_item(context, commonModel));
    });
    int separate = (subNavList.length / 2 + 0.5).toInt();
    // 因为是一行排列，所以是row
    return Column(
      children: <Widget>[
        Row(
          // 排列方式、平均排列
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.sublist(0, separate),
        ),
        Padding(
          padding: EdgeInsets.only(top: 15),
          child: Row(
            // 排列方式、平均排列
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items.sublist(separate, subNavList.length),
          ),
        )
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel commonModel) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // 跳转到对应的webview页面
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WebView(
                        title: commonModel.title,
                        url: commonModel.url,
                        statusBarColor: commonModel.statusBarColor,
                        hideAppBar: commonModel.hideAppBar,
                      )));
        },
        child: Column(
          children: <Widget>[
            Image.network(
              commonModel.icon,
              height: 23,
              width: 23,
            ),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(commonModel.title, style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
      ),
      flex: 1,
    );
  }
}
