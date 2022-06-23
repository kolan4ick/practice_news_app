import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/models/user_model.dart';
import 'package:practice_news_app/pages/profile/bloc/profile_bloc.dart';
import 'package:practice_news_app/providers/theme_provider.dart';
import 'package:practice_news_app/repositories/article_repository.dart';
import 'package:practice_news_app/widgets/article_item.dart';
import 'package:practice_news_app/widgets/avatar.dart';

import '../../../app/bloc/app_bloc.dart';
import '../../../widgets/article_saved_item.dart';
import '../../../widgets/change_theme_button.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required ArticleRepository articleRepository})
      : super(key: key);

  @override
  _ProfilePageState createState() {
    return _ProfilePageState();
  }
}

class _ProfilePageState extends State<ProfilePage> {
  _ProfilePageState() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        actions: [
          ChangeThemeButtonWidget(),
        ],
        title: const Text("Профіль"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              //avatar
              Avatar(
                photo: userModel.photo,
              ),
              Center(
                  child: Text('${userModel.name}',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold))),
              BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (_, ProfileState state) {
                if (state.status == ProfileStatus.unloaded) {
                  context
                      .read<ProfileBloc>()
                      .add(ProfileArticleOnLoadRequested());
                  return CircularProgressIndicator();
                } else if (state.status == ProfileStatus.loaded) {
                  return Column(children: [
                    ...state.list.map((element) {
                      return (Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        ArticleSavedItem(articleModel: element),
                      ]));
                    })
                  ]);
                  /*return ListView.builder(
                    shrinkWrap: true,
                    itemCount: state.list.length,
                    itemBuilder: (_, index) => (Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      ArticleSavedItem(articleModel: state.list[index]),
                    ])),
                  );*/
                } else
                  return Text("error");
              })
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        backgroundColor: Theme.of(context).primaryColorLight,
        onPressed: () {
          context.read<AppBloc>().add(AppLogoutRequested());
          Navigator.pop(context);
        },
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
