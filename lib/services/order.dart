import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/group.dart';
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

  Future<List<Order>> getGroupOrders(Group group) async {
    try {
      var response = await dio.get('/group/' + group.id.toString() + '/orders');

      return (response.data as List).map((order) {
        return Order.fromJson(order);
      }).toList();
    } catch (e) {
      log('Failed getting group orders!', error: e);
      rethrow;
    }
  }

  Future<int> createOrder(int groupId) async {
    try {
      var response = await dio.post('/order/' , data: {'group_id':groupId});
      return response.data["id"];
    } catch (e) {
      log('Failed creating the order!', error: e);
      rethrow;
    }
  }
}
