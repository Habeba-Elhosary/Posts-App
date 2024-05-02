import 'package:dartz/dartz.dart';
import 'package:posts_app/core/errors/failure.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';

class DeletePostsUsecase {
  final PostsRepository repository;

  DeletePostsUsecase({required this.repository});

  Future<Either<Failure, Unit>> call(int id) async {
    return await repository.deletePosts(id);
  }
}
