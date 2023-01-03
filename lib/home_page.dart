import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_github/bloc/github_bloc.dart';
import 'package:flutter_github/widgets/item_github.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<GithubBloc>().fetchGitData();
  }

  @override
  Widget build(BuildContext context) {
    final watchBloc = context.watch<GithubBloc>();
    final readBloc = context.read<GithubBloc>();
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _Header(
              typeLoad: watchBloc.typeLoad,
              filterSelected: watchBloc.filterSelected,
              onSearch: readBloc.onSearch,
              onTapFilter: readBloc.onTapFilter,
              onTapTypeLoad: readBloc.onTapTypeLoad,
            ),
            Expanded(
              child: () {
                switch (watchBloc.filterSelected) {
                  case TypeFilter.Users:
                    return ListView.builder(
                        itemCount: watchBloc.listUser.length,
                        controller: watchBloc.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          final data = watchBloc.listUser[index];
                          return ItemGithub(
                            title: "${data.login}",
                            filterSelected: watchBloc.filterSelected,
                            subtitle: "",
                            trailing: null,
                            imgUrl: "${data.avatarUrl}",
                          );
                        });
                  case TypeFilter.Issues:
                    return ListView.builder(
                        itemCount: watchBloc.listIssue.length,
                        controller: watchBloc.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          final data = watchBloc.listIssue[index];
                          return ItemGithub(
                            title: "${data.title}",
                            filterSelected: watchBloc.filterSelected,
                            subtitle:
                                "${data.createdAt?.day}/${data.createdAt?.month}/${data.createdAt?.year}",
                            trailing: Text("${data.state}"),
                            imgUrl: "${data.user?.avatarUrl}",
                          );
                        });
                  case TypeFilter.Repositories:
                    return ListView.builder(
                        itemCount: watchBloc.listRepository.length,
                        controller: watchBloc.scrollController,
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        itemBuilder: (context, index) {
                          final data = watchBloc.listRepository[index];
                          return ItemGithub(
                            title: "${data.fullName}",
                            filterSelected: watchBloc.filterSelected,
                            subtitle:
                                "${data.createdAt?.day}/${data.createdAt?.month}/${data.createdAt?.year}",
                            trailing: Column(
                              children: [
                                Text("${data.watchersCount}"),
                                Text("${data.stargazersCount}"),
                                Text("${data.forksCount}"),
                              ],
                            ),
                            imgUrl: "${data.owner?.avatarUrl}",
                          );
                        });
                }
              }(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: watchBloc.typeLoad == TypeLoad.Lazy
                  ? Visibility(
                      visible: watchBloc.isLoading,
                      child: const CircularProgressIndicator(),
                    )
                  : NumberPaginator(
                      numberPages: watchBloc.totalPage,
                      initialPage: watchBloc.page - 1,
                      onPageChange: (int index) {
                        log("Index ${index + 1}");
                        readBloc.loadMore(index + 1);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final TypeFilter? filterSelected;
  final TypeLoad typeLoad;

  final Function(TypeFilter value) onTapFilter;
  final Function(TypeLoad value) onTapTypeLoad;

  final Function(String value) onSearch;
  const _Header({
    super.key,
    this.filterSelected,
    required this.typeLoad,
    required this.onTapFilter,
    required this.onTapTypeLoad,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.only(right: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade300,
          ),
          child: TextFormField(
            decoration: const InputDecoration(
              prefixIcon: Icon(CupertinoIcons.search),
              border: InputBorder.none,
            ),
            onChanged: onSearch,
          ),
        ),
        Row(
          children: [
            TypeFilter.Users,
            TypeFilter.Issues,
            TypeFilter.Repositories
          ].map((e) {
            return Expanded(
              child: InkWell(
                onTap: () => onTapFilter(e),
                child: Row(
                  children: [
                    Radio(
                      value: e,
                      groupValue: filterSelected,
                      onChanged: (val) => onTapFilter(e),
                    ),
                    Text(e.name),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [TypeLoad.Lazy, TypeLoad.Indexing].map((e) {
            return InkWell(
              onTap: () => onTapTypeLoad(e),
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: typeLoad == e ? Colors.blue : Colors.white,
                  border: Border.all(color: Colors.blue),
                ),
                child: Text(
                  () {
                    switch (e) {
                      case TypeLoad.Lazy:
                        return "Lazy Loading";
                      case TypeLoad.Indexing:
                        return "With Index";
                    }
                  }(),
                  style: TextStyle(
                    fontSize: 12,
                    color: typeLoad == e ? Colors.white : Colors.blue,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const Divider(thickness: 2),
      ],
    );
  }
}
