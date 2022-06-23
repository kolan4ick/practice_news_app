import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/app/app.dart';
import 'package:practice_news_app/pages/login/login.dart';
import 'package:practice_news_app/repositories/article_repository.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/article_model.dart';
import '../models/user_model.dart';
import '../pages/profile/bloc/profile_bloc.dart';

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
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Theme.of(context).primaryColor),
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
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                          onPressed: () {
                            Share.share(articleModel.url ?? '');
                          },
                          icon: Icon(Icons.share),
                          label: Text("Переслати"),
                        ),
                        ElevatedButton.icon(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.green),
                          onPressed: () {
                            Navigator.pop(context);
                            if (userModel.isEmpty)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            else {
                              ArticleRepository articleRepository =
                                  ArticleRepository();
                              context.read<ProfileBloc>().add(
                                  ProfileArticleOnSaveRequested(
                                      articleModel, userModel));
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
                        style: TextButton.styleFrom(
                          primary: Colors.red,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                );
              },
              icon: Icon(
                Icons.more_vert,
                color: Colors.white,
              ),
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
                        color: Colors.white,
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
