import 'package:cleaner/pigeons/junk/stats.dart';

class StatsService {
  final stats = JunkStats();

  Future<StatsResponse> memory() async {
    return stats.memory();
  }

  Future<StatsResponse> storage() async {
    return stats.storage();
  }
}
