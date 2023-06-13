import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../../GlobalWidget/globalAlert.dart';
import '../../../GlobalWidget/loading_widget.dart';
import '../../../Utlis/ApiUtlis.dart';
import '../../../Utlis/globalFunctions.dart';
import '../../../contants/Constants.dart';

class EditMedicalConditionController extends GetxController{
  TextEditingController updatedMedicalCon = TextEditingController();

  dynamic arguments = Get.arguments;
  @override
  void onInit() {
    print("========= argument ==========> ${arguments[0]}");
    updatedMedicalCon.text = arguments[0];
    super.onInit();
  }


  updateToAPI( BuildContext context) async {
    try{
      loadingWithText(context, "Please Wait, Loading...");
      var url = Uri.parse(base_url + profileUpdateUrl);
      var data = {
        "medical_conditions":"${updatedMedicalCon.text}",
      };
      var header = getHeader();
      final response = await post(url,body: data,headers: header);
      print(" Updating Medical response ====>  ${response.statusCode} ${response.body}");
      if(response.statusCode == 200){

        var data = jsonDecode(response.body.toString());

        stopLoading(context); ///** Stop Loading919598
        // Get.to(()=>EditProfileScreen());
        Navigator.pop(context); /// go back screen
      }else if(response.statusCode == 422){
        stopLoading(context); ///** Stop Loading
      } else if (response.statusCode == 500){
        GlobalAlert(context, "Server Error", "The server has encountered an Error, Please Restart the App",DialogType.warning,onTap: (){});
      }else if (response.statusCode == 401 || response.statusCode == 302 || response.statusCode == 403){
        SessionExpiredFun();
      }else{
        stopLoading(context); ///** Stop Loading
        throw Exception();
      }
    }catch(e){
      stopLoading(context); ///** Stop Loading
      print("error is $e" );
      throw Exception();
    }
  }

}