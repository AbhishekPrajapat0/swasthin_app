// To parse this JSON data, do
//
//     final packagesListModel = packagesListModelFromJson(jsonString);

import 'dart:convert';

PackagesListModel packagesListModelFromJson(String str) => PackagesListModel.fromJson(json.decode(str));

String packagesListModelToJson(PackagesListModel data) => json.encode(data.toJson());

class PackagesListModel {
  PackagesListModel({
    required this.success,
    required this.package,
  });

  bool success;
  List<Package> package;

  factory PackagesListModel.fromJson(Map<String, dynamic> json) => PackagesListModel(
    success: json["success"],
    package: List<Package>.from(json["package"].map((x) => Package.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "package": List<dynamic>.from(package.map((x) => x.toJson())),
  };
}

class Package {
  Package({
    required this.id,
    required this.name,
    required this.price,
     this.description,
    required this.discountPrice,
    required this.invoicePeriod,
    required this.invoiceInterval,
    required this.subscribed,
    required this.subscriptionId,
    required this.active,
    required this.features,
  });

  int id;
  String name;
  String price;
  String? description;
  String discountPrice;
  int invoicePeriod;
  String invoiceInterval;
  int? subscribed;
  int? subscriptionId;
  bool? active;
  List<dynamic> features;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json["id"],
    name: json["name"],
    price: json["price"],
    description: json["description"],
    discountPrice: json["discount_price"],
    invoicePeriod: json["invoice_period"],
    invoiceInterval: json["invoice_interval"],
    subscribed: json["subscribed"],
    subscriptionId: json["subscription_id"],
    active: json["active"],
    features: List<dynamic>.from(json["features"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "description": description,
    "discount_price": discountPrice,
    "invoice_period": invoicePeriod,
    "invoice_interval": invoiceInterval,
    "subscribed": subscribed,
    "subscription_id": subscriptionId,
    "active": active,
    "features": List<dynamic>.from(features.map((x) => x)),
  };
}
