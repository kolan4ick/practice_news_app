import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_news_app/models/article_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../repositories/api_repository.dart';
import '../../../widgets/article_item.dart';

class HeadlinesPage extends StatefulWidget {
  final ApiRepository _apiRepository;

  HeadlinesPage({Key? key, required ApiRepository apiRepository})
      : _apiRepository = apiRepository,
        super(key: key);

  @override
  _HeadlinesPageState createState() => _HeadlinesPageState(_apiRepository);
}

class _HeadlinesPageState extends State<HeadlinesPage> {
  final _numberOfArticleModelsPerRequest = 20;

  final _apiRepository;

  final PagingController<int, ArticleModel> _pagingController =
      PagingController(firstPageKey: 1);

  _HeadlinesPageState(ApiRepository apiRepository)
      : _apiRepository = apiRepository;

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<ArticleModel> articlesList = await _apiRepository.getArticles(
          pageKey, _numberOfArticleModelsPerRequest);
      final isLastPage = articlesList.length < _numberOfArticleModelsPerRequest;
      if (isLastPage) {
        _pagingController.appendLastPage(articlesList);
      } else {
        final nextPageKey = pageKey + 1;
        _pagingController.appendPage(articlesList, nextPageKey);
      }
    } catch (e) {
      print("error --> $e");
      _pagingController.error = e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Заголовки"),
      ),
      body: RefreshIndicator(
        onRefresh: () => Future.sync(() => _pagingController.refresh()),
        child: PagedListView<int, ArticleModel>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<ArticleModel>(
            itemBuilder: (context, item, index) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: ArticleItem(
                  item.title.toString(), item.url.toString(), item.urlToImage),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
