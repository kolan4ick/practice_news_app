import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_news_app/models/user_model.dart';
import 'package:practice_news_app/repositories/article_repository.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../../models/article_model.dart';
import '../../../repositories/api_repository.dart';
import '../../../widgets/article_saved_item.dart';

class ProfilePage extends StatefulWidget {
  final ArticleRepository _articleRepository;

  ProfilePage({Key? key, required ArticleRepository articleRepository})
      : _articleRepository = articleRepository,
        super(key: key);

  @override
  _ProfilePageState createState() {
    return _ProfilePageState(_articleRepository);
  }
}

class _ProfilePageState extends State<ProfilePage> {
  final _articleRepository;
  var _articles = [];

  _ProfilePageState(this._articleRepository) {}

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final articles = await _articleRepository.getArticles();
      setState(() {
        _articles = articles.map((element) {
          print(element.title);
          return ArticleSavedItem(articleModel: element);
        }).toList();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Заголовки"),
      ),
      body: _articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Center(child: Text('Ваш профіль')),
                    Center(child: Text('Імя: ${userModel.name}')),
                    ..._articles.map((element) {
                      return (Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        element
                      ]));
                    }),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () {
          context.read<AppBloc>().add(AppLogoutRequested());
          Navigator.pop(context);
        },
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
