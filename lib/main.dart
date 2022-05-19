import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/screens/loginscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      initialRoute: MainPage.route,
      routes: {
        '/': (context) => const MainPage(),
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class MainPage extends StatefulWidget {
  static const String route = '/';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
  void initState() {

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
