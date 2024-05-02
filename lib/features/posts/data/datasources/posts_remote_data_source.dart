import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:posts_app/features/posts/data/models/posts_model.dart';
import 'package:http/http.dart' as http;
import '../../../../core/errors/exception.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostsModel>> getPosts();
  Future<Unit> addPosts(PostsModel post);
  Future<Unit> updatePosts(PostsModel post);
  Future<Unit> deletePosts(int id);
}

const baseUrl = 'https://jsonplaceholder.typicode.com';

class PostsRemoteDataSourceImplement implements PostsRemoteDataSource {
  final http.Client client;

  PostsRemoteDataSourceImplement({required this.client});
  @override
  Future<List<PostsModel>> getPosts() async {
    final response = await client.get(
      Uri.parse('$baseUrl/posts/'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.body) as List;
      final List<PostsModel> postModels = decodedJson
          .map<PostsModel>(
              (jsonPostModel) => PostsModel.fromJson(jsonPostModel))
          .toList();
      return postModels;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> addPosts(PostsModel post) async {
    final body = {
      'title': post.title,
      'body': post.body,
    };
    final response = await client.post(
      Uri.parse('$baseUrl/posts/'),
      body: body,
    );
    if (response.statusCode == 201) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> updatePosts(PostsModel post) async {
    final body = {
      'title': post.title,
      'body': post.body,
    };
    final response = await client.patch(
      Uri.parse('$baseUrl/posts/${post.id}'),
      body: body,
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Unit> deletePosts(int id) async {
    final response = await client.delete(
      Uri.parse('$baseUrl/posts/$id'),
      headers: {"Content-Type": "application/json"},
    );
    if (response.statusCode == 200) {
      return Future.value(unit);
    } else {
      throw ServerException();
    }
  }
}
