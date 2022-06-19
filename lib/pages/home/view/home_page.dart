import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:practice_news_app/headlines/view/headlines_page.dart';
import 'package:practice_news_app/pages/login/login.dart';
import '../../profile/view/profile_page.dart';
import '../../search/view/search_page.dart';
import '/app/app.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: HomePage());

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _pages = [
    HeadlinesPage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final user = context.select((AppBloc bloc) => bloc.state.user);
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() {
          if (index == 2 && user.isEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else {
            _currentIndex = index;
          }
        }),
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Заголовки',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: 'Пошук',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_circle),
            label: 'Профіль',
          ),
        ],
      ),
    );
  }
}
