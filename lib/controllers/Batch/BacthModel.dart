// To parse this JSON data, do
//
//     final batchListModel = batchListModelFromJson(jsonString);

import 'dart:convert';

BatchListModel batchListModelFromJson(String str) => BatchListModel.fromJson(json.decode(str));

String batchListModelToJson(BatchListModel data) => json.encode(data.toJson());

class BatchListModel {
  BatchListModel({
    required this.success,
    required this.data,
  });

  bool success;
  List<Batches> data;

  factory BatchListModel.fromJson(Map<String, dynamic> json) => BatchListModel(
    success: json["success"],
    data: List<Batches>.from(json["data"].map((x) => Batches.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Batches {
  Batches({
    required this.id,
    required this.name,
    this.image,
    required this.startTime,
    required this.endTime,
  });

  int id;
  String name;
  String? image;
  String startTime;
  String endTime;

  factory Batches.fromJson(Map<String, dynamic> json) => Batches(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "start_time": startTime,
    "end_time": endTime,
  };
}
