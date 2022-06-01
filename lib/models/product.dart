class Product {
  int id;
  String name,photoPath, createdAt, updatedAt, description;
  String? deletedAt;
  double price;
  int? categoryId;


  Product({
    required this.id,
    required this.name,
    this.categoryId,
    this.deletedAt,
    required this.photoPath,
    required this.description,
    required this.price,
    required this.createdAt,
    required this.updatedAt
  });

  Product.fromJson(Map<String, dynamic> json) :
        id = json['id'],
        name = json['name'],
        description = json['description'],
        price = json['price'],
        photoPath = json['photo_path'],
        categoryId = json['category_id'],
        deletedAt = json['deleted_at'], //Do we need him? No
        createdAt = json['created_at'],
        updatedAt = json['updated_at'];


  /*
    {
    "id": 5,
    "name": "Club Sandwich",
    "description": "Stegt kyllingebryst, sprød bacon, karrymayonnaise, tomat og salat. Serveres med pommes frites og mayonnaise.",
    "price": 139,
    "category_id": 4,
    "photo_path": "https://realfood.tesco.com/media/images/RFO-1400x919-ChickenClubSandwich-0ee77c05-5a77-49ac-a3bd-4d45e3b4dca7-0-1400x919.jpg",
    "created_at": "2022-03-26T01:27:20.000000Z",
    "updated_at": "2022-03-06T01:31:59.000000Z",
    "deleted_at": null
    }
  */
}