import 'package:pigeon/pigeon.dart';

class StatsResponse {
  int? used;
  int? total;
}

@HostApi()
abstract class JunkStats {
  @async
  StatsResponse storage();

  @async
  StatsResponse memory();
}
