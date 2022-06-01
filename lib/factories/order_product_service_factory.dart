import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/dio_factory.dart';
import 'package:restaurant_app_flutter/services/order_product.dart';

class OrderProductServiceFactory {
  static Future<OrderProductService> make() async {
    return OrderProductService(
      DioFactory.make(
        (await BearerTokenFactory.make()).getBearerToken()
      )
    );
  }
}