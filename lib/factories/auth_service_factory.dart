import 'package:restaurant_app_flutter/factories/box_factory.dart';
import 'package:restaurant_app_flutter/factories/dio_factory.dart';
import 'package:restaurant_app_flutter/services/auth.dart';

class AuthServiceFactory {
  static Future<AuthService> make({String bearerToken = ''}) async {
    return AuthService(await BoxFactory.make('myBox'), DioFactory.make(bearerToken));
  }
}