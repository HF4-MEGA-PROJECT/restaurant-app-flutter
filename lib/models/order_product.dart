class OrderProduct {
  int id;
  double priceAtPurchase;
  String status;
  int productId;
  int orderId;
  String createdAt;
  String updatedAt;

  OrderProduct(this.id, this.priceAtPurchase, this.status, this.productId, this.orderId, this.createdAt, this.updatedAt);

  OrderProduct.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        priceAtPurchase = json['price_at_purchase'] + .0,
        status = json['status'],
        productId = json['product_id'],
        orderId = json['order_id'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];
}
