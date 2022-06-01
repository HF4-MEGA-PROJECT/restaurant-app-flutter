import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:restaurant_app_flutter/screens/login.dart';

class QRPage extends StatefulWidget {
  const QRPage({Key? key}) : super(key: key);

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        allowDuplicates: false,
        onDetect: (barcode, args) async {
          if (barcode.rawValue == null) {
            debugPrint('Failed to scan Barcode');
          } else {
            HapticFeedback.vibrate();

            Navigator.of(context).pop();

            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginPage(bearerToken: barcode.rawValue!),
              ),
            );
          }
        },
      ),
    );
  }
}
