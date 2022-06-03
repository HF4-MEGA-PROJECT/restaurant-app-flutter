import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/order.dart';

import '../models/group.dart';

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

  Future<List<Order>> getOrdersForGroup(Group group) async {
    try {
      // TODO: GET ORDERS BY GROUP ID
      var response = await dio.get('/orders');

      var list = (response.data as List).map((order) {
        return Order.fromJson(order);
      }).toList();

      for (var element in list) {log(element.id.toString());}
      return list;
    } catch (e) {
      log('Failed getting orders!', error: e);
      rethrow;
    }
  }
}
