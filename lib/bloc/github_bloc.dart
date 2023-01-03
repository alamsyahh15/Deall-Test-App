import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_github/main.dart';
import 'package:flutter_github/model/issues_response.dart';
import 'package:flutter_github/model/repositories_response.dart';
import 'package:flutter_github/model/users_response.dart';
import 'package:flutter_github/repositories/github_repository.dart';

enum TypeLoad { Lazy, Indexing }

enum TypeFilter { Users, Issues, Repositories }

class GithubBloc extends ChangeNotifier {
  GithubBloc() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        if (typeLoad == TypeLoad.Lazy) {
          loadMore();
          log("Result => tes");
        }
      }
    });
  }
  List<User> listUser = [], backupListUser = [];
  List<Issue> listIssue = [], backupListIssue = [];
  List<Repository> listRepository = [], backupListRepository = [];
  int perPage = 20;
  int page = 1;
  int totalPage = 1;

  String queryData = "";
  TypeFilter filterSelected = TypeFilter.Users;
  TypeLoad typeLoad = TypeLoad.Lazy;
  ScrollController scrollController = ScrollController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool val) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _isLoading = val;
      notifyListeners();
    });
  }

  void onTapFilter(TypeFilter type) {
    page = 1;
    totalPage = 1;
    filterSelected = type;
    fetchGitData();
    notifyListeners();
  }

  void onTapTypeLoad(TypeLoad type) {
    page = 1;
    typeLoad = type;
    fetchGitData();
    notifyListeners();
  }

  void onSearch(String query) {
    queryData = query;
    switch (filterSelected) {
      case TypeFilter.Users:
        listUser = backupListUser;
        if (query.isNotEmpty) {
          listUser = listUser
              .where((e) => "${e.login}".toLowerCase().contains(query))
              .toList();
        }

        break;
      case TypeFilter.Issues:
        listIssue = backupListIssue;
        if (query.isNotEmpty) {
          listIssue = listIssue
              .where((e) =>
                  "${e.title}".toLowerCase().contains(query) ||
                  "${e.state}".toLowerCase().contains(query))
              .toList();
        }

        break;
      case TypeFilter.Repositories:
        listRepository = backupListRepository;
        if (query.isNotEmpty) {
          listRepository = listRepository
              .where((e) => "${e.fullName}".toLowerCase().contains(query))
              .toList();
        }
        break;
    }

    notifyListeners();
  }

  Future fetchGitData({bool isLoadMore = false}) async {
    final result = await GithubRepository.fetchDataGithub(
      filterBy: filterSelected,
      perPage: perPage,
      page: page,
      query: queryData,
    ).catchError((err) =>
        ScaffoldMessenger.of(navigatorKey.currentState!.context)
            .showSnackBar(SnackBar(
          content: Text(err),
        )));
    switch (filterSelected) {
      case TypeFilter.Users:
        if (result is UserResponse) {
          if (isLoadMore) {
            if (typeLoad == TypeLoad.Lazy) {
              listUser.addAll(result.items ?? []);
            } else {
              listUser = result.items ?? [];
            }
            backupListUser = listUser;
          } else {
            listUser = result.items ?? [];
            backupListUser.addAll(listUser);
          }
          int total = result.totalCount ~/ perPage;
          if ((result.totalCount % perPage) != 0) {
            total += 1;
          }
          totalPage = total;
          notifyListeners();
        }
        break;
      case TypeFilter.Issues:
        if (result is IssueResponse) {
          if (isLoadMore) {
            if (typeLoad == TypeLoad.Lazy) {
              listIssue.addAll(result.items ?? []);
            } else {
              listIssue = result.items ?? [];
            }
            backupListIssue = listIssue;
          } else {
            listIssue = result.items ?? [];
            backupListIssue.addAll(listIssue);
          }
          int total = result.totalCount ~/ perPage;
          if ((result.totalCount % perPage) != 0) {
            total += 1;
          }
          totalPage = total;

          notifyListeners();
        }
        break;
      case TypeFilter.Repositories:
        if (result is RepositoriesResponse) {
          if (isLoadMore) {
            if (typeLoad == TypeLoad.Lazy) {
              listRepository.addAll(result.items ?? []);
            } else {
              listRepository = result.items ?? [];
            }
            backupListRepository = listRepository;
          } else {
            listRepository = result.items ?? [];
            backupListRepository.addAll(listRepository);
          }
          int total = result.totalCount ~/ perPage;
          if ((result.totalCount % perPage) != 0) {
            total += 1;
          }
          totalPage = total;
          notifyListeners();
        }
        break;
    }
  }

  void loadMore([int value = 1]) async {
    if (typeLoad == TypeLoad.Lazy) {
      page++;
    } else {
      page = value;
    }
    isLoading = true;
    await fetchGitData(isLoadMore: true);
    isLoading = false;
  }
}
