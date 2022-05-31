import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/user.dart';

class AuthService {
  final Dio dio;

  AuthService(this.dio);

  Future<bool> verifyToken(String bearerToken) async {
    try {
      await dio.get('/user', options: Options(
          headers: {
            'Authorization': 'Bearer ' + bearerToken
          }
        )
      );
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
    try {
      await dio.get('/user');
      return true;
    } catch (e) {
      return false;
    }
  }
}
