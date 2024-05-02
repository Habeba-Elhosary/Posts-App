import 'package:posts_app/features/posts/domain/entities/posts_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<PostsEntity>>> getPosts();
  Future<Either<Failure, Unit>> updatePosts(PostsEntity post);
  Future<Either<Failure, Unit>> addPosts(PostsEntity post);
  Future<Either<Failure, Unit>> deletePosts(int id);
}
