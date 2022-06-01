import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class Link extends StatelessWidget {
  const Link({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final String icon;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: press,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            SizedBox(width: 12),
            Text(title, style: theme.textTheme.bodyText2),
            Spacer(),
            SvgPicture.asset('assets/icons/iconly/${icon}.svg'),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

}
