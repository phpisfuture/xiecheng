import 'package:flutter/material.dart';
import 'package:xiecheng/dao/search_dao.dart';
import 'package:xiecheng/model/search_model.dart';
import 'package:xiecheng/widget/search_bar.dart';
import 'package:xiecheng/widget/webview.dart';

const SEARCH_URL =
    'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  SearchPage(
      {this.hideLeft = false,
      this.searchUrl = SEARCH_URL,
      this.keyword,
      this.hint});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          // 收起键盘
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Column(
          children: <Widget>[
            _appBar(),
            MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: Expanded(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: searchModel?.data?.length ?? 0,
                      itemBuilder: (BuildContext context, int position) {
                        return _item(position);
                      }),
                )),
          ],
        ),
      ),
    );
  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 25),
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SearchBar(
                hideLeft: widget.hideLeft,
                defaultText: widget.keyword,
                hint: widget.hint,
                leftButtonClick: () {
                  Navigator.of(context).pop();
                },
                onChanged: _onTextChange,
                searchBarType: SearchBarType.normal),
          ),
        )
      ],
    );
  }

  _onTextChange(String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    String url = widget.searchUrl + text;
    SearchDao.fetch(url, text).then((SearchModel model) {
      // 如果接口返回的值，是我们当前输入的值，就重新渲染。
      if (model.keyword == text) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _item(int position) {
    if (searchModel == null || searchModel.data == null) {
      return null;
    }
    SearchItem item = searchModel.data[position];
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebView(
                      url: item.url,
                      title: '详情',
                    )));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
              bottom: BorderSide(
            color: Colors.grey,
            width: 0.3,
          )),
        ),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 16,
                backgroundImage: AssetImage(_typeImage(item.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(item),
                ),
                Container(
                  width: 300,
                  child: _subTitle(item),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _typeImage(String type) {
    if (type == null) {
      return 'images/nan.png';
    } else {
      return 'images/nv.png';
    }
  }

  _title(SearchItem item) {
    if (item == null) {
      return null;
    }
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(TextSpan(
      text: ' ' + (item.districtname ?? '') + ' ' + (item.zonename ?? ''),
      style: TextStyle(color: Colors.grey, fontSize: 16),
    ));
    return RichText(text: TextSpan(children: spans));
  }

  _subTitle(SearchItem item) {
    if (item == null) {
      return null;
    }
    return RichText(text: TextSpan(children: [
      TextSpan(text: (item.price??'') ,style: TextStyle(color: Colors.orange)),
      TextSpan(text: ' ' + (item.type??'') ,style: TextStyle(color: Colors.grey)),
    ]));
  }

  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    TextStyle normalTextStyle = TextStyle(color: Colors.black87, fontSize: 16);
    TextStyle keywordTextStyle = TextStyle(color: Colors.orange, fontSize: 16);
    List<String> arr = word.split(keyword);
    for (int i = 0; i < arr.length; i++) {
      String value = arr[i];
      if ((i + 1) % 2 == 0) {
        spans.add(TextSpan(text: keyword, style: keywordTextStyle));
      }

      if (value != null && value.length > 0) {
        spans.add(TextSpan(text: value, style: normalTextStyle));
      }

    }
    return spans;
  }
}
