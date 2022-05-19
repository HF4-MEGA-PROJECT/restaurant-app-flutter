import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/services/dioclient.dart';

class AuthService {
  final String bearerToken;
  static String bearerTokenKey = 'bearer_token';

  AuthService(this.bearerToken);

  Future<bool> verifyToken() async {
    try {
      await DioClient().dio.get('/user',
          options:
              Options(headers: {'Authorization': 'Bearer ' + bearerToken}));
    } catch (e) {
      return false;
    }

    return true;
  }
}
