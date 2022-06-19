
import 'package:practice_news_app/models/source_model.dart';

class ArticleModel {
  Source source;
  String author;
  String title;
  String description;
  String url;
  String urlToImage;
  String publishedAt;
  String content;

  ArticleModel(
      {required this.source,
        required this.author,
        required this.title,
        required this.description,
        required this.url,
        required this.urlToImage,
        required this.publishedAt,
        required this.content});

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: Source.fromJson(json['source']),
      author: json['author'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      url: json['url'] as String,
      urlToImage: json['urlToImage'] as String,
      publishedAt: json['publishedAt'] as String,
      content: json['content'] as String,
    );
  }
}
