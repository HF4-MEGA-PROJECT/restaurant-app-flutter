import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/order_product.dart';

class OrderProductService {
  final Dio dio;

  OrderProductService(this.dio);

  Future<List<OrderProduct>> getOrderProducts() async {
    try {
      var response = await dio.get('/order_product');

      return (response.data as List).map((orderProduct) => OrderProduct.fromJson(orderProduct)).toList();
    } catch (e) {
      log('Failed getting order products!', error: e);
      rethrow;
    }
  }

  Future<void> updateOrderProduct(OrderProduct orderProduct) async {
    try {
      String json = jsonEncode(orderProduct);

      await dio.put('/order_product/${orderProduct.id}', data: json);
    } catch (e) {
      log('Failed editing order product!', error: e);
      rethrow;
    }
  }
}
