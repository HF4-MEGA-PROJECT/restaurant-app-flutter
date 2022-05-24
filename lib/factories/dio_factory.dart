import 'package:dio/dio.dart';

class DioFactory {
  static Dio make(String bearerToken) {
    return Dio(
      BaseOptions(
        baseUrl: 'https://restaurant-backend.binau.dev/api',
        connectTimeout: 5000,
        receiveTimeout: 5000,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + bearerToken
        },
      )
    );
  }
}