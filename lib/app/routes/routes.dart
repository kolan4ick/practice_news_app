import 'package:flutter/widgets.dart';
import '/app/app.dart';
import '/home/home.dart';
import '/test/view/test_page.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  switch (state) {
    case AppStatus.authenticated:
      return [HomePage.page()];
    case AppStatus.unauthenticated:
      return [TestPage.page()];
  }
}
