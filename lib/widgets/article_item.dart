import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/app/app.dart';
import 'package:practice_news_app/pages/login/login.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleItem extends StatelessWidget {
  final String title;
  final String url;
  final String? imageUrl;

  ArticleItem(this.title, this.url, this.imageUrl);

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
    AppStatus appStatus = context.select((AppBloc bloc) => bloc.state.status);
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
                            Share.share(url);
                          },
                          icon: Icon(Icons.share),
                          label: Text("Переслати"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (appStatus == AppStatus.unauthenticated)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            else {
                              //  TODO saving to database if user signed in

                            }
                          },
                          icon: Icon(Icons.share),
                          label: Text("Переслати"),
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
                _launchURLBrowser(url);
              },
              child: Column(
                children: [
                  if (imageUrl != null)
                    Image.network(
                      '$imageUrl',
                      fit: BoxFit.fill,
                    ),
                  Text(
                    title,
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
