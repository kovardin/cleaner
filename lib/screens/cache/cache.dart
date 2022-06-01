import 'package:cleaner/components/adbanner/adbanner.dart';
import 'package:cleaner/components/buttons/primary.dart';
import 'package:cleaner/components/item/item.dart';
import 'package:cleaner/components/rocket/rocket.dart';
import 'package:cleaner/components/success/success.dart';
import 'package:cleaner/extensions/mbyte.dart';
import 'package:cleaner/screens/cache/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CacheScreen extends ConsumerStatefulWidget {
  const CacheScreen({Key? key}) : super(key: key);

  @override
  _CacheScreenState createState() => _CacheScreenState();
}

class _CacheScreenState extends ConsumerState<CacheScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref.read(cacheStateProvider.notifier).search();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ref.watch(cacheStateProvider).loading
        ? Rocket()
        : ref.watch(cacheStateProvider).items.length == 0
            ? Success()
            : Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  leading: GestureDetector(
                    child: Icon(Icons.arrow_back_ios, color: Colors.black),
                    onTap: () {
                      Navigator.popUntil(context, ModalRoute.withName('/'));
                    },
                  ),
                ),
                body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title
                              Container(
                                height: 160,
                                padding: EdgeInsets.only(left: 30, right: 30, top: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Cleaning ${ref.read(cacheStateProvider).size.mb()} MB",
                                        style: theme.textTheme.headline1),
                                    Text("Removing caches and all bad files", style: theme.textTheme.bodyText1)
                                  ],
                                ),
                              ),

                              // body
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ref.watch(cacheStateProvider).items.length > 0
                                        ? Item(
                                            title: 'System Caches',
                                            items: ref.watch(cacheStateProvider).items,
                                            size: ref.watch(cacheStateProvider).size,
                                          )
                                        : Container()
                                  ],
                                ),
                              ),

                              SizedBox(height: 25),
                              PrimaryButton(
                                  title: 'Clean',
                                  press: () {
                                    ref.read(cacheStateProvider.notifier).clean();
                                  }),
                              SizedBox(height: 25),
                            ],
                          ),
                        ),
                      ),

                      // banner
                      const AdBanner(),
                    ],
                  ),
                ),
              );
  }
}
