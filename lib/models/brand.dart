import 'dart:convert';

List<BrandCate> brandCateFromJson(String str) =>
    List<BrandCate>.from(json.decode(str).map((x) => BrandCate.fromJson(x)));

String brandCateToJson(List<BrandCate> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BrandCate {
  BrandCate({
    required this.id,
    required this.name,
    required this.description,
  });

  String id;
  String name;
  String description;

  factory BrandCate.fromJson(Map<String, dynamic> json) => BrandCate(
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
