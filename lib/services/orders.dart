import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:restaurant_app_flutter/models/orders.dart';
import 'package:restaurant_app_flutter/services/dioclient.dart';

class OrderService{
  Future<bool> getOrderData() async{
    try{
      await DioClient().dio.get<Orders>('/category');
    } catch(e){
      log("Det virker ikke");
      rethrow;
    }
  }
}

