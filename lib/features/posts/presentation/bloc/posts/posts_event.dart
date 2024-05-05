part of 'posts_bloc.dart';

abstract class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

final class GetAllPostsEvent extends PostsEvent {}

final class RefreshPostsEvent extends PostsEvent {}
