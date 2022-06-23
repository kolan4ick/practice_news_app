import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/app/app.dart';
import '../../../repositories/authentication_repository.dart';
import '../../home/view/home_page.dart';
import '../../sign_up/sign_up.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(builder: (_) => SignUpPage());
  }

  @override
  Widget build(BuildContext context) {
    if(context.select((AppBloc bloc) => bloc.state.status) == AppStatus.authenticated) {
      return const HomePage();
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Реєстрація'),
        backgroundColor: Color.fromARGB(255, 143, 218, 212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: BlocProvider<SignUpCubit>(
          create: (_) => SignUpCubit(context.read<AuthenticationRepository>()),
          child: const SignUpForm(),
        ),
      ),
    );
  }
}
