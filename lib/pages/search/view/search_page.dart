import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:practice_news_app/repositories/api_repository.dart';

import '../../../models/article_model.dart';
import '../../../widgets/article_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  static Page page() => const MaterialPage<void>(child: SearchPage());

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Пошук'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MySearchDelegate());
            },
          ),
        ],
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate<String> {
  final _numberOfArticleModelsPerRequest = 20;

  final _apiRepository;

  final PagingController<int, ArticleModel> _pagingController =
      PagingController(firstPageKey: 1);

  MySearchDelegate() : _apiRepository = ApiRepository(){
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      List<ArticleModel> articlesList = await _apiRepository.getArticles(
          pageKey, _numberOfArticleModelsPerRequest,
          passphrase: query);
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
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            close(context, "null");
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, "null");
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    _pagingController.refresh();
    return RefreshIndicator(
      onRefresh: () => Future.sync(() => _pagingController.refresh()),
      child: PagedListView<int, ArticleModel>(
        pagingController: _pagingController,
        builderDelegate: PagedChildBuilderDelegate<ArticleModel>(
          itemBuilder: (context, item, index) => Padding(
            padding: const EdgeInsets.all(15.0),
            child: ArticleItem(articleModel: item),
          ),
        ),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child: Text('Пропозиції пошуку'),
    );
  }
}
