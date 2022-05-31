import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:restaurant_app_flutter/factories/auth_service_factory.dart';

import 'package:restaurant_app_flutter/screens/app.dart';
import 'package:restaurant_app_flutter/screens/login.dart';
import 'package:restaurant_app_flutter/screens/qr.dart';

bool _isAuthenticated = false;

Future<void> main() async {
  await Hive.initFlutter();

  _isAuthenticated = await (await AuthServiceFactory.make()).isAuthenticated();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cafe Vesuvius',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            primary: Colors.red,
            onPrimary: Colors.white,
            secondary: Colors.red,
            onSecondary: Colors.white,
            surface: Colors.red,
            onSurface: Colors.white),
      ),
      darkTheme: ThemeData(
        colorScheme: const ColorScheme.dark(
            primary: Colors.red,
            onPrimary: Colors.white,
            secondary: Colors.red,
            onSecondary: Colors.white,
            surface: Colors.red,
            onSurface: Colors.white),
      ),
      initialRoute: _isAuthenticated ? '/app' : '/login',
      routes: {
        '/login': (context) => const LoginPage(),
        '/qr': (context) => const QRPage(),
        '/app': (context) => App()
      },
    );
  }
}
