// To parse this JSON data, do
//
//     final allergiesModel = allergiesModelFromJson(jsonString);

import 'dart:convert';

AllergiesModel allergiesModelFromJson(String str) => AllergiesModel.fromJson(json.decode(str));

String allergiesModelToJson(AllergiesModel data) => json.encode(data.toJson());

class AllergiesModel {
  AllergiesModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<Datum> data;

  factory AllergiesModel.fromJson(Map<String, dynamic> json) => AllergiesModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
