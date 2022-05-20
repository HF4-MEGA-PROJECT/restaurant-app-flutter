import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';

import 'package:restaurant_app_flutter/services/dioclient.dart';

class AuthService {
  static String bearerTokenKey = 'bearer_token';

  Future<bool> verifyToken(bearerToken) async {
    try {
      await DioClient().dio.get('/user',
          options:
              Options(headers: {'Authorization': 'Bearer ' + bearerToken}));
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<bool> isAuthenticated() async {
    var box = await Hive.openBox('myBox');

    if (box.containsKey(AuthService.bearerTokenKey)) {
      return await verifyToken(box.get(AuthService.bearerTokenKey));
    }

    return false;
  }

  String getBearerToken() {
    return Hive.box('myBox').get(bearerTokenKey, defaultValue: '');
  }

  void saveBearerToken(String bearerToken) {
    Hive.box('myBox').put(bearerTokenKey, bearerToken);
  }
}
