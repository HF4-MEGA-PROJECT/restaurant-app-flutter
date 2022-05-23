class User {
  int id;
  String name;
  String email;
  String profilePhoto;

  User(this.id, this.name, this.email, this.profilePhoto);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        email = json['email'],
        profilePhoto = json['profile_photo_url'];
}
