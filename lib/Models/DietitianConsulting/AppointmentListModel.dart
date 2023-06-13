// To parse this JSON data, do
//
//     final appointmentListModel = appointmentListModelFromJson(jsonString);

import 'dart:convert';

AppointmentListModel appointmentListModelFromJson(String str) => AppointmentListModel.fromJson(json.decode(str));

String appointmentListModelToJson(AppointmentListModel data) => json.encode(data.toJson());

class AppointmentListModel {
  AppointmentListModel({
     this.success,
    this.list,
  });

  bool? success;
  List<ListElement>? list;

  factory AppointmentListModel.fromJson(Map<String, dynamic> json) => AppointmentListModel(
    success: json["success"],
    list: List<ListElement>.from(json["list"].map((x) => ListElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "list": List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ListElement {
  ListElement({
    required this.id,
    required this.userId,
    this.staffId,
    required this.date,
    required this.startTime,
    required this.startEnd,
    required this.comment,
    required this.status,
     this.meetingLink,
    this.staffs,
    this.staffrating,
  });

  int id;
  int userId;
  int? staffId;
  String date;
  String startTime;
  String startEnd;
  String comment;
  String? meetingLink;
  int status;
  Staffs? staffs;
  Staffrating? staffrating;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
    id: json["id"],
    userId: json["user_id"],
    staffId: json["staff_id"],
    date: json["date"],
    startTime: json["start_time"],
    startEnd: json["start_end"],
    comment: json["comment"],
    meetingLink: json["meeting_link"],
    status: json["status"],
    staffs:json["staffs"] == null ? null :Staffs.fromJson(json["staffs"]),
    staffrating:json["staffrating"] == null ? null :Staffrating.fromJson(json["staffrating"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "staff_id": staffId,
    "date": date,
    "start_time": startTime,
    "start_end": startEnd,
    "comment": comment,
    "meeting_link": meetingLink,
    "status": status,
    "staffs": staffs,
  };
}

class Staffs {
  Staffs({
     this.id,
     this.name,
  });

  int? id;
  String? name;

  factory Staffs.fromJson(Map<String, dynamic> json) => Staffs(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
class Staffrating {
  Staffrating({
    this.id,
    this.rating,
  });

  int? id;
  String? rating;

  factory Staffrating.fromJson(Map<String, dynamic> json) => Staffrating(
    id: json["id"],
    rating: json["rating"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "rating": rating,
  };
}