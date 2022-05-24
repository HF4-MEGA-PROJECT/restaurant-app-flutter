import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:restaurant_app_flutter/models/user.dart';

class AuthService {
  final String bearerTokenKey = 'bearer_token';

  final Box box;
  final Dio dio;

  AuthService(this.box, this.dio);

  Future<bool> verifyToken() async {
    try {
      await dio.get('/user');
    } catch (e) {
      return false;
    }

    return true;
  }

  Future<User> getUser() async {
    try {
      var response = await dio.get<Map<String, dynamic>>('/user');

      return User.fromJson(response.data!);
    } catch (e) {
      log('Failed getting user!', error: e);
      rethrow;
    }
  }

  Future<bool> isAuthenticated() async {
    if (box.containsKey(bearerTokenKey)) {
      try {
        await dio.get('/user', options: Options(
            headers: {
              'Authorization': 'Bearer ' + getBearerToken()
            }
          )
        );
        return true;
      } catch (e) {
        return false;
      }
    }

    return false;
  }

  String getBearerToken() {
    return box.get(bearerTokenKey, defaultValue: '');
  }

  Future<void> saveBearerToken(String bearerToken) async {
   await box.put(bearerTokenKey, bearerToken);
  }

  Future<void> deleteBearerToken() async {
    await box.delete(bearerTokenKey);
  }
}
