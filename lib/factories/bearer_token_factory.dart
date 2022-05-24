import 'package:restaurant_app_flutter/factories/box_factory.dart';
import 'package:restaurant_app_flutter/services/bearer_token.dart';

class BearerTokenFactory {
  static Future<BearerTokenService> make() async {
    return BearerTokenService(await BoxFactory.make('myBox'));
  }
}