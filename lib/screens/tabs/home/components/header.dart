import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String title;

  Header({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Container(
      height: 175,
      width: double.infinity,
      padding: EdgeInsets.only(left: 20, right: 20, top: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
      ),
      child: Text(title, style: theme.textTheme.headline2),
    );
  }
}
