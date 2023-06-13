// To parse this JSON data, do
//
//     final timeSlotsModel = timeSlotsModelFromJson(jsonString);

import 'dart:convert';

List<TimeSlotsModel> timeSlotsModelFromJson(String str) => List<TimeSlotsModel>.from(json.decode(str).map((x) => TimeSlotsModel.fromJson(x)));

String timeSlotsModelToJson(List<TimeSlotsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TimeSlotsModel {
  TimeSlotsModel({
    required this.slotStartTime,
    required this.slotEndTime,
    required this.session,
  });

  String slotStartTime;
  String slotEndTime;
  String session;

  factory TimeSlotsModel.fromJson(Map<String, dynamic> json) => TimeSlotsModel(
    slotStartTime: json["slot_start_time"],
    slotEndTime: json["slot_end_time"],
    session: json["session"],
  );

  Map<String, dynamic> toJson() => {
    "slot_start_time": slotStartTime,
    "slot_end_time": slotEndTime,
    "session": session,
  };
}
