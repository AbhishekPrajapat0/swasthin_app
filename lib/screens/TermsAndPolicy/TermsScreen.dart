import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:http/http.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/Constants.dart';

import '../../GlobalWidget/globalAlert.dart';
import '../../Utlis/globalFunctions.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({Key? key}) : super(key: key);

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getTermsFromApi();
  }

  var termsLoaded = true;
  String? htmlLoaded = '<center>Loading Please Wait..</center>';

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarWithBack(context,
            showBack: true, title: "Terms and Conditions"),
        body: Padding(
          padding: EdgeInsets.all(18),
          child: termsLoaded
              ? displayTerms()
              : GFShimmer(
                  child: Container(
                    height: 50,
                    width: screenWidth,
                    color: Colors.red,
                  ),
                ),
        ));
  }

  getTermsFromApi() async {
    try {
      var response = await get(Uri.parse(base_url + termsAndConditionsUrl));
      var responseData = json.decode(response.body);
      print("this is response ${response.statusCode} & $responseData ");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        print(
            "this is response before $htmlLoaded  ${data['data']['content']}");
        htmlLoaded = data['data']['content'].toString();
        print("this is response after $htmlLoaded");
        setState(() {
          termsLoaded = true;
        });
      } else if (response.statusCode == 500) {
        GlobalAlert(
            context,
            "Server Error",
            "The server has encountered an Error, Please Restart the App",
            DialogType.warning);
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      }
    } catch (e) {
      print("this is Error in geting terms $e");
    }
  }

  Widget displayTerms() {
    return SingleChildScrollView(
      child: HtmlWidget(htmlLoaded!),
    );
  }
}
