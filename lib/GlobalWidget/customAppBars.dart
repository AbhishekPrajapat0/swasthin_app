import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../contants/colors.dart';
import '../screens/Dashboard/DashboardScreen.dart';

AppBar appBarWithBack(
  BuildContext context,
{String? title,
  List<Widget>? actions,
  required bool showBack
}
) {
  return AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title != null ? title : " ",
      style: TextStyle(
          color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
    ),
    leading: showBack ? Container(
        padding: EdgeInsets.only(left: 8, bottom: 2),
        margin: EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: InkWell(
            onTap: (){
              Get.back();
            },
            child: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ))) : Container(),
    actions: actions,
  );
}


//skipp button on app bar
skipButton({Function()? onTap}) {
  return InkWell(
    onTap: onTap,
    child: Container(
        padding: EdgeInsets.only(left: 18, right: 12),
        margin: EdgeInsets.all(7),
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        child: Center(child: Text('Skip', style: TextStyle(fontWeight: FontWeight.normal,color: textExtraMuted)))),
  );
}