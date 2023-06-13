import 'package:flutter/material.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';

loadingWithText(BuildContext context, String msg) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return WillPopScope(
        onWillPop: () async {
          return false;
          },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const GFLoader(
                  duration: Duration(minutes: 10),
                  type: GFLoaderType.android
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  '$msg',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Roboto',
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}


stopLoading(BuildContext context){
  Navigator.pop(context);
}