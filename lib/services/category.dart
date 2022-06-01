import 'dart:developer';

import 'package:restaurant_app_flutter/models/category.dart';
import 'package:restaurant_app_flutter/services/dioclient.dart';

class CategoryService{

  CategoryService();

  Future<List<Category>> getAllCategoriesById(int id) async {
    try {
      var response = await DioClient().dio.get('/category/' + id.toString() + '/children');
      return (response.data as List).map((order)=> Category.fromJson(order)).toList();
    } catch (e) {
      log('Failed getting categories!', error: e);
      rethrow;
    }
  }


  Future<List<Category>> getAllCategories() async {
    try {
      var response = await DioClient().dio.get('/category');
      return (response.data as List).map((order)=> Category.fromJson(order)).toList();
    } catch (e) {
      log('Failed getting categories!', error: e);
      rethrow;
    }
  }
}

