import 'package:bloc/bloc.dart';
import 'package:posts_app/core/constants/failures.dart';
import 'package:posts_app/features/posts/domain/usecases/delete_posts.dart';
import '../../../../../core/constants/messages.dart';
import '../../../../../core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import '../../../domain/usecases/add_posts.dart';
import '../../../domain/usecases/update_posts.dart';
import 'add_update_delete_post_event.dart';
import 'add_update_delete_post_state.dart';

class AddDeleteUpdatePostBloc
    extends Bloc<AddDeleteUpdatePostEvent, AddDeleteUpdatePostState> {
  final AddPostsUsecase addPost;
  final DeletePostsUsecase deletePost;
  final UpdatePostsUsecase updatePost;
  AddDeleteUpdatePostBloc(
      {required this.addPost,
      required this.deletePost,
      required this.updatePost})
      : super(AddDeleteUpdatePostInitial()) {
    on<AddDeleteUpdatePostEvent>((event, emit) async {
      if (event is AddPostEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await addPost(event.post);

        emit(
          _eitherDoneMessageOrErrorState(
              failureOrDoneMessage, ADD_SUCCESS_MESSAGE),
        );
      } else if (event is UpdatePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await updatePost(event.post);

        emit(
          _eitherDoneMessageOrErrorState(
              failureOrDoneMessage, UPDATE_SUCCESS_MESSAGE),
        );
      } else if (event is DeletePostEvent) {
        emit(LoadingAddDeleteUpdatePostState());

        final failureOrDoneMessage = await deletePost(event.postId);

        emit(
          _eitherDoneMessageOrErrorState(
              failureOrDoneMessage, DELETE_SUCCESS_MESSAGE),
        );
      }
    });
  }

  AddDeleteUpdatePostState _eitherDoneMessageOrErrorState(
      Either<Failure, Unit> either, String message) {
    return either.fold(
      (failure) => ErrorAddDeleteUpdatePostState(
        message: _mapFailureToMessage(failure),
      ),
      (_) => MessageAddDeleteUpdatePostState(message: message),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure _:
        return SERVER_FAILURE_MESSAGE;
      case OfflineFailure _:
        return OFFLINE_FAILURE_MESSAGE;
      default:
        return "Unexpected Error , Please try again later .";
    }
  }
}
