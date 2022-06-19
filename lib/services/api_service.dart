import 'dart:convert';

import 'package:http/http.dart';

import '../models/article_model.dart';

class ApiService {
  final endPointUrl =
      "http://newsapi.org/v2/top-headlines?country=id&apiKey=7637fe4ed925460ab03d1eee1c0f7aff";

  Future<List<ArticleModel>> getArticle() async {
    Response res = await get(Uri(scheme: endPointUrl));

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
