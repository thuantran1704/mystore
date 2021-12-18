class Result {
  Result({
    required this.name,
    required this.sold,
  });

  String name;
  int sold;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        sold: json["sold"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "sold": sold,
      };
}
