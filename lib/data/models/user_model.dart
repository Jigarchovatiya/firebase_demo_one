import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? name;
  String? email;
  String? number;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.number,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        number: json["number"],
      );

  Map<String, dynamic> toJson() => {
        "id": "id",
        "name": "name",
        "email": "email",
        "number": "number",
      };
}
