import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/category.dart';

class CategoryService {
  final Dio dio;

  CategoryService(this.dio);

  Future<List<Category>> getAllCategoriesById(int id) async {
    try {
      var response = await dio.get('/category/' + id.toString() + '/children');
      return (response.data as List)
          .map((category) => Category.fromJson(category))
          .toList();
    } catch (e) {
      log('Failed getting categories!', error: e);
      rethrow;
    }
  }

  Future<List<Category>> getAllCategories() async {
    try {
      var response = await dio.get('/category');
      return (response.data as List)
          .map((category) => Category.fromJson(category))
          .toList();
    } catch (e) {
      log('Failed getting categories!', error: e);
      rethrow;
    }
  }
}
