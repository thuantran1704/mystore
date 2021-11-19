import 'dart:convert';

Statistic statisticFromJson(String str) => Statistic.fromJson(json.decode(str));

String statisticToJson(Statistic data) => json.encode(data.toJson());

class Statistic {
  Statistic({
    required this.result,
    required this.sum,
  });

  List<Result> result;
  double sum;

  factory Statistic.fromJson(Map<String, dynamic> json) => Statistic(
        result:
            List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
        sum: json["sum"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
        "sum": sum,
      };
}

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
