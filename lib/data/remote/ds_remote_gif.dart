import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tech_test/data/ds/ds_gif.dart';
import 'package:tech_test/entities.dart';

import 'giphy_web_helper.dart' as webHelper;

const int PAGE_OFFSET = 25;

class GifRemoteDs implements GifDs {
  static GifRemoteDs _instance = GifRemoteDs._internal();

  factory GifRemoteDs() {
    return _instance;
  }

  GifRemoteDs._internal();

  @override
  Future<List<Gif>> getGifPageByQuery(int pageNum, String query) async {
    http.Response response = await webHelper.get(webHelper.getPageByQuery(
      pageNum == 0 ? 0 : pageNum * PAGE_OFFSET + 1,
      query,
    ));

    return (json.decode(response.body)["data"] as List).map((it) {
      return Gif.fromJson(it);
    }).toList();
  }
}
