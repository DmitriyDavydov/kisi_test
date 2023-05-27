import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  void requestMultiplePermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.bluetooth,
    ].request();
    print("location permission: ${statuses[Permission.location]}, "
        "bluetooth permission: ${statuses[Permission.bluetooth]}");
  }
}
