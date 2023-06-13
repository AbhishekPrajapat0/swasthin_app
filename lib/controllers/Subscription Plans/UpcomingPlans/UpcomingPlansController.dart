import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../../Models/SubscriptionPlans/PlansBoughtListModel.dart';
import '../../../Utlis/ApiUtlis.dart';
import '../../../Utlis/globalFunctions.dart';
import '../../../contants/Constants.dart';

class UpcomingPlansController extends GetxController{

  List<PlansBoughtListModel>? list = [];
  var dataLoaded = false.obs;
  var noPlans = true.obs;
  PlansBoughtListModel boughtListModel = PlansBoughtListModel();

  @override
  void onInit() {
    getAllPlansBoughtList();
    super.onInit();
  }



  Future<void> getAllPlansBoughtList() async {
    try {
      var header = getHeader();
      var uri = Uri.parse(base_url + plansBoughtListUrl);
      var response = await get(uri, headers: header);
      print("getting active Plans list =====> ${response.statusCode} ${response.body}");
      if(response.statusCode ==200) {
        var data = jsonDecode(response.body.toString());
        var packageData = data[0];
        print("package data ===> $packageData");
        list = data.map<PlansBoughtListModel>((obj) => PlansBoughtListModel.fromJson(obj)).toList();
        if(list!.length > 0){
          noPlans.value = false;
        }
        dataLoaded.value = !dataLoaded.value ;

      }else if (response.statusCode == 422){
        dataLoaded.value = !dataLoaded.value ;
      }else if (response.statusCode == 500){

      }else if (response.statusCode == 401 || response.statusCode == 302 || response.statusCode == 403){
        SessionExpiredFun();
      }
    } catch (e) {
      print("error while getting actibve Plans list $e");
    }
  }


  refreshPage(){
    dataLoaded.value = false;
    getAllPlansBoughtList();
  }

}