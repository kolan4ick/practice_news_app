part of 'profile_bloc.dart';

enum ProfileStatus { unloaded, loaded }

@immutable
class ProfileState extends Equatable {
  final List<ArticleModel> list;

  const ProfileState._({
    required this.status,
    required this.list,
  });

  ProfileState.unloaded(
      {required ProfileStatus status, required List<ArticleModel> list})
      : this._(status: ProfileStatus.unloaded, list: list);

  ProfileState.loaded(
      {required ProfileStatus status, required List<ArticleModel> list})
      : this._(status: ProfileStatus.loaded, list: list);

  final ProfileStatus status;

  @override
  List<Object> get props => [status, list];
}

class ProfileInitial extends ProfileState {
  ProfileInitial() : super.unloaded(status: ProfileStatus.unloaded, list: []);
}
