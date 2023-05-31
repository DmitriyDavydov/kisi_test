import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kisi_test/services/permission_service.dart';
import 'package:permission_handler/permission_handler.dart';

class CardScreen extends StatefulWidget {
  final int id;
  final String authToken;
  final String phoneKey;
  final String certificate;

  const CardScreen({
    Key? key,
    required this.id,
    required this.authToken,
    required this.phoneKey,
    required this.certificate,
  }) : super(key: key);

  @override
  State<CardScreen> createState() => _CardScreenState();
}

class _CardScreenState extends State<CardScreen> {
  static const platform = MethodChannel('kisi.test/kisi_channel');
  final permissionService = PermissionService();
  bool _isAccessingViaKisi = false;

  void checkPermissions() async {
    var bluetoothStatus = await permissionService.checkBluetoothPermission();
    var locationStatus = await permissionService.checkLocationPermission();

    if (Platform.isAndroid) {
      if (locationStatus.isGranted) {
        _invokeKisiMethod(
          id: widget.id,
          authToken: widget.authToken,
          phoneKey: widget.phoneKey,
          certificate: widget.certificate,
        );
      }
      if (!locationStatus.isGranted) {
        _showErrorSnackBar('Location permission should be granted.');
      }
    }

    if (Platform.isIOS) {
      if (bluetoothStatus.isGranted && locationStatus.isGranted) {
        _invokeKisiMethod();
      }
      if (!bluetoothStatus.isGranted) {
        _showErrorSnackBar('Bluetooth permission should be granted.');
      }
      if (!locationStatus.isGranted) {
        _showErrorSnackBar('Location permission should be granted.');
      }
    }
  }

  Future<void> _invokeKisiMethod({
    int? id,
    String? authToken,
    String? phoneKey,
    String? certificate,
  }) async {
    try {
      final bool result = await platform.invokeMethod(
        'kisiTapToAccess',
        {
          'id': id,
          'authToken': authToken,
          'phoneKey': phoneKey,
          'certificate': certificate,
        },
      );
      print('Native method triggered: $result');
      setState(() {
        _isAccessingViaKisi = true;
      });
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _accessViaKisi() async {
    permissionService.requestBluetoothPermission();
    permissionService.requestLocationPermission();
    checkPermissions();
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                ),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isAccessingViaKisi
                        ? "Tap your phone to unlock the door"
                        : 'Press the button below, set permissions and tap your device to unlock the door',
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32.0,
                    ),
                    child: _isAccessingViaKisi
                        ? const CircularProgressIndicator()
                        : SizedBox(
                            width: MediaQuery.of(context).size.width / 2,
                            child: ElevatedButton(
                              onPressed: _accessViaKisi,
                              child: const Text(
                                'START',
                                style: TextStyle(fontSize: 18.0),
                              ),
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
