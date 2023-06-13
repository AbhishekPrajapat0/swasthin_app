// To parse this JSON data, do
//
//     final chatWithModel = chatWithModelFromJson(jsonString);

import 'dart:convert';

List<ChatWithModel> chatWithModelFromJson(String str) => List<ChatWithModel>.from(json.decode(str).map((x) => ChatWithModel.fromJson(x)));

String chatWithModelToJson(List<ChatWithModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ChatWithModel {
  ChatWithModel({
    this.id,
    this.userId,
    this.staffId,
    this.date,
    this.time,
    this.readcount,
    this.recentMessage,
    this.staff,
    this.user,
  });

  int? id;
  int? userId;
  int? staffId;
  String? date;
  String? time;
  int? readcount;
  RecentMessage? recentMessage;
  Staff? staff;
  Staff? user;

  factory ChatWithModel.fromJson(Map<String, dynamic> json) => ChatWithModel(
    id: json["id"],
    userId: json["user_id"],
    staffId: json["staff_id"],
    date: json["date"],
    time: json["time"],
    readcount: json["readcount"],
    recentMessage: RecentMessage.fromJson(json["recent_message"]),
    staff: Staff.fromJson(json["staff"]),
    user: Staff.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "staff_id": staffId,
    "date": date,
    "time": time,
    "readcount": readcount,
    "recent_message": recentMessage == null ?null :recentMessage!.toJson(),
    "staff": staff == null ?null :staff!.toJson(),
    "user":  staff == null ?null :staff!.toJson(),
  };
}

class RecentMessage {
  RecentMessage({
    this.id,
    this.userId,
    this.staffId,
    this.chatlistId,
    this.message,
    this.replyTo,
    this.sendBy,
    this.date,
    this.time,
  });

  int? id;
  int? userId;
  int? staffId;
  int? chatlistId;
  String? message;
  String? replyTo;
  String? sendBy;
  String? date;
  String? time;

  factory RecentMessage.fromJson(Map<String, dynamic> json) => RecentMessage(
    id: json["id"],
    userId: json["user_id"],
    staffId: json["staff_id"],
    chatlistId: json["chatlist_id"],
    message: json["message"],
    replyTo: json["reply_to"],
    sendBy: json["send_by"],
    date: json["date"],
    time: json["time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "staff_id": staffId,
    "chatlist_id": chatlistId,
    "message": message,
    "reply_to": replyTo,
    "send_by": sendBy,
    "date": date,
    "time": time,
  };
}

class Staff {
  Staff({
    this.id,
    this.name,
    this.lastName,
    this.image,
  });

  int? id;
  String? name;
  String? lastName;
  String? image;

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
    id: json["id"],
    name: json["name"],
    lastName: json["last_name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "last_name": lastName,
    "image": image,
  };
}
