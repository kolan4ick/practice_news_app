import 'dart:convert';

import 'package:http/http.dart';

import '../models/article_model.dart';

class ApiRepository {
  Future<List<ArticleModel>> getArticles(int page, int perPage,
      {String passphrase = ''}) async {
    final _endPointUrl =
        "https://newsapi.org/v2/top-headlines?country=ua&apiKey=7637fe4ed925460ab03d1eee1c0f7aff&q=$passphrase&page=$page&pageSize=$perPage";
    Response res = await get(Uri.parse(_endPointUrl));

    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      List<dynamic> body = json['articles'];

      List<ArticleModel> articles =
          body.map((dynamic item) => ArticleModel.fromJson(item)).toList();
      return articles;
    } else {
      throw ("Can't get the Articles");
    }
  }
}
