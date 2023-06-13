// To parse this JSON data, do
//
//     final renewPlanDetailsModel = renewPlanDetailsModelFromJson(jsonString);

import 'dart:convert';

RenewPlanDetailsModel renewPlanDetailsModelFromJson(String str) => RenewPlanDetailsModel.fromJson(json.decode(str));

String renewPlanDetailsModelToJson(RenewPlanDetailsModel data) => json.encode(data.toJson());

class RenewPlanDetailsModel {
  RenewPlanDetailsModel({
    this.success,
    this.package,
    this.programId,
  });

  bool? success;
  Package? package;
  String? programId;

  factory RenewPlanDetailsModel.fromJson(Map<String, dynamic> json) => RenewPlanDetailsModel(
    success: json["success"],
    package: Package.fromJson(json["package"]),
    programId: json["program_id"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "package": package == null ?null :package!.toJson(),
    "program_id": programId,
  };
}

class Package {
  Package({
    required this.packageId,
    required this.name,
    required this.description,
     this.image,
    required this.price,
    required this.discountPrice,
    required this.invoicePeriod,
  });

  int packageId;
  String name;
  String description;
  String? image;
  String price;
  String discountPrice;
  int invoicePeriod;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    packageId: json["package_id"],
    name: json["name"],
    description: json["description"],
    image: json["image"],
    price: json["price"],
    discountPrice: json["discount_price"],
    invoicePeriod: json["invoice_period"],
  );

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "name": name,
    "description": description,
    "image": image,
    "price": price,
    "discount_price": discountPrice,
    "invoice_period": invoicePeriod,
  };
}
