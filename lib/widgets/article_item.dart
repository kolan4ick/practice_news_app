import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/app/app.dart';
import 'package:practice_news_app/pages/login/login.dart';
import 'package:practice_news_app/repositories/article_repository.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article_model.dart';
import '../models/user_model.dart';

class ArticleItem extends StatelessWidget {
  final ArticleModel articleModel;

  ArticleItem({required this.articleModel});

  _launchURLBrowser(String link) async {
    var url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = context.select((AppBloc bloc) => bloc.state.user);
    return Container(
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.amber),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Дії'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            Share.share(articleModel.url ?? '');
                          },
                          icon: Icon(Icons.share),
                          label: Text("Переслати"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (userModel.isEmpty)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            else {
                              ArticleRepository articleRepository =
                                  ArticleRepository();
                              articleRepository
                                  .saveArticle(articleModel, userModel)
                                  .then((value) {
                                if (value) {
                                  // close the alert dialog
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Збережено'),
                                    ),
                                  );
                                }
                              });
                            }
                          },
                          icon: Icon(Icons.save),
                          label: Text("Зберегти"),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Відміна'),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(Icons.more_vert),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: InkWell(
              onTap: () {
                _launchURLBrowser(articleModel.url ?? '');
              },
              child: Column(
                children: [
                  if (articleModel.urlToImage != null)
                    Image.network(
                      '${articleModel.urlToImage}',
                      fit: BoxFit.fill,
                    ),
                  Text(
                    articleModel.title ?? '',
                    style: const TextStyle(
                        color: Colors.purple,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
