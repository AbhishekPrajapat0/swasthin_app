// To parse this JSON data, do
//
//     final myClassDetailModel = myClassDetailModelFromJson(jsonString);

import 'dart:convert';

MyClassDetailModel myClassDetailModelFromJson(String str) => MyClassDetailModel.fromJson(json.decode(str));

String myClassDetailModelToJson(MyClassDetailModel data) => json.encode(data.toJson());

class MyClassDetailModel {
  MyClassDetailModel({
     this.success,
     this.batch,
  });

  bool? success;
  Batch? batch;

  factory MyClassDetailModel.fromJson(Map<String, dynamic> json) => MyClassDetailModel(
    success: json["success"],
    batch: Batch.fromJson(json["batch"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "batch": batch!.toJson(),
  };
}

class Batch {
  Batch({
    required this.id,
    required this.name,
    required this.image,
    required this.status,
     this.link,
    required this.startTime,
    required this.endTime,
  });

  int id;
  String name;
  String image;
  String status;
  String? link;
  String startTime;
  String endTime;

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    status: json["status"],
    link: json["link"] == null ? null :json["link"],
    startTime: json["start_time"],
    endTime: json["end_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "status": status,
    "link": link,
    "start_time": startTime,
    "end_time": endTime,
  };
}
