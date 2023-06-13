// To parse this JSON data, do
//
//     final plansBoughtListModel = plansBoughtListModelFromJson(jsonString);

import 'dart:convert';

List<PlansBoughtListModel> plansBoughtListModelFromJson(String str) => List<PlansBoughtListModel>.from(json.decode(str).map((x) => PlansBoughtListModel.fromJson(x)));

String plansBoughtListModelToJson(List<PlansBoughtListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PlansBoughtListModel {
  PlansBoughtListModel({
    this.packageId,
    this.image,
    this.name,
    this.description,
    this.price,
    this.startsAt,
    this.endsAt,
    this.active,
    this.subscriberId,
    this.id,
  });

  int? packageId;
  String? image;
  String? name;
  String? description;
  String? price;
  DateTime? startsAt;
  DateTime? endsAt;
  bool? active;
  int? subscriberId;
  int? id;

  factory PlansBoughtListModel.fromJson(Map<String, dynamic> json) => PlansBoughtListModel(
    packageId: json["package_id"],
    image: json["image"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
    startsAt: DateTime.parse(json["starts_at"]),
    endsAt: DateTime.parse(json["ends_at"]),
    active: json["active"],
    subscriberId: json["subscriber_id"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "image": image,
    "name": name,
    "description": description,
    "price": price,
    "starts_at": startsAt == null ? null :startsAt!.toIso8601String(),
    "ends_at": endsAt == null ? null :endsAt!.toIso8601String(),
    "active": active,
    "subscriber_id": subscriberId,
    "id": id,
  };
}
