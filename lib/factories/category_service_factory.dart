import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/dio_factory.dart';
import 'package:restaurant_app_flutter/services/category.dart';

class CategoryServiceFactory {
  static Future<CategoryService> make() async {
    return CategoryService(
        DioFactory.make((await BearerTokenFactory.make()).getBearerToken()));
  }
}
