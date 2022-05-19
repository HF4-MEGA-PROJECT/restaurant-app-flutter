import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  static const String route = '/login';

  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String bearerToken = '';

  void _scanQRCode() {
    /*Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const BarcodeScannerWithController(),
      ),
    );*/
  }

  void _submitForm() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
          child: Form(
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                        hintText: 'Enter the bearer token or scan the qr code'
                    ),
                  ),
                  ElevatedButton(
                      onPressed: _submitForm,
                      child: const Text('Submit')
                  )
                ],
              )
          )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scanQRCode,
        tooltip: 'Scan QR code',
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}