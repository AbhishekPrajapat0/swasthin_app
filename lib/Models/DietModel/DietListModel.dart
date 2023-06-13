// To parse this JSON data, do
//
//     final dietListModel = dietListModelFromJson(jsonString);

import 'dart:convert';

DietListModel dietListModelFromJson(String str) => DietListModel.fromJson(json.decode(str));

String dietListModelToJson(DietListModel data) => json.encode(data.toJson());

class DietListModel {
  DietListModel({
    this.sucess,
    this.totalCalories,
    this.dietData,
  });

  bool? sucess;
  TotalCalories? totalCalories;
  List<DietDatum>? dietData;

  factory DietListModel.fromJson(Map<String, dynamic> json) => DietListModel(
    sucess: json["sucess"],
    totalCalories: TotalCalories.fromJson(json["total_calories"]),
    dietData: List<DietDatum>.from(json["diet_data"].map((x) => DietDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "sucess": sucess,
    "total_calories": totalCalories == null? null :totalCalories!.toJson(),
    "diet_data": dietData == null ? null : List<dynamic>.from(dietData!.map((x) => x.toJson())),
  };
}

class DietDatum {
  DietDatum({
    this.id,
    this.nutritionListId,
    this.userId,
    this.staffId,
    this.date,
    this.nutritionTime,
    this.startTime,
    this.endTime,
    this.nutritionCalories,
    this.comment,
    this.foods,
  });

  int? id;
  int? nutritionListId;
  int? userId;
  int? staffId;
  DateTime? date;
  String? nutritionTime;
  String? startTime;
  String? endTime;
  String? nutritionCalories;
  dynamic comment;
  List<Food>? foods;

  factory DietDatum.fromJson(Map<String, dynamic> json) => DietDatum(
    id: json["id"],
    nutritionListId: json["nutrition_list_id"],
    userId: json["user_id"],
    staffId: json["staff_id"],
    date: DateTime.parse(json["date"]),
    nutritionTime: json["nutrition_time"],
    startTime: json["start_time"],
    endTime: json["end_time"],
    nutritionCalories: json["nutrition_calories"],
    comment: json["comment"],
    foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nutrition_list_id": nutritionListId,
    "user_id": userId,
    "staff_id": staffId,
    "date": date == null ? null : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
    "nutrition_time": nutritionTime,
    "start_time": startTime,
    "end_time": endTime,
    "nutrition_calories": nutritionCalories,
    "comment": comment,
    "foods": foods == null ? null :List<dynamic>.from(foods!.map((x) => x.toJson())),
  };
}

class Food {
  Food({
    this.id,
    this.nutritionDataId,
    this.foodName,
    this.qty,
    this.calories,
    this.consent,
    this.fat,
    this.carbs,
    this.proteins,
  });

  int? id;
  int? nutritionDataId;
  String? foodName;
  int? qty;
  String? calories;
  dynamic consent;
  String? fat;
  String? carbs;
  String? proteins;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
    id: json["id"],
    nutritionDataId: json["nutrition_data_id"],
    foodName: json["food_name"],
    qty: json["qty"],
    calories: json["calories"],
    consent: json["consent"],
    fat: json["fat"],
    carbs: json["carbs"],
    proteins: json["proteins"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "nutrition_data_id": nutritionDataId,
    "food_name": foodName,
    "qty": qty,
    "calories": calories,
    "consent": consent,
    "fat": fat,
    "carbs": carbs,
    "proteins": proteins,
  };
}

class TotalCalories {
  TotalCalories({
    this.totalCalories,
  });

  String? totalCalories;

  factory TotalCalories.fromJson(Map<String, dynamic> json) => TotalCalories(
    totalCalories: json["total_calories"],
  );

  Map<String, dynamic> toJson() => {
    "total_calories": totalCalories,
  };
}
