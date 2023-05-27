import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kisi_test/services/permission_service.dart';

class CardScreen extends StatefulWidget {
  const CardScreen({super.key});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  static const platform = MethodChannel('samples.flutter.dev/kisi');
  final permissionService = PermissionService();

// Get battery level.
  String _batteryLevel = 'Unknown battery level.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  /*
  Future<void> requestPermissions() async {
    final permissionStatus = await Permission.location.request();
    if (permissionStatus.isDenied) {
      // Handle denied location permission
    }

    final bluetoothPermissionStatus = await Permission.bluetooth.request();
    if (bluetoothPermissionStatus.isDenied) {
      // Handle denied Bluetooth permission
    }
/*
    final nfcPermissionStatus = await Permission.request();
    if (nfcPermissionStatus.isDenied) {
      // Handle denied NFC permission
    }

 */
  }

   */

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Scan the reader to unlock to get start',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width / 2,
                child: ElevatedButton(
                  /*
                        onPressed: () async {
                          setState(() {
                            isLoading = true;
                          });
                          final response = networkService.login(
                            email: _emailController.text,
                            password: _emailController.text,
                          );
                          print('printing response');
                          print(response);
                          print(response);
                        },
                         */
                  //onPressed: _getBatteryLevel,
                  onPressed: permissionService.requestMultiplePermissions,
                  child: Text(
                    _batteryLevel,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
