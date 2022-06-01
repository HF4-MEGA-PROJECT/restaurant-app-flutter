import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/product.dart';

class ProductService {
  final Dio dio;

  ProductService(this.dio);

  Future<List<Product>> getAllProducts() async {
    try {
      var response = await dio.get('/product');
      return (response.data as List)
          .map((product) => Product.fromJson(product))
          .toList();
    } catch (e) {
      log('Failed getting products!', error: e);
      rethrow;
    }
  }
}
