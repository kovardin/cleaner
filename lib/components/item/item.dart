import 'dart:convert';

import 'package:cleaner/services/search.dart';
import 'package:flutter/material.dart';
import 'package:cleaner/extensions/mbyte.dart';

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.items,
    required this.size,
    required this.title,
  }) : super(key: key);

  final List<JunkFile> items;
  final int size;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.headline4),
        const SizedBox(height: 8),
        Text('Total size: ${size.mb()}'),
        const SizedBox(height: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final item in items)
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    drawable(item),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text('${item.package ?? ''}',
                            style: theme.textTheme.bodyText2, overflow: TextOverflow.ellipsis)),
                    const SizedBox(width: 12),
                    Text('${item.size?.mb()} MB'),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget drawable(JunkFile file) {

    if (file.icon != null && file.icon != "") {
      return Image.memory(base64Decode(file.icon!), width: 32);
    }

    return Container();
  }
}
