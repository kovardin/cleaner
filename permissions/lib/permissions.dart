import 'package:permissions/pigeons/permissions/permissions.dart';

class Permissions {
  late PermissionsChecker checker;
  Permissions() {
    checker = PermissionsChecker();
  }

  Future<bool> checkPermissionUsageSetting() async {
     final resposne = await checker.checkPermissionUsageSetting();

     return resposne.result ?? false;
  }

  Future<bool> checkPermissionStorage() async {
    final resposne = await checker.checkPermissionStorage();

    return resposne.result ?? false;
  }
}
