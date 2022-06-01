class Product {
  int id;
  String name;
  String description;
  double price;
  int? categoryId;
  String? photoPath;
  String createdAt;
  String updatedAt;
  String? deletedAt;

  Product(this.id, this.name, this.description, this.price, this.categoryId,
      this.photoPath, this.createdAt, this.updatedAt, this.deletedAt);

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        price = json['price'] + .0,
        categoryId = json['category_id'],
        photoPath = json['photo_path'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'];
}
