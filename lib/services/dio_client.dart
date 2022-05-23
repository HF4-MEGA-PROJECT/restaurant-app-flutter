import 'package:dio/dio.dart';

import 'package:restaurant_app_flutter/services/auth.dart';

class DioClient {
  static const baseURL = 'https://restaurant-backend.binau.dev/api';

  static BaseOptions baseOptions = BaseOptions(
    baseUrl: baseURL,
    connectTimeout: 5000,
    receiveTimeout: 5000,
    headers: {
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + AuthService().getBearerToken()
    },
  );

  static final DioClient _dioClient = DioClient._internal();

  final Dio _dio = Dio(baseOptions);

  Dio get dio => _dio;

  factory DioClient() {
    return _dioClient;
  }

  DioClient._internal() {
    _dio.interceptors
        .add(LogInterceptor(responseBody: true, requestBody: true));
  }
}
