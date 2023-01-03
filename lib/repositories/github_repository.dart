import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_github/bloc/github_bloc.dart';
import 'package:flutter_github/model/issues_response.dart';
import 'package:flutter_github/model/repositories_response.dart';
import 'package:flutter_github/model/users_response.dart';

class GithubRepository {
  static Dio dio = Dio();

  static Future fetchDataGithub({
    required TypeFilter filterBy,
    required int perPage,
    required int page,
    required String query,
  }) async {
    String url = "https://api.github.com/search";
    Map<String, dynamic> queryParam = {"per_page": perPage, "page": page};
    queryParam["q"] = query.isEmpty ? "doraemon" : query;

    try {
      final response = await dio.get(
        "$url/${filterBy.name.toLowerCase()}",
        queryParameters: queryParam,
        options: Options(headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        }),
      );
      if (response.statusCode == 200) {
        switch (filterBy) {
          case TypeFilter.Users:
            return UserResponse.fromJson(response.data);
          case TypeFilter.Issues:
            return IssueResponse.fromJson(response.data);

          case TypeFilter.Repositories:
            return RepositoriesResponse.fromJson(response.data);
        }
      }
      return response.data;
    } catch (e) {
      if (e is DioError) {
        log(
          "Error ${e.response?.realUri.toString()}",
          error: "${e.response?.data}",
        );

        switch (e.type) {
          case DioErrorType.connectTimeout:
            throw "Connection Time Out";
          case DioErrorType.sendTimeout:
            throw "Send Time Out";

          case DioErrorType.receiveTimeout:
            throw "Receive Time Out";

          case DioErrorType.response:
            throw "${e.response?.data['message']}";
          case DioErrorType.cancel:
            throw "Cancel";

          case DioErrorType.other:
            throw e.message;
        }
      }
      throw e.toString();
    }
  }
}
