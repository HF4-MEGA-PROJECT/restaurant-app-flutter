import 'package:restaurant_app_flutter/models/product.dart';

class OrderProduct {
  int id;
  double priceAtPurchase;
  String status;
  int productId;
  int orderId;
  String createdAt;
  String updatedAt;
  Product product;

  OrderProduct(
      this.id, this.priceAtPurchase, this.status, this.productId, this.orderId, this.createdAt, this.updatedAt, this.product);

  OrderProduct.fromJson(Map<String, dynamic> json)
      : id = json['pivot']['id'],
        priceAtPurchase = json['pivot']['price_at_purchase'] + .0,
        status = json['pivot']['status'],
        productId = json['pivot']['product_id'],
        orderId = json['pivot']['order_id'],
        createdAt = json['pivot']['created_at'],
        updatedAt = json['pivot']['updated_at'],
        product = Product.fromJson(json);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['price_at_purchase'] = priceAtPurchase;
    data['status'] = status;
    data['product_id'] = productId;
    data['order_id'] = orderId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;

    return data;
  }
}
