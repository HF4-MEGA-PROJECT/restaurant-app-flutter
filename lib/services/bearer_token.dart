import 'package:hive_flutter/adapters.dart';

class BearerTokenService {
  final String bearerTokenKey = 'bearer_token';

  final Box box;

  BearerTokenService(this.box);

  String getBearerToken() {
    return box.get(bearerTokenKey, defaultValue: '');
  }

  Future<void> saveBearerToken(String bearerToken) async {
   await box.put(bearerTokenKey, bearerToken);
  }

  Future<void> deleteBearerToken() async {
    await box.delete(bearerTokenKey);
  }
}