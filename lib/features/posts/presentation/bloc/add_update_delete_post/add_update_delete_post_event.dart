import 'package:posts_app/features/posts/domain/entities/posts_entity.dart';
import 'package:equatable/equatable.dart';


abstract class AddDeleteUpdatePostEvent extends Equatable {
  const AddDeleteUpdatePostEvent();

  @override
  List<Object> get props => [];
}

class AddPostEvent extends AddDeleteUpdatePostEvent {
  final PostsEntity post;

  const AddPostEvent({required this.post});

  @override
  List<Object> get props => [post];
}

class UpdatePostEvent extends AddDeleteUpdatePostEvent {
  final PostsEntity post;

  const UpdatePostEvent({required this.post});

  @override
  List<Object> get props => [post];
}

class DeletePostEvent extends AddDeleteUpdatePostEvent {
  final int postId;

  const DeletePostEvent({required this.postId});

  @override
  List<Object> get props => [postId];
}