import 'package:cleaner/services/cleaning.dart';
import 'package:cleaner/services/search.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'state.g.dart';

final largeStateProvider = StateNotifierProvider<LargeStateNotifier, LargeState>((ref) {
  return LargeStateNotifier(
    LargeState(
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
class LargeState {
  bool loading = false;
  bool cleaning = false;
  List<JunkFile> items = [];
  int size = 0;

  LargeState({
    required this.loading,
    required this.cleaning,
    required this.items,
    required this.size,
  });
}

class LargeStateNotifier extends StateNotifier<LargeState> {
  SearchService junk;
  CleaningService cleaning;

  LargeStateNotifier(LargeState state, {required this.junk, required this.cleaning}) : super(state);

  void search() {
    state = state.copyWith(loading: true, items: [], size: 0);

    junk.getLargeFiles().then((result) {
      state = state.copyWith(loading: false, items: result.items, size: result.size);
    });
  }

  void clean() {
    state = state.copyWith(cleaning: true);

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
        state = state.copyWith(cleaning: false, items: []);
      });
    });
  }
}
