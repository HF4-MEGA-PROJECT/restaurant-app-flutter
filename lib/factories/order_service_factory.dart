import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/dio_factory.dart';
import 'package:restaurant_app_flutter/services/order.dart';

class OrderServiceFactory {
  static Future<OrderService> make() async {
    return OrderService(
      DioFactory.make(
        (await BearerTokenFactory.make()).getBearerToken()
      )
    );
  }
}