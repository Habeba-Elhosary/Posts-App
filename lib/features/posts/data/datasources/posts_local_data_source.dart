import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/data/models/posts_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/errors/exception.dart';

abstract class PostsLocalDataSource {
  Future<Unit> cachedPosts(List<PostsModel> postModels);
  Future<List<PostsModel>> getCachedPosts();
}

const cachedposts = 'CACHED_POSTS';

class PostsLocalDataSourceImplement implements PostsLocalDataSource {
  final SharedPreferences sharedPreferences;

  PostsLocalDataSourceImplement({required this.sharedPreferences});
  @override
  Future<Unit> cachedPosts(List<PostsModel> postModels) {
    List postModelsToJson = postModels
        .map<Map<String, dynamic>>((postModel) => postModel.toJson())
        .toList();
    sharedPreferences.setString(cachedposts, json.encode(postModelsToJson));
    return Future.value(unit);
  }

  @override
  Future<List<PostsModel>> getCachedPosts() {
    final jsonString = sharedPreferences.getString('CACHED_POSTS');
    if (jsonString != null) {
      List decodeJsonData = json.decode(jsonString);
      List<PostsModel> jsonToPostsModels = decodeJsonData
          .map<PostsModel>(
              (jsonPostModel) => PostsModel.fromJson(jsonPostModel))
          .toList();
      return Future.value(jsonToPostsModels);
    } else {
      throw EmptyCacheException();
    }
  }
}
