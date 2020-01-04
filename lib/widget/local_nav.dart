
import 'package:flutter/material.dart';
import 'package:xiecheng/model/common_model.dart';
import 'package:xiecheng/widget/webview.dart';

class LocalNav extends StatelessWidget {

  final List<CommonModel> localNavList;

  const LocalNav({Key key, this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  _items(BuildContext context) {
     if (localNavList == null) {
       return null;
     }
     List<Widget> items = [];
     localNavList.forEach( (commonModel) {
       items.add(_item(context, commonModel));
     });
     // 因为是一行排列，所以是row
     return Row(
       // 排列方式、平均排列
       mainAxisAlignment: MainAxisAlignment.spaceAround,
       children: items,
     );
  }

  Widget _item(BuildContext context, CommonModel commonModel) {
    return GestureDetector(
      onTap: () {
        // 跳转到对应的webview页面
        Navigator.push(context, MaterialPageRoute(builder: (context) => WebView(
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
            height: 32,
            width: 32,
          ),
          Text(commonModel.title, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

}