import 'package:pigeon/pigeon.dart';

class PermissionsResponse {
  bool? result;
}

@HostApi()
abstract class PermissionsChecker {
  @async
  PermissionsResponse checkPermissionUsageSetting();

  @async
  PermissionsResponse checkPermissionStorage();
}
