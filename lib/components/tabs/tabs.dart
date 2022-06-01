import 'package:cleaner/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SimpleItem {
  SimpleItem({this.icon, this.title});

  String? icon;
  String? title;
}

class SimpleTabs extends StatefulWidget {
  SimpleTabs({
    required this.controller,
    required this.items,
    this.centerItemText,
    this.height: 48.0,
    this.iconSize: 24.0,
    this.backgroundColor,
    this.color,
    this.selectedColor: Colors.tealAccent,
    this.notchedShape,
    this.onTabSelected,
  });

  final TabController controller;
  final List<SimpleItem> items;
  final String? centerItemText;
  final double? height;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? color;
  final Color? selectedColor;
  final NotchedShape? notchedShape;
  final ValueChanged<int>? onTabSelected;

  @override
  State<StatefulWidget> createState() => SimpleTabsState();
}

class SimpleTabsState extends State<SimpleTabs> {
  updateIndex(int index) {
    widget.controller.animateTo(index);
    if (widget.onTabSelected != null) {
      widget.onTabSelected!(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> items = List.generate(widget.items.length, (int index) {
      return buildTabItem(
        item: widget.items[index],
        index: index,
        onPressed: updateIndex,
      );
    });

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 15,
            blurRadius: 20,
            offset: Offset(0, 15),
          ), //BoxShadow
        ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: items,
      ),
    );
  }

  Widget buildTabItem({
    required SimpleItem item,
    required int index,
    required ValueChanged<int> onPressed,
  }) {

    return Container(
      height: 24,
      width: 24,
      child: GestureDetector(
        onTap: () => onPressed(index),
        child: SvgPicture.asset(item.icon ?? '', color: widget.controller.index == index ? PrimaryColor : null),
      ),
    );
  }
}
