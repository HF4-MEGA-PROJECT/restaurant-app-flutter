import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:restaurant_app_flutter/screens/login.dart';
import 'package:restaurant_app_flutter/screens/qr.dart';
import 'package:restaurant_app_flutter/services/auth.dart';
import 'package:restaurant_app_flutter/screens/groups.dart';

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
        '/groups': (context) => const GroupsPage(),
        '/': (context) => _isAuthenticated
            ? const GroupsPage()
            : const LoginPage(bearerToken: ''),
        '/qr': (context) => const QRPage()
      },
    );
  }
}

