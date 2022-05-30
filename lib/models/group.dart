class Group {
  int? id;
  int? amountOfPeople;
  int? number;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Group(this.id, this.amountOfPeople, this.number, this.createdAt, this.updatedAt, this.deletedAt);

  Group.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amountOfPeople = json['amount_of_people'],
        number = json['number'],
        createdAt = json['created_at'],
        updatedAt = json['updated_at'],
        deletedAt = json['deleted_at'];
}
