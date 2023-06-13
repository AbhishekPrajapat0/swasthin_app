// To parse this JSON data, do
//
//     final chatListModel = chatListModelFromJson(jsonString);

import 'dart:convert';

ChatListModel chatListModelFromJson(String str) => ChatListModel.fromJson(json.decode(str));

String chatListModelToJson(ChatListModel data) => json.encode(data.toJson());

class ChatListModel {
  ChatListModel({
    this.success,
    this.chat,
  });

  bool? success;
  List<Chat>? chat;

  factory ChatListModel.fromJson(Map<String, dynamic> json) => ChatListModel(
    success: json["success"],
    chat: List<Chat>.from(json["chat"].map((x) => Chat.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "chat": chat == null ? null :List<dynamic>.from(chat!.map((x) => x.toJson())),
  };
}

class Chat {
  Chat({
    this.id,
    this.chatlistId,
    this.userId,
    this.staffId,
    this.message,
    this.type,
    this.sendBy,
    this.replyTo,
    this.readcount,
    this.delivered,
    this.date,
    this.time,
    this.staff,
    this.user,
  });

  int? id;
  int? chatlistId;
  int? userId;
  int? staffId;
  String? message;
  String? type;
  String? sendBy;
  String? replyTo;
  String? readcount;
  int? delivered;
  String? date;
  String? time;
  Staff? staff;
  User? user;

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    id: json["id"],
    chatlistId: json["chatlist_id"],
    userId: json["user_id"],
    staffId: json["staff_id"],
    message: json["message"],
    type: json["type"],
    sendBy: json["send_by"],
    replyTo: json["reply_to"],
    readcount: json["readcount"],
    delivered: json["delivered"],
    date: json["date"],
    time: json["time"],
    staff: Staff.fromJson(json["staff"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "chatlist_id": chatlistId,
    "user_id": userId,
    "staff_id": staffId,
    "message": message,
    "type": type,
    "send_by": sendBy,
    "reply_to": replyTo,
    "readcount": readcount,
    "delivered": delivered,
    "date": date,
    "time": time,
    "staff":staff == null ? null : staff!.toJson(),
    "user": user == null ? null :user!.toJson(),
  };
}

class Staff {
  Staff({
    required this.id,
    required this.name,
    this.image,
  });

  int id;
  String name;
  String? image;

  factory Staff.fromJson(Map<String, dynamic> json) => Staff(
    id: json["id"],
    name: json["name"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
  };
}

class User {
  User({
    required this.id,
    required this.name,
  });

  int id;
  String name;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
