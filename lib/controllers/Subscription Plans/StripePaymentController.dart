import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:rounded_loading_button/rounded_loading_button.dart';

import '../../GlobalWidget/globalAlert.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../contants/Constants.dart';
import '../../screens/SubscriptionScreen/PaymentDoneScreen.dart';

class StripePaymentController extends GetxController {
  final RoundedLoadingButtonController btnCartController =
      RoundedLoadingButtonController();

  var buttonClickedOnce = false.obs;

  GetStorage box = GetStorage();
  var paymentId;

  var selected = true.obs;
  bool failure = false;

  @override
  void onInit() {
    super.onInit();
  }

  Map<String, dynamic>? paymentIntentData;

  makePayment(
      {required double amount,
      required String currency,
      required String subscriberId,
      required String packageId,
      required BuildContext context,

      }) async {
    try {
      var userContact = box.read(userMobileNum);
      var user_email = box.read(userEmail);
      var seckretKey = await getStripSecrectKey();
      // var token = {"api_token": _currentUser.value.accessToken!};
      // paymentIntentData = await createPaymentIntent("1", amount, "INR", "sk_test_51MuWQhSBKr45iDh5B0Cx7XKij1Gy5cMi3rEWSpsVqHVWkvoxn0Auv7K5i04O6eEEg2w1M4qTDreLNRkXORGtawd000fIIMerUw");
      paymentIntentData =
          await createPaymentIntent("1", amount, "INR", seckretKey);
      if (paymentIntentData != null) {
        paymentId = paymentIntentData!['id'];
        print("=================>>>>>>>>>>>>>>>>>>>>> not null");
// Add the code to generate or store the clicked data.

        // var booking = await createBooking(paymentIntentData!['id'].toString());
        // print("this is payment data $paymentIntentData");

        // if (booking != null) {
        final billingDetails = BillingDetails(
          email: "$user_email",
          phone: "$userContact",
          address: Address(
            city: 'Mumbai',
            country: 'IN',
            line1: 'addressList.value.addresslist[0].address1',
            line2: 'addressList.value.addresslist[0].address2',
            state: 'Maharashtra',
            postalCode: '400001',
          ),
        );
        await Stripe.instance.initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
// Customer params
          customerId: paymentIntentData!['id'],
          paymentIntentClientSecret: paymentIntentData!['client_secret'],
          customerEphemeralKeySecret: paymentIntentData!['ephemeralKey'],

// Extra params
          merchantDisplayName: 'Swasthin',
          applePay: PaymentSheetApplePay(
            merchantCountryCode: 'INR',
          ),
          googlePay: PaymentSheetGooglePay(
            merchantCountryCode: 'IND',
            testEnv: true,
          ),
          style: ThemeMode.system,
          // primaryButtonColor: Colors.blue,
          billingDetails: billingDetails,
        ));
        var paid = await displayPaymentSheet();
        if (paid != null) {
          btnCartController.reset();
          if (paid) {
            updateSuccessPaymentStatus(
                context, paymentId, subscriberId, packageId);
          } else {
            sendPaymentFailedStatus(
                context, packageId, paymentId, amount * 100,

                // type
            );
          }
        } else {
          btnCartController.reset();
        }

        // var b_id = booking["booking_id"];
        // if (paid == true) {
        //   var success = paymentType(b_id, paymentIntentData!['id'].toString());
        //   if (success == true) {
        //     return true;
        //   }
        // }
      }
      // }
    } catch (e, s) {
      print('exception:$e$s ');
      return false;
    }
  }

  createPaymentIntent(
      String s, double amount, String currency, String param3) async {
    try {
      Map<String, dynamic> body = {
        'amount': ((amount * 100).ceil()).toString(),
        'currency': currency,
        'payment_method_types[]': 'card',
        // "statement_descriptor": "Booking $id payment"
      };

      print("here 1");

      var response = await post(
          Uri.parse('https://api.stripe.com/v1/payment_intents'),
          body: body,
          headers: {
            'Authorization': "Bearer $param3",
            'Content-Type': 'application/x-www-form-urlencoded'
          });

      print("here 2  ${response.statusCode}");
      print(response.body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 422) {
        print("response_code 422");
      } else if (response.statusCode == 500) {
        print("response_code 500");
      } else if (response.statusCode == 401 ||
          response.statusCode == 302 ||
          response.statusCode == 403) {
        print("response_code 401 302 403");
        print(response.body);
        // SessionExpiredFun();
      }
      print("here 1");
    } catch (e) {
      print("error while getting actibve packages $e");
    }
  }

  displayPaymentSheet() async {
    try {
      var paid = false;
      await Stripe.instance.presentPaymentSheet();
      // Get.snackbar('Payment', 'Payment Successful',
      //     snackPosition: SnackPosition.BOTTOM,
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //     margin: const EdgeInsets.all(10),
      //     duration: const Duration(seconds: 2));
      paid = true;
      return paid;
    } on Exception catch (e) {
      if (e is StripeException) {
        print("Error from Stripe: ${e.error.localizedMessage}");
        btnCartController.reset();
        var paid = false;
        failure = true;
        return paid;
      } else {
        print("Unforeseen error: ${e}");
      }
    } catch (e) {
      print("exception:$e");
    }
  }

  /// Updating Payment status
  Future<void> updateSuccessPaymentStatus(BuildContext context,
      String? paymentId, String subscriberId, String packageId,) async {
    try {
      print("start api of success payment");
      loadingWithText(context, "Please wait, Loading....");
      var urlIs = Uri.parse(base_url + checkPaymentStatusUrl);
      GetStorage box = GetStorage();
      var token = box.read('token');

      print('This is Token in payment verifying $token');
      print('This is data $paymentId  $packageId $subscriberId ');

      var header = getHeader();

      var response = await post(urlIs, headers: header, body: {
        "package_id": packageId.toString(),
        "subscription_id": subscriberId.toString(),
        "payment_id": paymentId,
        "payment_method":"cashfree",
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
  }

  /// upadte payment status if failed
  ///
  void sendPaymentFailedStatus(
    BuildContext context,
    String packageId,
    String paymentId,
    double price,
    // String? type,
  ) async {
    try {
      print("start api of failed payment");
      loadingWithText(context, "Please wait, Loading....");
      var urlIs = Uri.parse(base_url + paymentFailedUrl);

      var header = getHeader();

      var response = await post(urlIs, headers: header, body: {
        "package_id": packageId,
        "payment_id": paymentId,
        "payment_method": "stripepay",
        "price": price.toString(),
        // "package_subscriptions_id" : id
      });
      print(
          'payment failed reason ${response.statusCode}  & ${response.body}  ');

      if (response.statusCode == 200) {
        stopLoading(context);

        /// stop loading
        // Get.to(() => PaymentFailedScreen(), arguments: [type]);
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

  Future<String> getStripSecrectKey() async {
    try {
      var uri = Uri.parse(base_url + getStripeKeyUrl);
      final response = await get(uri);
      print(
          "getting stripe key stripe_secret_key  ===> ${response.statusCode}");
      print(
          "getting stripe key stripe_secret_key ================> ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data["data"]["stripe_secret_key"];
      } else {
        return "no key";
      }
    } catch (e) {
      print("error on getting stripe key >>>>> $e");
      throw Exception();
    }
  }
}
