import 'package:cleaner/services/cleaning.dart';
import 'package:cleaner/services/search.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'state.g.dart';

final apksStateProvider = StateNotifierProvider<CacheStateNotifier, ApksState>((ref) {
  return CacheStateNotifier(
    ApksState(
      loading: false,
      items: [],
      size: 0,
    ),
    junk: SearchService(),
    cleaning: CleaningService(),
  );
});

@CopyWith()
class ApksState {
  bool loading = false;
  List<JunkFile> items = [];
  int size = 0;

  ApksState({
    required this.loading,
    required this.items,
    required this.size,
  });
}

class CacheStateNotifier extends StateNotifier<ApksState> {
  SearchService junk;
  CleaningService cleaning;

  CacheStateNotifier(ApksState state, {required this.junk, required this.cleaning}) : super(state);

  void search() {
    state = state.copyWith(loading: true, items: [], size: 0);

    junk.getApkFiles().then((result) {
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
