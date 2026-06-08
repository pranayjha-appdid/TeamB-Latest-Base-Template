import 'dart:convert';

List<BussinessSetting> bussinessSettingFromJson(String str) =>
    List<BussinessSetting>.from(
        json.decode(str).map((x) => BussinessSetting.fromJson(x)));

String bussinessSettingToJson(List<BussinessSetting> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BussinessSetting {
  int? id;
  String? key;
  String? value;
  DateTime? createdAt;
  DateTime? updatedAt;

  BussinessSetting({
    this.id,
    this.key,
    this.value,
    this.createdAt,
    this.updatedAt,
  });

  factory BussinessSetting.fromJson(Map<String, dynamic> json) =>
      BussinessSetting(
        id: json["id"],
        key: json["key"],
        value: json["value"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "key": key,
        "value": value,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
