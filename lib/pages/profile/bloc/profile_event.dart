part of 'profile_bloc.dart';

@immutable
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfileArticleDeleteRequested extends ProfileEvent {
  final ArticleModel article;

  const ProfileArticleDeleteRequested(this.article);
}

class ProfileArticleOnLoadRequested extends ProfileEvent {}

class ProfileArticleOnSaveRequested extends ProfileEvent {
  final ArticleModel article;
  final UserModel user;

  const ProfileArticleOnSaveRequested(this.article, this.user);
}
