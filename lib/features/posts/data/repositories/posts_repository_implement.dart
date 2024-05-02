import 'package:dartz/dartz.dart';
import 'package:posts_app/core/errors/failure.dart';
import 'package:posts_app/core/networks/network_info.dart';
import 'package:posts_app/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:posts_app/features/posts/data/models/posts_model.dart';
import 'package:posts_app/features/posts/domain/entities/posts_entity.dart';
import '../../../../core/errors/exception.dart';
import '../../domain/repositories/posts_repository.dart';
import '../datasources/posts_remote_data_source.dart';

typedef DeleteOrUpdateOrAddPost = Future<Unit> Function();

class PostsRepositoryImplement implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;
  PostsRepositoryImplement(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, List<PostsEntity>>> getPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPosts();
        localDataSource.cachedPosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on EmptyCacheException {
        return Left(EmptyCacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, Unit>> addPosts(PostsEntity post) async {
    final PostsModel postsModel =
        PostsModel(title: post.title, body: post.body);
    return _getMessage(() => remoteDataSource.addPosts(postsModel));
  }

  @override
  Future<Either<Failure, Unit>> updatePosts(PostsEntity post) async {
    final postsModel = PostsModel(title: post.title, body: post.body);
    return _getMessage(() => remoteDataSource.updatePosts(postsModel));
  }

  @override
  Future<Either<Failure, Unit>> deletePosts(int id) async {
    return _getMessage(() => remoteDataSource.deletePosts(id));
  }

  Future<Either<Failure, Unit>> _getMessage(
      DeleteOrUpdateOrAddPost deleteOrUpdateOrAddPost) async {
    if (await networkInfo.isConnected) {
      try {
        await deleteOrUpdateOrAddPost();
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
