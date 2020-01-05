import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xiecheng/model/search_model.dart';


class SearchDao {
  static Future<SearchModel> fetch(String url, String text) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      // 用来存储当前搜索的是什么，防止输入过快的时候展示的不是当前搜索
      SearchModel model = SearchModel.fromJson(result);
      model.keyword = text;
      return model;
    } else {
      throw Exception('请求searchJson失败');
    }
  }
}
