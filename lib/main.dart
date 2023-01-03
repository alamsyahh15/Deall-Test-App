import 'package:flutter/material.dart';
import 'package:flutter_github/bloc/github_bloc.dart';
import 'package:flutter_github/home_page.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Deal Test Apps',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
        create: (context) => GithubBloc(),
        builder: (context, child) => const HomePage(),
      ),
    );
  }
}
