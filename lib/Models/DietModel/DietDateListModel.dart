// To parse this JSON data, do
//
//     final dietDateListModel = dietDateListModelFromJson(jsonString);

import 'dart:convert';

DietDateListModel dietDateListModelFromJson(String str) => DietDateListModel.fromJson(json.decode(str));

String dietDateListModelToJson(DietDateListModel data) => json.encode(data.toJson());

class DietDateListModel {
  DietDateListModel({
    this.sucess,
    this.dietDate,
  });

  bool? sucess;
  List<DietDate>? dietDate;

  factory DietDateListModel.fromJson(Map<String, dynamic> json) => DietDateListModel(
    sucess: json["sucess"],
    dietDate: List<DietDate>.from(json["diet_date"].map((x) => DietDate.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sucess": sucess,
    "diet_date": dietDate == null ? null : List<dynamic>.from(dietDate!.map((x) => x.toJson())),
  };
}

class DietDate {
  DietDate({
    required this.id,
    required this.userId,
    required this.date,
     this.days,
    this.totalCalories,
  });

  int id;
  int userId;
  DateTime date;
  String? days;
  dynamic totalCalories;

  factory DietDate.fromJson(Map<String, dynamic> json) => DietDate(
    id: json["id"],
    userId: json["user_id"],
    date: DateTime.parse(json["date"]),
    days: json["days"],
    totalCalories: json["total_calories"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "days": days,
    "total_calories": totalCalories,
  };
}
