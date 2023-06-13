// To parse this JSON data, do
//
//     final uploadedReportListModel = uploadedReportListModelFromJson(jsonString);

import 'dart:convert';

UploadedReportListModel uploadedReportListModelFromJson(String str) => UploadedReportListModel.fromJson(json.decode(str));

String uploadedReportListModelToJson(UploadedReportListModel data) => json.encode(data.toJson());

class UploadedReportListModel {
  UploadedReportListModel({
    this.success,
    this.data,
  });

  bool? success;
  List<Datum>? data;

  factory UploadedReportListModel.fromJson(Map<String, dynamic> json) => UploadedReportListModel(
    success: json["Success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "Success": success,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.file,
    required this.date,
    required this.time,
  });

  int id;
  int userId;
  String file;
  DateTime date;
  String time;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    userId: json["user_id"],
    file: json["file"],
    date: DateTime.parse(json["date"]),
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "file": file,
    "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "time": time,
  };
}
