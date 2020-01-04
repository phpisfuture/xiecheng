import 'package:flutter/material.dart';

enum SearchBarType { home, normal, homeLight }

class SearchBar extends StatefulWidget {
  final bool enabled;
  final bool hideLeft;
  final SearchBarType searchBarType;
  final String hint;
  final String defaultText;
  final void Function() leftButtonClick;
  final void Function() reghtButtonClick;
  final void Function() speakClick;
  final void Function() inputBoxClick;
  final ValueChanged<String> onChanged;

  const SearchBar(
      {Key key,
      this.enabled = true,
      this.hideLeft,
      this.searchBarType = SearchBarType.normal,
      this.hint,
      this.defaultText,
      this.leftButtonClick,
      this.reghtButtonClick,
      this.speakClick,
      this.inputBoxClick,
      this.onChanged})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  // 是否展示清除输入框按钮
  bool showClear = false;
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return widget.searchBarType == SearchBarType.normal
        ? _genNormalSearch()
        : _genHomeSearch();
  }

  @override
  void initState() {
    if (widget.defaultText != null) {}
    super.initState();
  }

  _wrapTap(Widget widget, Function() callback) {
    return GestureDetector(
      onTap: () {
        if (callback != null) {
          callback();
        }
      },
      child: widget,
    );
  }

  _onChanged(String text) {
    setState(() {
      if (text.length > 0) {
        showClear = true;
      } else {
        showClear = false;
      }
    });
    if (widget.onChanged != null) {
      widget.onChanged(text);
    }
  }

  _homeFontColor() {
    return widget.searchBarType == SearchBarType.homeLight
        ? Colors.black54
        : Colors.white;
  }

  _inputBox() {
    Color inputBoxColor;
    if (widget.searchBarType == SearchBarType.home) {
      inputBoxColor = Colors.white;
    } else {
      inputBoxColor = Color(int.parse('0xffededed'));
    }
    return Container(
      height: 30,
      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      decoration: BoxDecoration(
          color: inputBoxColor,
          borderRadius: BorderRadius.circular(
              widget.searchBarType == SearchBarType.normal ? 5 : 15)),
      child: Row(
        children: <Widget>[
          Icon(
            Icons.search,
            size: 20,
            color: widget.searchBarType == SearchBarType.normal
                ? Color(0xffa9a9a9)
                : Colors.blue,
          ),
          Expanded(
            flex: 1,
            child: widget.searchBarType == SearchBarType.normal
                ? TextField(
                    controller: _controller,
                    // 自动聚焦
                    autofocus: true,
                    // 当有改变时
                    onChanged: _onChanged,
                    // 输入框样式
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    // 输入文本的样式
                    decoration: InputDecoration(
                      // 输入文字的padding
//                      contentPadding: EdgeInsets.zero,
                      contentPadding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                      // 如果定义contentPadding，isDense必须为true
                      isDense: true,
                      // 边逛
                      border: InputBorder.none,
                      // 默认文字
                      hintText: widget.hint ?? '',
                      // 默认文字样式
                      hintStyle: TextStyle(fontSize: 15),
                    ),
                    // 首页只需点击即可
                  )
                : _wrapTap(
                    Container(
                      child: Text(
                        widget.defaultText,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    widget.inputBoxClick),
          ),
          showClear
              ? _wrapTap(
                  Icon(
                    Icons.clear,
                    size: 22,
                    color: Colors.grey,
                  ), () {
                  setState(() {
                    // 清除输入框文字
                    _controller.clear();
                  });
                  _onChanged('');
                })
              : _wrapTap(
                  Icon(
                    Icons.mic,
                    size: 22,
                    color: widget.searchBarType == SearchBarType.normal
                        ? Colors.blue
                        : Colors.grey,
                  ),
                  widget.speakClick)
        ],
      ),
    );
  }

  _genNormalSearch() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(6, 5, 10, 5),
            child: widget.hideLeft
                ? null
                : _wrapTap(
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.grey,
                      size: 20,
                    ),
                    widget.leftButtonClick),
          ),
          Expanded(child: _inputBox(), flex: 1),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: _wrapTap(
                Text('搜索',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 26,
                    )),
                widget.reghtButtonClick),
          )
        ],
      ),
    );
  }

  _genHomeSearch() {
    return Container(
      height: 50,
      child: Row(
        children: <Widget>[
          _wrapTap(
              Container(
                padding: EdgeInsets.fromLTRB(6, 5, 5, 5),
                child: Row(
                  children: <Widget>[
                    Text(
                      '北京',
                      style: TextStyle(color: _homeFontColor(), fontSize: 14),
                    ),
                    Icon(
                      Icons.expand_more,
                      color: _homeFontColor(),
                      size: 22,
                    )
                  ],
                ),
              ),
              widget.leftButtonClick),
          Expanded(child: _inputBox(), flex: 1),
          Container(
            padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
            child: Icon(Icons.comment,color: _homeFontColor(),size: 26,),
          )
        ],
      ),
    );
  }
}
