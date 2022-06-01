import 'package:cleaner/components/adbanner/adbanner.dart';
import 'package:cleaner/constants.dart';
import 'package:cleaner/screens/apks/apks.dart';
import 'package:cleaner/screens/cache/cache.dart';
import 'package:cleaner/screens/downloads/downloads.dart';
import 'package:cleaner/screens/large/large.dart';
import 'package:cleaner/screens/tabs/home/components/feature.dart';
import 'package:cleaner/screens/tabs/home/components/header.dart';
import 'package:cleaner/screens/tabs/home/components/statistics.dart';
import 'package:cleaner/screens/tabs/home/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permissions/permissions.dart';

class HomeScreen extends ConsumerStatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final Permissions permissions = Permissions();

  @override
  void initState() {
    super.initState();

    ref.read(homeStateProvider.notifier).memory();
    ref.read(homeStateProvider.notifier).storage();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: BackgroundColor,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // title
              Stack(
                children: [
                  Header(title: 'Device status'),
                  Statistics(),
                ],
              ),

              // functions
              SizedBox(height: 25),
              Container(
                height: 285,
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Feature(
                          icon: 'assets/icons/iconly/Delete.svg',
                          title: 'Applications\nCache',
                          color: Color(0xFFD6A1FF),
                          press: () {
                            check(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CacheScreen()));
                            });
                          },
                        ),
                        Feature(
                          icon: 'assets/icons/iconly/Arrow - Down Square.svg',
                          title: 'Downloaded\nFiles',
                          color: Color(0xFF68DBBA),
                          press: () {
                            check(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => DownloadsScreen()));
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Feature(
                          icon: 'assets/icons/iconly/Category.svg',
                          title: 'Old\nApks',
                          color: Color(0xFFFFC979),
                          press: () {
                            check(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ApksScreen()));
                            });
                          },
                        ),
                        Feature(
                          icon: 'assets/icons/iconly/Close Square.svg',
                          title: 'Large\nFiles',
                          color: Color(0xFF94CBFF),
                          press: () {
                            check(() {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => LargeSearchScreen()));
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // banner
              const AdBanner(height: 100, color: BackgroundColor),
            ],
          ),
        ),
      ),
    );
  }

  check(Function callback) {
    permissions.checkPermissionUsageSetting().then((success) {
      if (!success) {
        return;
      }

      permissions.checkPermissionStorage().then((success) {
        if (!success) {
          return;
        }

        callback();
      });
    });
  }
}
