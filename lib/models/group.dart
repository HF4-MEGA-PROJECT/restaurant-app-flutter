class Group {
  int id;
  int amountOfPeople;
  int number;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime deletedAt;

  Group(this.id, this.amountOfPeople, this.number, this.createdAt, this.updatedAt, this.deletedAt);

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amountOfPeople = json['name'],
        number = json['number'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'];
}
