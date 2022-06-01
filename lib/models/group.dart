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

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['amount_of_people'] = amountOfPeople;
    data['number'] = number;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}
