import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/pages/profile/bloc/profile_bloc.dart';
import 'package:practice_news_app/repositories/article_repository.dart';
import 'package:practice_news_app/repositories/authentication_repository.dart';

import 'app/bloc/app_bloc.dart';
import 'app/bloc_observer.dart';
import 'app/view/app.dart';

Future<void> main() {
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await Firebase.initializeApp();
      final authenticationRepository = AuthenticationRepository();
      await authenticationRepository.user.first;
      runApp(MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                ProfileBloc(articleRepository: ArticleRepository()),
          ),
          BlocProvider(
            create: (context) => AppBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
        ],
        child: App(authenticationRepository: authenticationRepository),
      ));
    },
    blocObserver: AppBlocObserver(),
  );
}
