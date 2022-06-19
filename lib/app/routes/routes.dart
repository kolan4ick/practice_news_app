import 'package:flutter/widgets.dart';
import '/app/app.dart';
import '../../pages/home/home.dart';
import '/test/view/test_page.dart';

List<Page> onGenerateAppViewPages(AppStatus state, List<Page<dynamic>> pages) {
  return [HomePage.page()];
}
