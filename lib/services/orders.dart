import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/orders.dart';
import 'package:restaurant_app_flutter/services/dioclient.dart';

class OrderService{

  OrderService();

  Future<List<Orders>> getAllCategoriesById(int? id) async {
    try {
      var response = await DioClient().dio.get('/category');

      return (response.data as List).map((order)=> Orders.fromJson(order)).toList();

    } catch (e) {
      log('Failed getting categories!', error: e);
      rethrow;
    }
  }
}

