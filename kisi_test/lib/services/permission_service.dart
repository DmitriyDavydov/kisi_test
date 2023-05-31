import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  void requestBluetoothPermission() async {
    var status = await Permission.bluetooth.status;
    await Permission.bluetooth.request();
    print("bluetooth permission: $status");
  }

  void requestLocationPermission() async {
    var status = await Permission.location.status;
    await Permission.location.request();
    print("location permission: $status");
  }

  Future<PermissionStatus> checkBluetoothPermission() async {
    var status = await Permission.bluetooth.status;
    print("bluetooth permission: $status");
    return status;
  }

  Future<PermissionStatus> checkLocationPermission() async {
    var status = await Permission.location.status;
    print("location permission: $status");
    return status;
  }
}
