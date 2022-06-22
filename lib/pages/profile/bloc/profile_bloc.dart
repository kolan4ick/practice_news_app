import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:meta/meta.dart';
import 'package:practice_news_app/models/article_model.dart';
import 'package:practice_news_app/models/user_model.dart';
import 'package:practice_news_app/widgets/article_item.dart';
import '../../../repositories/article_repository.dart';

part 'profile_event.dart';

part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ArticleRepository _articleRepository;

  ProfileBloc({required articleRepository})
      : _articleRepository = articleRepository,
        super(ProfileInitial()) {
    on<ProfileArticleDeleteRequested>(_onArticleDeleteRequested);
    on<ProfileArticleOnLoadRequested>(_onArticleOnLoadRequested);
    on<ProfileArticleOnSaveRequested>(_onArticleOnSaveRequested);
  }

  Future<void> _onArticleDeleteRequested(
      ProfileArticleDeleteRequested event, Emitter<void> emit) async {
    await _articleRepository.deleteArticle(event.article);
    //TODO check the bug with deleting article
    var articles =
        state.list.where((element) => element.id != event.article.id).toList();
    emit(ProfileState.unloaded(
      status: ProfileStatus.unloaded,
      list: articles,
    ));
  }

  Future<void> _onArticleOnLoadRequested(
      ProfileArticleOnLoadRequested event, Emitter<void> emit) async {
    final articles = await _articleRepository.getArticles();
    emit(ProfileState.loaded(
      status: ProfileStatus.loaded,
      list: articles,
    ));
  }

  Future<void> _onArticleOnSaveRequested(
      ProfileArticleOnSaveRequested event, Emitter<void> emit) async {
    String? id =
        await _articleRepository.saveArticle(event.article, event.user);
    event.article.id = id;
    var articles = state.list;
    articles.add(event.article);
    print(event.article.id);
    emit(ProfileState.loaded(
      status: ProfileStatus.loaded,
      list: articles,
    ));
  }
}
