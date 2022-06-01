import 'product.dart';

class Order {
  int id;
  int groupId;
  String createdAt;
  String updatedAt;

  List<Product> products;

  Order(this.id, this.groupId, this.createdAt, this.updatedAt, this.products);

  Order.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        groupId = json['group_id'],
        products = (json['products'] as List).map((product) => Product.fromJson(product)).toList(),
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];
}
