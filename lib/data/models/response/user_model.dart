// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  int? id;
  String? name;
  dynamic email;
  DateTime? dob;
  String? gender;
  String? phone;
  String? status;
  dynamic profilePic;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({this.id, this.name, this.email, this.dob, this.gender, this.phone, this.status, this.profilePic, this.createdAt, this.updatedAt});

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    dob: json["dob"] == null ? null : DateTime.parse(json["dob"]),
    gender: json["gender"],
    phone: json["phone"],
    status: json["status"],
    profilePic: json["profile_pic"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "dob": "${dob!.year.toString().padLeft(4, '0')}-${dob!.month.toString().padLeft(2, '0')}-${dob!.day.toString().padLeft(2, '0')}",
    "gender": gender,
    "phone": phone,
    "status": status,
    "profile_pic": profilePic,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };

  int? get age {
    if (dob == null) return null;

    final today = DateTime.now();
    int age = today.year - dob!.year;

    if (today.month < dob!.month || (today.month == dob!.month && today.day < dob!.day)) {
      age--;
    }

    return age;
  }
}
