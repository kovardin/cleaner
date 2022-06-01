import 'package:cleaner/components/adbanner/adbanner.dart';
import 'package:cleaner/components/buttons/primary.dart';
import 'package:cleaner/components/item/item.dart';
import 'package:cleaner/components/rocket/rocket.dart';
import 'package:cleaner/components/success/success.dart';
import 'package:cleaner/extensions/mbyte.dart';
import 'package:cleaner/screens/large/state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LargeSearchScreen extends ConsumerStatefulWidget {
  const LargeSearchScreen({Key? key}) : super(key: key);

  @override
  _LargeScreenState createState() => _LargeScreenState();
}

class _LargeScreenState extends ConsumerState<LargeSearchScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () {
      ref.read(largeStateProvider.notifier).search();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ref.watch(largeStateProvider).loading
        ? Rocket()
        : ref.watch(largeStateProvider).items.length == 0
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
                                    Text("Cleaning ${ref.watch(largeStateProvider).size.mb()} MB",
                                        style: theme.textTheme.headline1),
                                    Text("Removing large files", style: theme.textTheme.bodyText1)
                                  ],
                                ),
                              ),

                              // body
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ref.watch(largeStateProvider).items.length > 0
                                        ? Item(
                                            title: 'Downloaded Files',
                                            items: ref.watch(largeStateProvider).items,
                                            size: ref.watch(largeStateProvider).size,
                                          )
                                        : Container()
                                  ],
                                ),
                              ),

                              SizedBox(height: 25),
                              PrimaryButton(
                                  title: 'Clean',
                                  press: () {
                                    ref.read(largeStateProvider.notifier).clean();
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
