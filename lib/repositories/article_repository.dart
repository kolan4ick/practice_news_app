import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/app/app.dart';
import 'package:practice_news_app/models/article_model.dart';
import 'package:practice_news_app/models/user_model.dart';
import 'package:practice_news_app/repositories/authentication_repository.dart';

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

  /* Get articles from firebase database for current logged in user */
  Future<List<ArticleModel>> getArticles() async {
    // get articles from firebase firestore database
    final db = FirebaseFirestore.instance;
    final articleRef = db.collection('articles');
    final article = await articleRef.get();
    // get current logged in user id
    final userId = FirebaseAuth.instance.currentUser?.uid;
    print(userId);
    return article.docs
        .where((element) => element.data()["userId"] == userId)
        .map((doc) => ArticleModel.fromJson(doc.data(), id: doc.id))
        .toList();
  }

  void deleteArticle(ArticleModel articleModel) {
    // delete article from firebase firestore database
    final db = FirebaseFirestore.instance;
    final articleRef = db.collection('articles');
    articleRef.doc(articleModel.id).delete();
  }
}
