import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart';

import '../../Models/TransactionHistoryModel/TransactionHistoryModel.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../screens/auth/LoginScreen.dart';

class TransactionController extends GetxController {
  TransactionHistoryModel transactionHistoryModel = TransactionHistoryModel();
  var loadingIsOn = true.obs;
  var noTransactions = true.obs;

  @override
  void onInit() {
    getTransactionList();
    super.onInit();
  }

  Future<void> getTransactionList() async {
    try {
      var header = getHeader();
      var uri = Uri.parse(base_url + transactionHistoryUrl);
      var response = await get(uri, headers: header);
      print(
          "getting appointments =====> ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var appointList = data['data'];
        print("package data $data");
        print("package data ${appointList}");
        transactionHistoryModel = TransactionHistoryModel.fromJson(data);
        print("================> ${transactionHistoryModel}");

        if (transactionHistoryModel.data!.length > 0 ||
            transactionHistoryModel.data == null) {
          noTransactions.value = !noTransactions.value;
        }
        loadingIsOn.value = !loadingIsOn.value;
        print("============> ${loadingIsOn.value} \\ ${noTransactions.value}");
      } else if (response.statusCode == 422) {
        noTransactions.value = true;
        loadingIsOn.value = !loadingIsOn.value;
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        clearAllStorageData();
        Get.offAll(() => LoginScreen());
      }
    } catch (e) {
      print("getting appointment list $e");
    }
  }
}
