import 'package:cleaner/services/cleaning.dart';
import 'package:cleaner/services/search.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'state.g.dart';

final cacheStateProvider = StateNotifierProvider<CacheStateNotifier, CacheState>((ref) {
  return CacheStateNotifier(
    CacheState(
      loading: false,
      cleaning: false,
      items: [],
      size: 0,
    ),
    junk: SearchService(),
    cleaning: CleaningService(),
  );
});

@CopyWith()
class CacheState {
  bool loading = false;
  bool cleaning = false;
  List<JunkFile> items = [];
  int size = 0;

  CacheState({
    required this.loading,
    required this.cleaning,
    required this.items,
    required this.size,
  });
}

class CacheStateNotifier extends StateNotifier<CacheState> {
  SearchService junk;
  CleaningService cleaning;

  CacheStateNotifier(CacheState state, {required this.junk, required this.cleaning}) : super(state);

  void search() {
    state = state.copyWith(loading: true, items: [], size: 0);

    junk.getCacheFiles().then((result) {
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
