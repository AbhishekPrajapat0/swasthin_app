import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Models/DietModel/DietListModel.dart';

class DietSubmittedFeedbackController extends GetxController{
  TextEditingController feedbackCon = TextEditingController();
  var index ;
  dynamic arguments = Get.arguments;
  DietListModel listModel = DietListModel();

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  void getData() {
    listModel = arguments[0]["dietData"];
    index = arguments[0]["index"];

    feedbackCon.text = listModel.dietData![index].comment!;
  }
}