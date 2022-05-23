class Orders {
  int id, category_id;
  String name;

  Orders(this.id, this.category_id, this.name);

  Orders.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category_id = json['category_id'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category_id': category_id,
  };
}