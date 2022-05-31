import 'package:restaurant_app_flutter/factories/bearer_token_factory.dart';
import 'package:restaurant_app_flutter/factories/dio_factory.dart';
import 'package:restaurant_app_flutter/services/group.dart';

class GroupServiceFactory {
  static Future<GroupService> make() async {
    return GroupService(
      DioFactory.make(
        (await BearerTokenFactory.make()).getBearerToken()
      )
    );
  }
}