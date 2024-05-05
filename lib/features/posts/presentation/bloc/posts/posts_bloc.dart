import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:posts_app/core/constants/failures.dart';
import 'package:posts_app/core/errors/failure.dart';
import 'package:posts_app/features/posts/domain/entities/posts_entity.dart';
import 'package:posts_app/features/posts/domain/usecases/get_posts.dart';
part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  final GetPostsUsecase getAllPostsUsecase;
  PostsBloc({required this.getAllPostsUsecase}) : super(PostsInitialState()) {
    on<PostsEvent>((event, emit) async {
      if (event is GetAllPostsEvent || event is RefreshPostsEvent) {
        emit(PostsLoadingState());
        final failuresOrPosts = await getAllPostsUsecase();
        emit(_mapFailureOrPostsToState(failuresOrPosts));
      }
    });
  }

  PostsState _mapFailureOrPostsToState(
      Either<Failure, List<PostsEntity>> either) {
    return either.fold(
      (failure) => PostsErrorState(message: _mapFailureToMessage(failure)),
      (posts) => PostsLoadedState(
        posts: posts,
      ),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return SERVER_FAILURE_MESSAGE;
      case EmptyCacheFailure _:
        return EMPTY_CACHE_FAILURE_MESSAGE;
      case OfflineFailure _:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return 'Unexpected Error , please try again later.';
    }
  }
}
