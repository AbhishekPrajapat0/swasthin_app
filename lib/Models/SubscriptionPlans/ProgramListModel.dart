// To parse this JSON data, do
//
//     final programListModel = programListModelFromJson(jsonString);

import 'dart:convert';

ProgramListModel programListModelFromJson(String str) => ProgramListModel.fromJson(json.decode(str));

String programListModelToJson(ProgramListModel data) => json.encode(data.toJson());

class ProgramListModel {
  ProgramListModel({
    this.success,
    this.list,
  });

  bool? success;
  List<ProgramModel>? list;

  factory ProgramListModel.fromJson(Map<String, dynamic> json) => ProgramListModel(
    success: json["success"],
    list: List<ProgramModel>.from(json["list"].map((x) => ProgramModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "list": List<dynamic>.from(list!.map((x) => x.toJson())),
  };
}

class ProgramModel {
  ProgramModel({
    required this.id,
    required this.image,
    required this.program,
    required this.description,
  });

  int id;
  String image;
  String program;
  String description;

  factory ProgramModel.fromJson(Map<String, dynamic> json) => ProgramModel(
    id: json["id"],
    image: json["image"],
    program: json["program"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
    "program": program,
    "description": description,
  };
}
