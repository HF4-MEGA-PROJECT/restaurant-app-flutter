import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:restaurant_app_flutter/factories/auth_service_factory.dart';
import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/models/user.dart';
import 'package:restaurant_app_flutter/screens/login.dart';
import 'package:restaurant_app_flutter/services/auth.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? user;

  Future<User> getUser() async {
    AuthService authService = (await AuthServiceFactory.make());
    return await authService.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: getUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          user = snapshot.data;

          return SafeArea(
              child: Scaffold(
            body: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Row(children: [
                        Expanded(
                            child: FittedBox(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(user!.profilePhoto,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                      return const Icon(
                                          Icons.account_box_rounded);
                                    })))),
                        Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(user!.name, maxLines: 1)),
                                    FittedBox(
                                        fit: BoxFit.fitWidth,
                                        child: Text(user!.email, maxLines: 1))
                                  ])),
                        ),
                      ]),
                      SizedBox.fromSize(size: const Size.fromHeight(8)),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () async {
                          await (await BearerTokenFactory.make())
                              .deleteBearerToken();
                          await pushNewScreen(context,
                              screen: const LoginPage(), withNavBar: false);
                        },
                        child: const Text('Log out'),
                      )
                    ]))),
          ));
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
