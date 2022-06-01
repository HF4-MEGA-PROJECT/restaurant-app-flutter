import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/order.dart';

class OrderService {
  final Dio dio;

  OrderService(this.dio);

  Future<List<Order>> getOrders() async {
    try {
      var response = await dio.get('/orders');

      return (response.data as List).map((order) {
        return Order.fromJson(order);
      }).toList();
    } catch (e) {
      log('Failed getting orders!', error: e);
      rethrow;
    }
  }
}
