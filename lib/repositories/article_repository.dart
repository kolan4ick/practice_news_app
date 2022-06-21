import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:practice_news_app/models/article_model.dart';
import 'package:practice_news_app/models/user_model.dart';

class ArticleRepository {
  ArticleRepository();

  Future<bool> saveArticle(
      ArticleModel articleModel, UserModel userModel) async {
    // save article to firebase firestore database
    final db = FirebaseFirestore.instance;
    final articleRef = db.collection('articles');
    final article = <String, dynamic>{
      'userId': userModel.id,
      'author': articleModel.author,
      'title': articleModel.title,
      'description': articleModel.description,
      'url': articleModel.url,
      'urlToImage': articleModel.urlToImage,
      'publishedAt': articleModel.publishedAt,
      'content': articleModel.content,
    };
    try {
      db.collection("articles").add(article).then((DocumentReference doc) =>
          print('DocumentSnapshot added with ID: ${doc.id}'));
    } catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}
