import 'dart:convert';

List<AllChats> allChatsFromJson(String str) => List<AllChats>.from(json.decode(str).map((x) => AllChats.fromJson(x)));

String allChatsToJson(List<AllChats> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AllChats {
  AllChats({
    this.id,
    this.time,
    this.date,
    this.recentMessage,
    this.status,
    this.readCount,
    this.user,
  });

  int? id;
  String? time;
  String? date;
  RecentMessage? recentMessage;
  String? status;
  int? readCount;
  Usr? user;

  factory AllChats.fromJson(Map<String, dynamic> json) => AllChats(
    id: json["id"],
    time: json["time"],
    date: json["date"],
    readCount: json["readcount"],
    recentMessage: (json["recent_message"] != null) ? RecentMessage.fromJson(json["recent_message"]) : null,
    status: json["status"],
    user: (json["user"] != null) ? Usr.fromJson(json["user"]) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "time": time,
    "date": date,
    "recent_message": recentMessage!.toJson(),
    "status": status,
    "readcount": readCount,
    "user": user,
  };
}

class Usr {
  int? id;
  String? name;

  Usr({this.id, this.name});

  Usr.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };

}

class RecentMessage {
  RecentMessage({
    this.id,
    this.userId,
    this.chatlistId,
    this.message,
    this.sendBy,
    this.replyBy,
  });

  int? id;
  int? userId;
  int? chatlistId;
  String? message;
  String? sendBy;
  String? replyBy;

  factory RecentMessage.fromJson(Map<String, dynamic> json) => RecentMessage(
    id: json["id"],
    userId: json["user_id"],
    chatlistId: json["chatlist_id"],
    message: json["message"],
    sendBy: json["send_by"],
    replyBy: json["reply_to"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "chatlist_id": chatlistId,
    "message": message,
    "send_by": sendBy,
    "reply_by": replyBy,
  };
}
