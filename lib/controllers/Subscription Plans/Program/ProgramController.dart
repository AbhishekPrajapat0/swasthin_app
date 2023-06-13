import 'package:get/get.dart';

import '../../../Models/SubscriptionPlans/ProgramListModel.dart';

class ProgramController extends GetxController {
  ProgramListModel programListModel = ProgramListModel();
  List<ProgramModel>? list = [];

  var selectedOnes;
  dynamic arguments = Get.arguments;

  var dataLoaded = false.obs;
  @override
  void onInit() {
    getProgramData();
    super.onInit();
  }

  Future<void> getProgramData() async {
    try {
      print("selectedones =========> ${arguments[0]["selected"]}");
      selectedOnes = arguments[0]["selected"];
      print("selected ones =========> ${selectedOnes[0].id}");
      dataLoaded.value = true;
      // var header = getHeader();
      // var uri = Uri.parse(base_url + getProgramsUrl);
      // var response = await get(uri, headers: header);
      // print("getting Packages ${response.statusCode} ${response.body}");
      // if(response.statusCode ==200) {
      //   var data = jsonDecode(response.body.toString());
      //   var packageData = data['package'];
      //   print("package data $data");
      //   print("package data $packageData");
      //   programListModel = ProgramListModel.fromJson(data);
      //   print("package data ${programListModel.list![0].image}");
      //
      //   dataLoaded.value = true;
      //
      // }else if (response.statusCode == 500){
      //   Get.back();
      // }else if (response.statusCode == 401 || response.statusCode == 302 || response.statusCode == 403){
      //  clearAllStorageData();
      //  Get.offAll(()=>LoginScreen());
      // }
    } catch (e) {
      print("error while getting packages list ====== $e");
    }
  }
}
