import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:posts_app/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:posts_app/features/posts/data/repositories/posts_repository_implement.dart';
import 'package:posts_app/features/posts/domain/usecases/add_posts.dart';
import 'package:posts_app/features/posts/domain/usecases/get_posts.dart';
import 'package:posts_app/features/posts/domain/usecases/update_posts.dart';
import 'package:posts_app/features/posts/presentation/bloc/posts/posts_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/networks/network_info.dart';
import 'package:http/http.dart' as http;
import 'features/posts/data/datasources/posts_remote_data_source.dart';
import 'features/posts/domain/repositories/posts_repository.dart';
import 'features/posts/domain/usecases/delete_posts.dart';
import 'features/posts/presentation/bloc/add_update_delete_post/add_update_delete_post_bloc.dart';

final getIt = GetIt.instance;

Future<void> init() async {
// ! Features
// Blocs
  getIt.registerFactory(() => PostsBloc(getAllPostsUsecase: getIt()));
  getIt.registerFactory(() => AddDeleteUpdatePostBloc(
        addPost: getIt(),
        deletePost: getIt(),
        updatePost: getIt(),
      ));

// Usecases
  getIt.registerLazySingleton(() => GetPostsUsecase(getIt()));
  getIt.registerLazySingleton(() => AddPostsUsecase(getIt()));
  getIt.registerLazySingleton(() => UpdatePostsUsecase(getIt()));
  getIt.registerLazySingleton(() => DeletePostsUsecase(repository: getIt()));

// Repositories
  getIt.registerLazySingleton<PostsRepository>(() => PostsRepositoryImplement(
        remoteDataSource: getIt(),
        localDataSource: getIt(),
        networkInfo: getIt(),
      ));

// Data sources
  getIt.registerLazySingleton<PostsRemoteDataSource>(
      () => PostsRemoteDataSourceImplement(client: getIt()));
  getIt.registerLazySingleton<PostsLocalDataSource>(
      () => PostsLocalDataSourceImplement(sharedPreferences: getIt()));

// ! Core
  getIt.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImplement(internetConnectionChecker: getIt()));

// ! External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => InternetConnectionChecker());
}
