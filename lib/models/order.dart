import 'package:restaurant_app_flutter/models/order_product.dart';
import 'package:restaurant_app_flutter/models/product.dart';

class Order {
  int id;
  int groupId;
  String createdAt;
  String updatedAt;

  List<OrderProduct> orderProducts;

  Order(this.id, this.groupId, this.createdAt, this.updatedAt, this.orderProducts);

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        groupId = json['group_id'],
        orderProducts = (json['products'] as List).map((orderProduct) => OrderProduct.fromJson(orderProduct)).toList(),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];

  List<Product> getProducts() {
    List<Product> products = [];
    for (OrderProduct orderProduct in orderProducts) {
      products.add(orderProduct.product);
    }
    return products;
  }

  String getHourMinutes() {
    DateTime dt = DateTime.parse(createdAt);

    return dt.hour.toString() + ':' + dt.minute.toString();
  }

  double totalPrice() {
    double totalPrice = 0;

    for (var orderProduct in orderProducts) {
      totalPrice += orderProduct.priceAtPurchase;
    }

    return totalPrice;
  }
}
