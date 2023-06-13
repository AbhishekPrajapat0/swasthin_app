import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get_storage/get_storage.dart';
import '../../contants/Constants.dart';
import '../../contants/Formulas.dart';

class SubscriptionController extends GetxController {
  GetStorage box = GetStorage();

  @override
  void onInit() {
    showIdeal();
    super.onInit();
  }

  void showIdeal() {
    var height = box.read(userHeight);
    var gender = box.read(userGender);
    var activityLvl = box.read(userActivityLevel);
    print("ideal is $height $gender $activityLvl");
    var idealWeight = getIdealWeight(gender, height);
    var idealKcals = getIdealKcals(idealWeight, activityLvl);
    print("ideal is $idealWeight $idealKcals");

    showIdealForDialog(idealWeight, idealKcals);
  }

  void showIdealForDialog(idealWeight, idealKcals) {
    Future.delayed(Duration.zero, () {});
  }
}
