import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';

GlobalAlert(BuildContext context, String title, String descip,DialogType type , {Function()? onTap,EdgeInsetsGeometry? padding }) {
  AwesomeDialog(
    context: context,
    dialogType: type,
    animType: AnimType.rightSlide,
    title: title,
    titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
    desc: descip,
    btnOkOnPress: onTap,
    padding: padding
  ).show();
}



GlobalAlertQuestion(BuildContext context, String title, String descip,DialogType type , {Function()? onTap,EdgeInsetsGeometry? padding ,String? btnOkText,String? btnCancelText}) {
  AwesomeDialog(
      context: context,
      dialogType: type,
      animType: AnimType.rightSlide,
      title: title,
      titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
      desc: descip,
      btnCancelOnPress: (){},
      btnOkOnPress: onTap,
      padding: padding,
    btnOkText: btnOkText ?? "Yes",
    btnCancelText: btnCancelText ?? "No",
  ).show();
}