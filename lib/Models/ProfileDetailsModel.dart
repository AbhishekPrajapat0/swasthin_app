// To parse this JSON data, do
//
//     final profileDetailsModel = profileDetailsModelFromJson(jsonString);

import 'dart:convert';

ProfileDetailsModel profileDetailsModelFromJson(String str) => ProfileDetailsModel.fromJson(json.decode(str));

String ProfileDetailsModelToJson(ProfileDetailsModel data) => json.encode(data.toJson());

class ProfileDetailsModel {
  ProfileDetailsModel({
    required this.data,
    this.allergy,
  });

  Data data;
  int? allergy;

  factory ProfileDetailsModel.fromJson(Map<String, dynamic> json) => ProfileDetailsModel(
    data: Data.fromJson(json["data"]),
    allergy: json["allergy"],
  );

  Map<String, dynamic> toJson() => {
    "data": data.toJson(),
    "allergy": allergy,
  };
}

class Data {
  Data({
    required this.id,
    required this.name,
    required this.email,
    required this.countryCode,
    required this.mobile,
    this.gender,
    this.age,
    this.dob,
    this.height,
    this.weight,
    this.physicalActivityLevel,
    this.medicalConditions,
    this.allergies,
    this.dietPreferences,
    this.goal,
    this.image,
  });

  int id;
  String name;
  String email;
  String countryCode;
  int mobile;
  String? gender;
  String? age;
  DateTime? dob;
  String? height;
  String? weight;
  String? physicalActivityLevel;
  String? medicalConditions;
  String? allergies;
  String? dietPreferences;
  String? goal;
  String? image;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    countryCode: json["country_code"],
    mobile: json["mobile"],
    gender: json["gender"],
    age: json["age"],
    dob: DateTime.parse(json["dob"]),
    height: json["height"],
    weight: json["weight"],
    physicalActivityLevel: json["physical_activity_level"],
    medicalConditions: json["medical_conditions"],
    allergies: json["allergies"],
    dietPreferences: json["diet_preferences"],
    goal: json["goal"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "country_code": countryCode,
    "mobile": mobile,
    "gender": gender,
    "age": age,
    "dob": dob?.toIso8601String(),
    "height": height,
    "weight": weight,
    "physical_activity_level": physicalActivityLevel,
    "medical_conditions": medicalConditions,
    "allergies": allergies,
    "diet_preferences": dietPreferences,
    "goal": goal,
    "image": image,
  };
}
