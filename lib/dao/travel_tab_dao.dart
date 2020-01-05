
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xiecheng/model/travel_tab_model.dart';

const TRAVEL_TAB_URL = 'https://www.devio.org/io/flutter_app/json/travel_page.json';

// 旅拍首页
class TravelTabDao {
  static Future<TravelTabModel> fetch() async {
    final response = await http.get(TRAVEL_TAB_URL);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return TravelTabModel.fromJson(result);
    } else {
      throw Exception('请求homeJson失败');
    }
  }
}