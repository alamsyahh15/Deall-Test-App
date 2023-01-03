import 'package:flutter/material.dart';
import 'package:flutter_github/bloc/github_bloc.dart';

class ItemGithub extends StatelessWidget {
  final String title, subtitle;
  final TypeFilter filterSelected;
  final Widget? trailing;
  final String imgUrl;
  const ItemGithub(
      {super.key,
      required this.title,
      required this.filterSelected,
      required this.subtitle,
      this.trailing,
      required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          height: 50,
          width: 50,
          child: Image.network(imgUrl),
        ),
      ),
      title: Text(title),
      subtitle: filterSelected == TypeFilter.Users ? null : Text(subtitle),
      trailing: trailing,
    );
  }
}
