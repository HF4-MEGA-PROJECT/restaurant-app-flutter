import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:restaurant_app_flutter/screens/login.dart';
import 'package:restaurant_app_flutter/screens/qr.dart';
import 'package:restaurant_app_flutter/services/auth.dart';

bool _isAuthenticated = false;

Future<void> main() async {
  await Hive.initFlutter();

  var box = await Hive.openBox('myBox');

  if (box.containsKey(AuthService.bearerTokenKey)) {
    _isAuthenticated =
        await AuthService(box.get(AuthService.bearerTokenKey)).verifyToken();
  }

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
      initialRoute: '/',
      routes: {
        '/': (context) => _isAuthenticated
            ? const MainPage()
            : const LoginPage(bearerToken: ''),
        '/qr': (context) => const QRPage()
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text('Loading...',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ]),
    )));
  }
}
