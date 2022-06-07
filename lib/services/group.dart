import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/group.dart';

class GroupService {
  final Dio dio;

  GroupService(this.dio);

  Future<Group> createGroup(Group group) async {
    try {
      String json = jsonEncode(group);

      var response = (await dio.post('/group', data: json));
      
      Group newGroup = Group.fromJson(response.data);

      return newGroup;
    } catch (e) {
      log('Failed creating group!', error: e);
      rethrow;
    }
  }

  Future<void> deleteGroup(Group group) async {
    try {

      await dio.delete('/group/${group.id}');

    } catch (e) {
      log('Failed deleting group!', error: e);
      rethrow;
    }
  }

  Future<void> updateGroup(Group group) async {
    try {
      String json = jsonEncode(group);

      await dio.put('/group/${group.id}', data: json);

    } catch (e) {
      log('Failed editing group!', error: e);
      rethrow;
    }
  }

  Future<List<Group>> getAllGroups() async {
    try {
      var response = await dio.get('/group');

      return (response.data as List).map((group)=> Group.fromJson(group)).toList();

    } catch (e) {
      log('Failed getting groups!', error: e);
      rethrow;
    }
  }

}
