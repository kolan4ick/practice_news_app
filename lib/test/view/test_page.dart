import 'package:flutter/material.dart';
import '../../pages/login/login.dart';

class TestPage extends StatelessWidget {
  const TestPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: TestPage());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Test')),
      body: Center(
        child: RaisedButton(
          child: const Text('Go to Login'),
          onPressed: () {
            Navigator.of(context).push<Object>(
              MaterialPageRoute(builder: (context) => const LoginPage()),
            );
          },
        ),
      ),
    );
  }
}
