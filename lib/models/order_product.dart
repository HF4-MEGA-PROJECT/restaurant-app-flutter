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

  //TODO: Fix so these are not the product id, createdAt, updatedAt, but the orderProduct (Change endpoint)
  //TODO: Remove the in_progress status
  OrderProduct.fromJson(Map<String, dynamic> json)
      : id = json['pivot']['id'] ?? 0,
        priceAtPurchase = json['pivot']['price_at_purchase'] + .0,
        status = json['pivot']['status'],
        productId = json['pivot']['product_id'],
        orderId = json['pivot']['order_id'],
        createdAt = json['pivot']['created_at'] ?? '',
        updatedAt = json['pivot']['updated_at'] ?? '',
        product = Product.fromJson(json);
}
