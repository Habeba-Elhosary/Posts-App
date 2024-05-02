import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/domain/repositories/posts_repository.dart';
import '../../../../core/errors/failure.dart';
import '../entities/posts_entity.dart';

class GetPostsUsecase {
  final PostsRepository repository;

  GetPostsUsecase(this.repository);

  Future<Either<Failure, List<PostsEntity>>> call() async {
    return await repository.getPosts();
  }
}
