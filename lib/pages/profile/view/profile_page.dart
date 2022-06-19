import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/models/user_model.dart';

import '../../../app/bloc/app_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: ProfilePage());

  @override
  Widget build(BuildContext context) {
    UserModel userModel = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль'),
      ),
      body: ListView(
        children: [
          Center(child: Text('Ваш профіль')),
          Center(child: Text('Імя: ${userModel.name}')),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 5,
        onPressed: () {
          // logout
          context.read<AppBloc>().add(AppLogoutRequested());
          Navigator.pop(context);
        },
        child: const Icon(Icons.exit_to_app),
      ),
    );
  }
}
