import 'dart:developer';

import 'package:restaurant_app_flutter/models/product.dart';
import 'package:restaurant_app_flutter/services/dioclient.dart';

class ProductService{

 ProductService();

  Future<List<Product>> getAllProducts() async {
    try {
      var response = await DioClient().dio.get('/product');
      return (response.data as List).map((product)=> Product.fromJson(product)).toList();
    } catch (e) {
      log('Failed getting product categories!', error: e);
      rethrow;
    }
  }
}

