import 'dart:convert';

List<Brand> brandFromJson(String str) => List<Brand>.from(json.decode(str).map((x) => Brand.fromJson(x)));

String brandToJson(List<Brand> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Brand {
  Brand({
    required this.id,
    required this.name,
    required this.description,
  });

  String id;
  String name;
  String description;

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(
    id: json["_id"],
    name: json["name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "description": description,
  };
}
