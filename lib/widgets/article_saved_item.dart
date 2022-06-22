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

class ArticleSavedItem extends StatefulWidget {
  final ArticleModel articleModel;

  ArticleSavedItem({required this.articleModel});

  @override
  State<StatefulWidget> createState() {
    return _ArticleSavedItemState(articleModel);
  }
}

class _ArticleSavedItemState extends State<ArticleSavedItem> {
  final _articleModel;

  _ArticleSavedItemState(this._articleModel);

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
          color: Color.fromARGB(255, 95, 202, 193)),
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
                            Share.share(_articleModel.url ?? '');
                          },
                          icon: Icon(Icons.share),
                          style: ElevatedButton.styleFrom(primary: Colors.blue),
                          label: Text("Переслати"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Видалено'),
                              ),
                            );
                            context.read<ProfileBloc>().add(
                                ProfileArticleDeleteRequested(
                                    this._articleModel));
                          },
                          icon: Icon(Icons.delete),
                          label: Text("Видалити"),
                          style: ElevatedButton.styleFrom(primary: Colors.red),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text('Відміна'),
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(primary: Colors.red),
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
                _launchURLBrowser(_articleModel.url ?? '');
              },
              child: Column(
                children: [
                  if (_articleModel.urlToImage != null)
                    Image.network(
                      '${_articleModel.urlToImage}',
                      fit: BoxFit.fill,
                    ),
                  Text(
                    _articleModel.title ?? '',
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
