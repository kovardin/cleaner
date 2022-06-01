import 'package:pigeon/pigeon.dart';


class CleaningRequest {
  List<String?>? files;
}

class CleaningResponse {
  bool? status;
}

@HostApi()
abstract class JunkCleaning {
  @async
  CleaningResponse clean(CleaningRequest request);
}
