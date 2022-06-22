import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/models/user_model.dart';
import 'package:practice_news_app/pages/profile/bloc/profile_bloc.dart';
import 'package:practice_news_app/repositories/article_repository.dart';
import 'package:practice_news_app/widgets/article_item.dart';

import '../../../app/bloc/app_bloc.dart';
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Заголовки"),
        backgroundColor: Color.fromARGB(255, 143, 218, 212),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Center(child: Text('Ваш профіль')),
              Center(child: Text('Імя: ${userModel.name}')),
              BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (_, ProfileState state) {
                _articles = <ArticleSavedItem>[];
                if (state.status == ProfileStatus.unloaded) {
                  context
                      .read<ProfileBloc>()
                      .add(ProfileArticleOnLoadRequested());
                  return CircularProgressIndicator();
                } else if (state.status == ProfileStatus.loaded) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: state.list.length,
                    itemBuilder: (_, index) =>
                        ArticleSavedItem(articleModel: state.list[index]),
                  );
                } else
                  return Text("error");
              })
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
