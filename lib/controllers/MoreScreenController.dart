import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../contants/Constants.dart';
import '../../screens/auth/LoginScreen.dart';

import '../GlobalWidget/globalAlert.dart';
import '../Utlis/globalFunctions.dart';

class MoreScreenController {
  GetStorage box = GetStorage();

  deleteAccount(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.rightSlide,
      title: 'Deleting Account?',
      desc: 'Are you Sure you want to \nDelete your Account?',
      btnCancelOnPress: () {},
      btnCancelText: "No",
      btnOkText: "Yes",
      btnOkOnPress: () {
        hitApiToDeleteAccount(context);
      },
    ).show();
  }

  Future<void> hitApiToDeleteAccount(BuildContext context) async {
    try {
      print("In delete account Function");
      var urlIs = Uri.parse(base_url + accountDeleteUrl);
      var header = getHeader();

      var response = await get(
        urlIs,
        headers: header,
      );
      print('This is Token after hiiting api');

      // var responseData = await json.decode(response.body);
      print('\n');
      if (response.statusCode == 422) {
        print("reponse code is 422");
        print("Is user delete account before logout ${box.read(loggedIn)}");

        // box.write(loggedIn, false);
        // box.remove(loginToken);
        clearAllStorageData();
        print("Is user delete account In after logout ${box.read(loggedIn)}");

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (Route route) => false);
      } else if (response.statusCode == 500) {
        GlobalAlert(
            context,
            "Server Error",
            "The server has encountered an Error, Please Restart the App",
            DialogType.warning,
            onTap: () {});
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      } else {
        print("reponse code is ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      print("error while loging out $e");
    }
  }
}
