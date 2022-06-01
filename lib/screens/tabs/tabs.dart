import 'package:cleaner/components/tabs/tabs.dart';
import 'package:cleaner/screens/tabs/home/home.dart';
import 'package:cleaner/screens/tabs/information/information.dart';
import 'package:flutter/material.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({Key? key}) : super(key: key);

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> with TickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(initialIndex: 0, length: 2, vsync: this);
    controller.addListener(handleTabSelection);
  }

  void handleTabSelection() {
    setState(() {}); // fix for tabs update
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: TabBarView(
          controller: controller,
          children: [
            HomeScreen(),
            InformationScreen(),
          ],
        ),
        bottomNavigationBar: SimpleTabs(
          controller: controller,
          items: [
            SimpleItem(icon: 'assets/icons/iconly/Home.svg'),
            SimpleItem(icon: 'assets/icons/iconly/Setting.svg'),
          ],
        ),
      ),
    );
  }
}
