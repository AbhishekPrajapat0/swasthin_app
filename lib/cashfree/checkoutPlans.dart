import 'dart:async';
import 'dart:convert';
import 'package:Swasthin/Utlis/ApiUtlis.dart';
import 'package:Swasthin/contants/Constants.dart';
import 'package:Swasthin/controllers/Subscription%20Plans/StripePaymentController.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';

import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfwebcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';

import '../GlobalWidget/globalAlert.dart';
import '../GlobalWidget/loading_widget.dart';
import '../Models/Packages/PackagesListModel.dart';
import '../Utlis/globalFunctions.dart';
import '../screens/SubscriptionScreen/PaymentDoneScreen.dart';
import '../screens/SubscriptionScreen/PaymentFailedScreen.dart';
import '../screens/SubscriptionScreen/SubscriptionScreen.dart';

class CashfreeServices {
  var cfPaymentGatewayService = CFPaymentGatewayService();
  final mycontroller = Get.put(StripePaymentController());

  final AppId = "TEST396096e000b32747e77bf79f54690693";
  final SecretKey = "TESTdf63fdc62ab30b7d8a6b57a2868aff44f950fc6a";




  Future<String> verifyPayment(orderId, context,Package package) async {
    print("Order placed succefully : $orderId");

    final resp = await custAddPackage(package.id.toString());

    try {
      print("start api of success payment");
      loadingWithText(context, "Please wait, Loading....");
      var urlIs = Uri.parse(base_url + checkPaymentStatusUrl);
      GetStorage box = GetStorage();
      var token = box.read('token');

      print('This is Token in payment verifying $token');
      print('This is data $paymentSessionId  ${package.id} ${box.read(userID)} ');

      var header = getHeader();

      var response = await http.post(urlIs, headers: header, body: {
        "package_id": package.id.toString(),
        "subscription_id":resp["subscription_id"].toString(),
        "payment_id": paymentSessionId,
        "payment_method":"cashfree",
        "order_id":orderId.toString()
        // "payment_method": "stripepay"
      });

      var responseData = await json.decode(response.body);
      print(
          "this in the success iss and this is code ${response.statusCode} ${response.body} ");
      if (response.statusCode == 200) {
        stopLoading(context);

        /// stop loading
        var data = jsonDecode(response.body.toString());

        var responseMessage = data['success'];
        if (responseMessage) {
          GetStorage box = GetStorage();
          box.write(isSubscribed, true);

          Get.offAll(() => PaymentDoneScreen());
        } else {
          GlobalAlert(
              context,
              "Something Went Wrong",
              "Do not worry if payment is deducted \n we'll get back to you",
              DialogType.warning,
              onTap: () {});
        }
        print('$responseMessage is this');
        // var status
      } else if (response.statusCode == 500) {
        stopLoading(context);

        ///stop loading
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
      }
    } catch (e) {
      stopLoading(context);

      /// stop loading
      print("this is error $e");
    }



    return "Order placed succefully : $orderId";
  }

  Future<String?> onError(CFErrorResponse errorResponse, String orderId,
      context, Package package,String price) async {
    print("teh error  : ${errorResponse.getMessage()}");
    final box = GetStorage();

    try {
      print("start api of failed payment");
      loadingWithText(context, "Please wait, Loading....");
      var urlIs = Uri.parse(base_url + paymentFailedUrl);

      var header = getHeader();

      var response = await http.post(urlIs, headers: header, body: {
        "package_id": package.id.toString(),
        "payment_id": paymentSessionId,
        "order_id":orderId,
        "payment_method": "cashfree",
        "price": price.toString(),
        // "package_subscriptions_id" : id
      });
      print(
          'payment failed reason ${response.statusCode}  & ${response.body}  ');

      if (response.statusCode == 200) {
        stopLoading(context);

        /// stop loading
        Get.to(() => PaymentFailedScreen(package,orderId));
      } else if (response.statusCode == 500) {
        stopLoading(context);

        ///stop loading
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
      }
    } catch (e) {
      stopLoading(context);

      /// stop loading
      print("Payment Failed Error $e");
    }
  }

  String orderId = "order_124562";
  String paymentSessionId =
      "session_WgCCp5UBq27WZxq-sO7jnzaUrzZawU65lgeJZhlyRdduP7O-09HR07cfmEzDl5XneNTmcxAJD6R_oDJxLWx5fP5RqdYHrtj90yTQEtP8LhuY";
  CFEnvironment environment = CFEnvironment.SANDBOX;

  CFSession? createSession() {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderId)
          .setPaymentSessionId(paymentSessionId)
          .build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }

  pay() async {
    try {
      var session = createSession();
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.UPI);
      components.add(CFPaymentModes.CARD);
      components.add(CFPaymentModes.WALLET);
      var paymentComponent =
          CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder()
          .setNavigationBarBackgroundColorColor("#FF0000")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
          .build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session!)
          .setPaymentComponent(paymentComponent)
          .setTheme(theme)
          .build();

      await cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);
      return "succesfull";
    } on CFException catch (e) {
      print("Error on pay funciont : ${e.message}");
      return "unsuccessfully";
    }
  }

  webCheckout() async {
    try {
      var session = createSession();
      var cfWebCheckout =
          CFWebCheckoutPaymentBuilder().setSession(session!).build();
      cfPaymentGatewayService.doPayment(cfWebCheckout);
    } on CFException catch (e) {
      print(e.message);
    }
  }

  Future<String> CallPaymentScreen(
      {required Package package,
      required String myorderid,
      required String paySessionId,
      required BuildContext context,
      required String amount
      }) async {
    paymentSessionId = paySessionId;
    print("paymentssid :$paySessionId");
    orderId = myorderid;
    print("paymentSessionId : $paySessionId");

    var result;

    await mycallbackFun(context, package,amount);
    await pay().then((val) {
      return val;
    });
    return result ?? "";
  }

  mycallbackFun(BuildContext context, Package package,String amount) async {
    await cfPaymentGatewayService.setCallback((p0) async {
      verifyPayment(p0, context,package);
    }, (p0, p1) async {
      onError(p0, p1, context, package,amount);
    });
  }


  callAppBackendForOrderCreation(
      {required String orderId,required double amount})async{
    GetStorage box = GetStorage();
    var cusID = box.read(userID);
    var cusname = box.read(userName);
    var cusemail = box.read(userEmail);
    var cusNumber = box.read(userMobileNum);
    String endUrl =  "customer/cash/free/token?order_amount=$amount&order_id=$orderId&order_currency=INR&customer_id=$cusID&customer_name=$cusname&customer_email=$cusemail&customer_phone=$cusNumber";



    print(base_url+endUrl);

  var value = await http.get(Uri.parse(base_url+endUrl));
     if(value.statusCode==200){
       return await json.decode(value.body);
     }else{
       print("--------&_&&&-${value.statusCode}");
       Fluttertoast.showToast(msg: "Error Occured while processing your Payment: ${value.statusCode} ");

     }

  }
  custAddPackage(String packegid)async{
    String url = base_url + "customer/V1/packages";
    var head = getHeader();
    var body ={
      "package_id":"$packegid"

    };
    final response = await http.post(Uri.parse(url),headers: head,body: body);
    if(response.statusCode==200){
      final resp  =json.decode(response.body);
      print("pack added : ${resp['data']['subscriber_id']}     ${resp['data']['subscription_id']}");
      return {
        "subscriber_id":resp['data']['subscriber_id'],
        "subscription_id":resp['data']['subscription_id']
      };
    }else{
      print("error on addpack : ${response.statusCode}  ${response.body}");
      return null;
    }
  }
}

