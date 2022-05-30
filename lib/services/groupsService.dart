import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/services/dioclient.dart';
import 'package:restaurant_app_flutter/models/group.dart';

class GroupsService{

  GroupsService();

  Future<void> createGroup() async {
    try {
      await DioClient().dio.post('/');

    } catch (e) {
      log('Failed creating group!', error: e);
      rethrow;
    }
  }

  Future<List<Group>> getAllGroups() async {
    try {
      var response = await DioClient().dio.get('/group');

      return (response.data as List).map((group)=> Group.fromJson(group)).toList();

    } catch (e) {
      log('Failed getting groups!', error: e);
      rethrow;
    }
  }

}
