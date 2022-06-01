class Category {
  int id;
  String name;
  int? categoryId;
  String createdAt;
  String updatedAt;

  Category({required this.id, required this.name, this.categoryId, required this.createdAt, required this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) :
    id = json['id'],
    name = json['name'],
    categoryId = json['category_id'],
    createdAt = json['created_at'],
    updatedAt = json['updated_at'];
}


