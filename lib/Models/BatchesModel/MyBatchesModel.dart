// To parse this JSON data, do
//
//     final myBatchesListModel = myBatchesListModelFromJson(jsonString);

import 'dart:convert';

MyBatchesListModel myBatchesListModelFromJson(String str) => MyBatchesListModel.fromJson(json.decode(str));

String myBatchesListModelToJson(MyBatchesListModel data) => json.encode(data.toJson());

class MyBatchesListModel {
  MyBatchesListModel({
    this.success,
    this.batch,
  });

  bool? success;
  List<BatchElement>? batch;

  factory MyBatchesListModel.fromJson(Map<String, dynamic> json) => MyBatchesListModel(
    success: json["success"],
    batch: List<BatchElement>.from(json["batch"].map((x) => BatchElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "batch": batch == null ? null :List<dynamic>.from(batch!.map((x) => x.toJson())),
  };
}

class BatchElement {
  BatchElement({
    this.id,
    this.batchId,
    this.userId,
    this.batch,
  });

  int? id;
  int? batchId;
  int? userId;
  BatchBatch? batch;

  factory BatchElement.fromJson(Map<String, dynamic> json) => BatchElement(
    id: json["id"],
    batchId: json["batch_id"],
    userId: json["user_id"],
    batch: BatchBatch.fromJson(json["batch"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "batch_id": batchId,
    "user_id": userId,
    "batch": batch == null ? null : batch!.toJson(),
  };
}

class BatchBatch {
  BatchBatch({
    this.id,
    this.name,
    this.image,
    this.startTime,
    this.endTime,
    this.dates,
  });

  int? id;
  String? name;
  String? image;
  String? startTime;
  String? endTime;
  String? dates;

  factory BatchBatch.fromJson(Map<String, dynamic> json) => BatchBatch(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    dates: json["dates"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "start_time": startTime,
    "end_time": endTime,
    "dates": dates,
  };
}


