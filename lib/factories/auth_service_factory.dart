import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/dio_factory.dart';
import 'package:restaurant_app_flutter/services/auth.dart';

class AuthServiceFactory {
  static Future<AuthService> make() async {
    return AuthService(
      DioFactory.make(
        (await BearerTokenFactory.make()).getBearerToken()
      )
    );
  }
}