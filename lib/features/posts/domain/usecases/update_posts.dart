import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/domain/entities/posts_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repositories/posts_repository.dart';

class UpdatePostsUsecase {
  final PostsRepository repository;

  UpdatePostsUsecase(this.repository);

  Future<Either<Failure, Unit>> call(PostsEntity post) async {
    return await repository.updatePosts(post);
  }
}
