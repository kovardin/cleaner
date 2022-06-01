import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Text(title, style: theme.textTheme.headline2),
    );
  }
}
