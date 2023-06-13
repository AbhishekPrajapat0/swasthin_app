import 'dart:convert';

import 'package:Swasthin/contants/colors.dart';
import 'package:Swasthin/controllers/Subscription%20Plans/StripePaymentController.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import '../../../GlobalWidget/CustomButton.dart';
import '../../../GlobalWidget/customAppBars.dart';
import '../../../GlobalWidget/globalAlert.dart';
import '../../../GlobalWidget/loading_widget.dart';
import '../../../Models/SubscriptionPlans/Renew/RenewPlanDetailsModel.dart';
import '../../../Utlis/ApiUtlis.dart';
import '../../../Utlis/globalFunctions.dart';
import '../../../contants/Constants.dart';
import '../../../contants/images.dart';

class RenewPayScreen extends StatefulWidget {
  const RenewPayScreen({Key? key}) : super(key: key);

  @override
  State<RenewPayScreen> createState() => _RenewPayScreenState();
}

class _RenewPayScreenState extends State<RenewPayScreen> {
  StripePaymentController controller = StripePaymentController();
  RenewPlanDetailsModel model = RenewPlanDetailsModel();
  dynamic arguments = Get.arguments;
  var programId = "";
  var dataLoaded = false;

  @override
  void initState() {
    initTask();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context, showBack: true, title: "Renew Plan"),
      bottomNavigationBar: BottomButton(),
      body: dataLoaded
          ? getDetails()
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  BottomButton() {
    return CustomButton(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 25),
      onPressed: () {
        var packageName = model.package!.name;
        var packageId = model.package!.packageId;
        var price = model.package!.discountPrice;
        initiatedPayment(packageId, packageName, double.parse(price));
      },
      text: "Pay",
    );
  }

  Future<void> initTask() async {
    try {
      programId = arguments[0]["program_id"].toString();
      print(
          "program id =====================================================> $programId");
      var header = getHeader();
      var uri = Uri.parse(base_url + getRenewPlanDetailsUrl);
      var body = {"program_id": programId.toString()};
      var response = await post(uri, headers: header, body: body);
      print(
          "getting active Packages =====> ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(
            "data ===============================================================>\n $data \n ============================================");
        model = RenewPlanDetailsModel.fromJson(data);
        setState(() {
          dataLoaded = true;
        });
      } else if (response.statusCode == 422) {
        setState(() {
          dataLoaded = true;
        });
      } else if (response.statusCode == 500) {
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        SessionExpiredFun();
      }
    } catch (e) {
      print(
          "error while details ===========================================> $e");
    }
  }

  getDetails() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    var name = model.package!.name;
    var validity = model.package!.invoicePeriod;
    var desc = model.package!.description;
    var price =
        double.parse(model.package!.price).toStringAsFixed(1).toString();
    var discountedPrice = double.parse(model.package!.discountPrice)
        .toStringAsFixed(1)
        .toString();
    var imageUrl = model.package!.image ?? "null";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      margin: EdgeInsets.all(16),
      width: w,
      decoration: BoxDecoration(
        color: plansBgColor,
        border: Border.all(
          color: plansBorderColor, // set border color
          width: 0.50, // set border width
        ),
        borderRadius: BorderRadius.circular(10.0), // set border radius
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: plansBgColor,
                  image: imageUrl == "null"
                      ? DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(noImageAvailVector))
                      : DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage("$imageUrl")),
                  border: Border.all(
                    color: plansBorderColor, // set border color
                    width: 0.50, // set border width
                  ),
                  borderRadius:
                      BorderRadius.circular(10.0), // set border radius
                ),
                width: w * 0.25,
                height: w * 0.25,
                // child: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/800px-Image_created_with_a_mobile_phone.png"),
              ),
              SizedBox(
                width: w * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: h * 0.02,
                  ),
                  Container(
                      width: w * 0.55,
                      child: Text(
                        "$name",
                        style: TextStyle(
                            fontSize: w * 0.06, fontWeight: FontWeight.w400),
                        overflow: TextOverflow.ellipsis,
                      )),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Container(
                      width: w * 0.55,
                      child: Text("Plan Validity : $validity Days",
                          style: TextStyle(
                              fontSize: w * 0.03, fontWeight: FontWeight.w300),
                          overflow: TextOverflow.ellipsis)),
                  SizedBox(
                    height: h * 0.02,
                  ),
                ],
              )
            ],
          ),
          SizedBox(
            height: h * 0.01,
          ),
          Container(
              // color: kPrimaryRed,
              width: w * 0.8,
              margin: EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description : ",
                    style: TextStyle(
                        fontSize: w * 0.04, fontWeight: FontWeight.w300),
                  ),
                  SizedBox(
                    height: h * 0.01,
                  ),
                  Container(
                    width: w,
                    child: HtmlWidget(desc),
                  ),
                ],
              )
              // child: Text("${desc}",style: TextStyle(fontSize: w*0.04,fontWeight: FontWeight.w300),)
              ),
          SizedBox(
            height: h * 0.02,
          ),
          Container(
            width: w * 0.8,
            child: RichText(
              text: TextSpan(
                text: 'Price : ',
                style: TextStyle(
                  fontFamily: 'Your App Font Family',
                  color: kPrimaryBlack,
                  fontWeight: FontWeight.w400,
                  fontSize: w * 0.06,
                ),
                children: [
                  TextSpan(
                    text: '₹ $price',
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: textExtraMuted,
                        decoration: TextDecoration.lineThrough),
                  ),
                  TextSpan(
                    text: '  ',
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      color: textExtraMuted,
                    ),
                  ),
                  TextSpan(
                    text: '₹ $discountedPrice',
                    style: TextStyle(
                      color: kPrimaryBlack,
                      fontWeight: FontWeight.w500,
                      fontSize: w * 0.06,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> initiatedPayment(
      int packageId, String packageName, double packagePrice) async {
    try {
      loadingWithText(context, "Please wait, Loading....");
      var urlIs = Uri.parse(base_url + selectPackageUrl);

      var header = getHeader();

      var response = await post(urlIs, headers: header, body: {
        "package_id": packageId.toString(),
      });
      print("selected package api ==> ${response.statusCode} ");
      print("selected package api Body ==> ${response.body} ");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var packageData = data['data'];
        var subscription_id = data['data']['subscription_id'];
        print("subscription id in 200 ==> $subscription_id $packagePrice");
        // makePayment(packageName, packagePrice, packageId,);
        stopLoading(context);

        /// stop loading
        await controller.makePayment(
            amount: packagePrice,
            currency: "IND",
            packageId: packageId.toString(),
            subscriberId: subscription_id.toString(),
            context: context,
            // type: "renew"
        );

        // return PackagePaymentInitiatedModel.fromJson(responseData);
      } else if (response.statusCode == 500) {
        stopLoading(context);

        /// stop loading
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
        stopLoading(context);

        /// stop loading
        print("this is data from Api");
        var data = jsonDecode(response.body.toString());
        var status = data['status'];

        print('response ${response.statusCode} and data is $data');

        if (status == "pending") {
          var data = jsonDecode(response.body.toString());
          var packageData = data['data'];
          var subscription_id = data['data']['subscription_id'];
          print("subscription id ==> $subscription_id");
          // makePayment(packageName, packagePrice, packageId);
          await controller.makePayment(
              amount: packagePrice,
              currency: "IND",
              packageId: packageId.toString(),
              subscriberId: subscription_id.toString(),
              context: context,
              // type: "renew"
          );
        } else {
          GlobalAlert(context, "Package Already Bought ",
              "You have already Bought this Package", DialogType.warning,
              onTap: () {});
        }
      }
    } catch (e) {
      print("this is error $e");
    }
  }
}
