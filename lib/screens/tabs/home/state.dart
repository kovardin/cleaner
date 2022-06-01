import 'package:cleaner/services/stats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:copy_with_extension/copy_with_extension.dart';

part 'state.g.dart';

final homeStateProvider = StateNotifierProvider<HomeStateNotifier, HomeState>((ref) {
  return HomeStateNotifier(
    HomeState(
      memory: 0,
      storage: 0,
    ),
    stats: StatsService(),
  );
});

@CopyWith()
class HomeState {
  double memory = 0;
  double storage = 0;

  HomeState({
    required this.memory,
    required this.storage,
  });
}

class HomeStateNotifier extends StateNotifier<HomeState> {
  StatsService stats;

  HomeStateNotifier(HomeState state, {required this.stats}) : super(state);

  void memory() {
    stats.memory().then((value) {
      state = state.copyWith(memory: value.used! / value.total! * 100);
    });
  }

  void storage() {
    stats.storage().then((value) {
      state = state.copyWith(storage: value.used! / value.total! * 100);
    });
  }
}
