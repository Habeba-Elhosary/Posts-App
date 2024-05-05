part of 'posts_bloc.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

final class PostsInitialState extends PostsState {}

final class PostsLoadingState extends PostsState {}

final class PostsLoadedState extends PostsState {
  final List<PostsEntity> posts;
  const PostsLoadedState({required this.posts});
  @override
  List<Object> get props => [posts];
}

final class PostsErrorState extends PostsState {
  final String message;
  const PostsErrorState({required this.message});
  @override
  List<Object> get props => [message];
}
