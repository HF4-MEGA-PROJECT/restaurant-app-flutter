import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';

class BoxFactory {
  static Future<Box> make(String boxName) async {
    const secureStorage = FlutterSecureStorage();

    final encryptionKey = await secureStorage.read(key: 'key');
    if (encryptionKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
    }

    final key = await secureStorage.read(key: 'key');

    return await Hive.openBox(boxName, encryptionCipher: HiveAesCipher(base64Url.decode(key!)));
  }
}