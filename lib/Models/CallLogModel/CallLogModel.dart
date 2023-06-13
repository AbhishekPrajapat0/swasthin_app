// To parse this JSON data, do
//
//     final callLogModel = callLogModelFromJson(jsonString);

import 'dart:convert';

CallLogModel callLogModelFromJson(String str) => CallLogModel.fromJson(json.decode(str));

String callLogModelToJson(CallLogModel data) => json.encode(data.toJson());

class CallLogModel {
  CallLogModel({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  List<Datum>? data;

  factory CallLogModel.fromJson(Map<String, dynamic> json) => CallLogModel(
    success: json["success"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    required this.userId,
    this.staffId,
    this.appointmentId,
    this.status,
    this.date,
    this.time,
    this.staff,
    this.user,
  });

  int userId;
  int? staffId;
  String? appointmentId;
  String? status;
  String? date;
  String? time;
  Staff? staff;
  User? user;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["user_id"],
    staffId: json["staff_id"],
    appointmentId: json["appointment_id"],
    status: json["status"],
    date: json["date"],
    time: json["time"],
    staff: Staff.fromJson(json["staff"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "staff_id": staffId,
    "appointment_id": appointmentId,
    "status": status,
    "date": date,
    "time": time,
    "staff": staff == null ? null :staff!.toJson(),
    "user": user == null ? null :user!.toJson(),
  };
}

class Staff {
  Staff({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  int id;
  String name;
  String email;
  String mobile;

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
  };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
  });

  int id;
  String name;
  String email;
  int mobile;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
  };
}
