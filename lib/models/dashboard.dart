import 'dart:convert';

List<int> dashboardFromJson(String str) =>
    List<int>.from(json.decode(str).map((x) => x));

String dashboardToJson(List<int> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x)));
