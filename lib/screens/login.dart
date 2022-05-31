import 'package:flutter/material.dart';
import 'package:restaurant_app_flutter/factories/auth_service_factory.dart';
import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/services/auth.dart';
import 'package:restaurant_app_flutter/services/bearer_token.dart';

class LoginPage extends StatefulWidget {
  final String bearerToken;

  const LoginPage({Key? key, this.bearerToken = ''}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String bearerToken = '';

  Future<void> _scanQRCode() async {
    await Navigator.of(context).pushNamed('/qr');
  }

  Future<void> _submitForm() async {
    AuthService authService = await AuthServiceFactory.make();

    if (await authService.verifyToken(bearerToken)) {
      BearerTokenService bearerTokenService = await BearerTokenFactory.make();

      await bearerTokenService.saveBearerToken(bearerToken);

      await Navigator.of(context).pushReplacementNamed('/app');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Invalid token!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void initState() {
    bearerToken = widget.bearerToken;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
          automaticallyImplyLeading: false,
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Enter the bearer token or scan the qr code'
                    ),
                    initialValue: bearerToken,
                    onChanged: (value) {
                      setState(() {
                        bearerToken = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: const Text('Log in'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50)
                    ),
                  )
                ],
              )
            )
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _scanQRCode,
          tooltip: 'Scan QR code',
          child: const Icon(Icons.camera_alt),
        )
      )
    );
  }
}
