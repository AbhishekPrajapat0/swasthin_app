// To parse this JSON data, do
//
//     final TransactionHistoryModel = TransactionHistoryModelFromJson(jsonString);

import 'dart:convert';

TransactionHistoryModel TransactionHistoryModelFromJson(String str) => TransactionHistoryModel.fromJson(json.decode(str));

String TransactionHistoryModelToJson(TransactionHistoryModel data) => json.encode(data.toJson());

class TransactionHistoryModel {
  TransactionHistoryModel({
    this.success,
    this.data,
  });

  bool? success;
  List<Datum>? data;

  factory TransactionHistoryModel.fromJson(Map<String, dynamic> json) => TransactionHistoryModel(
    success: json["success"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.packageId,
    this.transactionId,
    this.price,
    this.status,
    this.date,
    this.time,
    this.package,
  });

  int? packageId;
  String? transactionId;
  String? price;
  String? status;
  String? date;
  String? time;
  Package? package;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    packageId: json["package_id"],
    transactionId: json["transaction_id"],
    price: json["price"],
    status: json["status"],
    date: json["date"],
    time: json["time"],
    package: Package.fromJson(json["package"]),
  );

  Map<String, dynamic> toJson() => {
    "package_id": packageId,
    "transaction_id": transactionId,
    "price": price,
    "status": status,
    "date": date,
    "time": time,
    "package": package == null ? null : package!.toJson(),
  };
}

class Package {
  Package({
    this.id,
    this.name,
  });

  int? id;
  String? name;

  factory Package.fromJson(Map<String, dynamic> json) => Package(
    id: json["id"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}
