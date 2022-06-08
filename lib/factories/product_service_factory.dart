import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/dio_factory.dart';
import 'package:restaurant_app_flutter/services/product.dart';

class ProductServiceFactory {
  static Future<ProductService> make() async {
    return ProductService(
        DioFactory.make((await BearerTokenFactory.make()).getBearerToken()));
  }
}