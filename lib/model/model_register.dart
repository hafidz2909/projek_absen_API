// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

ModelRegister welcomeFromJson(String str) =>
    ModelRegister.fromJson(json.decode(str));

String welcomeToJson(ModelRegister data) => json.encode(data.toJson());

class ModelRegister {
  final String? message;
  final Data? data;

  ModelRegister({this.message, this.data});

  factory ModelRegister.fromJson(Map<String, dynamic> json) => ModelRegister(
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class Data {
  final String? token;
  final User? user;

  Data({this.token, this.user});

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    token: json["token"],
    user: json["user"] == null ? null : User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {"token": token, "user": user?.toJson()};
}

class User {
  final String? name;
  final String? email;
  final DateTime? updatedAt;
  final DateTime? createdAt;
  final int? id;

  User({this.name, this.email, this.updatedAt, this.createdAt, this.id});

  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json["name"],
    email: json["email"],
    updatedAt:
        json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    createdAt:
        json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
