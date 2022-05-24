import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restaurant_app_flutter/factories/auth_service_factory.dart';
import 'package:restaurant_app_flutter/screens/login.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
        ),
        body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Column(children: [
                ElevatedButton(
                  onPressed: () async {
                    await (await AuthServiceFactory.make()).deleteBearerToken();
                    pushNewScreen(context,
                        screen: const LoginPage(), withNavBar: false);
                  },
                  child: const Text('Log out'),
                )
              ]),
            )));
  }
}
