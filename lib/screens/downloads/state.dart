import 'dart:io';

import 'package:cleaner/services/cleaning.dart';
import 'package:cleaner/services/search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'state.g.dart';

final downloadsStateProvider = StateNotifierProvider<DownloadsStateNotifier, DownloadsState>((ref) {
  return DownloadsStateNotifier(
    DownloadsState(
      loading: false,
      items: [],
      size: 0,
    ),
    junk: SearchService(),
    cleaning: CleaningService(),
  );
});

@CopyWith()
class DownloadsState {
  bool loading = false;
  List<JunkFile> items = [];
  int size = 0;

  DownloadsState({
    required this.loading,
    required this.items,
    required this.size,
  });
}

class DownloadsStateNotifier extends StateNotifier<DownloadsState> {
  SearchService junk;
  CleaningService cleaning;

  DownloadsStateNotifier(DownloadsState state, {required this.junk, required this.cleaning}) : super(state);

  void search() {
    state = state.copyWith(loading: true, items: [], size: 0);

    junk.getDownloadFiles().then((result) {
      state = state.copyWith(loading: false, items: result.items, size: result.size);
    });

  }

  void clean() {
    state = state.copyWith(loading: true);

    List<CleaningFile> files = state.items.map((e) {
      return CleaningFile(
        application: e.application,
        package: e.package,
        path: e.path,
        type: e.type,
      );
    }).toList();

    cleaning.clean(files).then((value) {
      Future.delayed(Duration(seconds: 3), () {
        state = state.copyWith(loading: false, items: []);
      });
    });
  }
}
