import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';
import '../../../../core/errors/failure.dart';
import '../entities/posts_entity.dart';

class AddPostsUsecase {
  final PostsRepository repository;

  AddPostsUsecase(this.repository);

  Future<Either<Failure, Unit>> call(PostsEntity post) async {
    return await repository.addPosts(post);
  }
}
