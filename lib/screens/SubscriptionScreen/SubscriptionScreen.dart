import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:Swasthin/screens/auth/LoginScreen.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:intl/intl.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:http/http.dart';
import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../GlobalWidget/loading_widget.dart';
import '../../Models/Packages/PackagesListModel.dart';
import '../../contants/colors.dart';
import '../../controllers/Subscription%20Plans/StripePaymentController.dart';
import '../../controllers/SubscriptionController.dart';
import '../../screens/Dashboard/DashboardScreen.dart';
import '../../screens/SubscriptionScreen/PaymentDoneScreen.dart';
import '../../screens/SubscriptionScreen/StripePaymentScreen.dart';
import '../../screens/UserDetails/SelectGender.dart';

import '../../GlobalWidget/customTimePicker.dart';
import '../../GlobalWidget/globalAlert.dart';
import '../../Utlis/ApiUtlis.dart';
import '../../Utlis/globalFunctions.dart';
import '../../cashfree/checkoutPlans.dart';
import '../../contants/Constants.dart';
import '../../contants/Formulas.dart';
import 'SubscriptionCarousel.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final StripePaymentController controller = Get.put(StripePaymentController());

  GetStorage box = GetStorage();
  List<Package> packagesList = [];

  List<bool>? selected;
  var buttonClickedOnce = false;
  var subscription_id;
  var selectedPackagePrice;
  var package_id;
  var loadingIsOn = true;
  var packageListEmpty = true;

  Razorpay _razorpay = Razorpay();

  // first thing run when the page is open
  @override
  void initState() {
    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    // _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    // _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    selected = List.generate(3, (index) => index == 2 ? true : false);
    getPackagesList();
    Future.delayed(Duration.zero, () {
      this.showIdeal();
    });
    // TODO: implement initState
    super.initState();
  }

  // functions runs when payment is successful
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    // Do something when payment succeeds
    var paymentId = response.paymentId;
    var orderId = response.orderId;
    var signature = response.signature;
    // Get.to(()=>DashboardScreen());
    updateSuccessPaymentStatus(
        paymentId, subscription_id.toString(), package_id.toString());
  }

  // function runs when payment was failed and user got back from razor pay
  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails

    var packageID = package_id;
    print("Clicked on payment $packageID  $subscription_id in payment success");
    var paymentId = response.error!["metadata"]['payment_id'].toString();
    print("payment Failed $paymentId @");
    print(
        "payment Failed because  ${response.message} ,  ${response.code} ,  ${response.error}");
    if (paymentId != "null") {
      print("payment Failed $paymentId @");
      sendPaymentFailedStatus(package_id.toString(), paymentId,
          selectedPackagePrice.toString(), subscription_id.toString());
    }
  }

  //  function runs when payment was payed by external wallet
  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  // disposing razorpay
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  //main widget
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar: appBarWithBack(context,
          showBack: false, title: "Select Subscription Plans"),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Future.delayed(Duration.zero, () {
      //       this.showIdeal();
      //     });
      //   },
      // ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: w * 0.9,
                padding: EdgeInsets.only(right: 50),
                margin: EdgeInsets.only(bottom: 20),
                child: Text(
                  "Please, Select at least any one of the Subscription plan you are interested in.",
                  style: TextStyle(color: textMuted),
                ),
              ),
              Center(
                child: Container(
                  // height: h*0.2,
                  // width: w*0.7,
                  decoration: BoxDecoration(
                    color: plansBgColor,
                    border: Border.all(
                      color: plansBorderColor, // set border color
                      width: 0.50, // set border width
                    ),
                    borderRadius:
                        BorderRadius.circular(10.0), // set border radius
                  ),
                  // child: Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //       horizontal: 16.0, vertical: 10),
                  //   child: const Text("Recommended Plans For You"),
                  // ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CustomTimePicker(
                          // width: w*0.2,
                          onPressed: () {
                            selected = List.generate(3, (index) => false);
                            setState(() {
                              selected![2] = true;
                              refreshSubscriptions();
                            });
                          },
                          selected: selected![2],
                          text: "Yoga + Diet Plans",
                          textSize: w * 0.03,
                          available: true,
                        ),
                        CustomTimePicker(
                          // width: w*0.2,
                          onPressed: () {
                            selected = List.generate(3, (index) => false);
                            setState(() {
                              selected![0] = true;
                              refreshSubscriptions();
                            });
                          },
                          selected: selected![0],
                          text: "Yoga Plans",
                          textSize: w * 0.03,
                          available: true,
                        ),
                        CustomTimePicker(
                          // width: w*0.2,
                          onPressed: () {
                            selected = List.generate(3, (index) => false);
                            setState(() {
                              selected![1] = true;
                              refreshSubscriptions();
                            });
                          },
                          selected: selected![1],
                          text: "Diet Plans",
                          textSize: w * 0.03,
                          available: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 18.0),
                child: loadingIsOn ? shimmerEffect(context) : getList(context),
                // child: getList(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getList(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;

    return Container(
      // color: kPrimaryGreen,
      height: h * 0.7,
      child: RefreshIndicator(
        onRefresh: refreshSubscriptions,
        child: ListView.builder(
            itemCount: packagesList.length,
            itemBuilder: (BuildContext context, int index) {
              var currentPackage = packagesList[index];
              var price = double.parse(currentPackage.price)
                  .toStringAsFixed(1)
                  .toString();
              var discountedPrice = double.parse(currentPackage.discountPrice)
                  .toStringAsFixed(1)
                  .toString();
              var validity =
                  "${currentPackage.invoicePeriod} ${currentPackage.invoiceInterval}";
              var descr =
                  currentPackage.description ?? "No description Available";
              return Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                // height: h*0.2,
                // width: w*0.7,
                decoration: BoxDecoration(
                  color: plansBgColor,
                  border: Border.all(
                    color: plansBorderColor, // set border color
                    width: 0.50, // set border width
                  ),
                  borderRadius:
                      BorderRadius.circular(10.0), // set border radius
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  width: w * 0.6,
                                  // color: Colors.red,
                                  child: Text(
                                    "${packagesList[index].name}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 17),
                                  )),
                              SizedBox(
                                height: h * 0.01,
                              ),
                              Container(
                                width: w * 0.5,
                                child: RichText(
                                  textAlign: TextAlign.start,
                                  text: TextSpan(
                                    text: '₹ $price ',
                                    style: TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.normal,
                                        color: textMuted,
                                        fontSize: 14),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: ' ₹ $discountedPrice ',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                            fontSize: 22,
                                            decoration: TextDecoration.none,
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Container(
                              //   padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                              //   decoration: BoxDecoration(
                              //     color: mainColor,
                              //     // border: Border.all(
                              //     //   color: plansBorderColor, // set border color
                              //     //   width: 0.50, // set border width
                              //     // ),
                              //     borderRadius: BorderRadius.circular(10.0), // set border radius
                              //   ),
                              //   child: Text('Buy',style: TextStyle(color: kPrimaryWhite),),
                              // ),
                              Obx(
                                () => GFButton(
                                  splashColor: Colors.blue,
                                  onPressed: controller.buttonClickedOnce.value
                                      ? null
                                      : () async {
                                    // print( "user login ${await box.read(loggedIn)}");
                                    //  var value= await CashfreeServices().callAppBackendForOrderCreation(orderId: "1581", amount: 25.0, userID: "965432");
                                    // print("response value of order creation $value");
                                    //
                                    // if(value!=null){
                                    //       await CashfreeServices().callBackendToStoreDetials().then((val)async{
                                    //         switch(val){
                                    //           case "Success":
                                    //             // CashfreeServices().CallPaymentScreen(package: currentPackage, paySessionId: '', context: null, myorderid: '');
                                    //             break;
                                    //           case "Failed":
                                    //               print("Payment Failed");
                                    //               break;
                                    //             default:
                                    //                 print("Default Switch");
                                    //                 break;
                                    //         }
                                    //       });
                                    //     }else{
                                    //       print("----#_#_#__#__$value");
                                    //     }




                                    if(await box.read(loggedIn)==null){

                                      await  Fluttertoast.showToast(msg: "Please Sign In to get access to all Features",fontSize: 14,backgroundColor: Colors.grey.shade200,textColor: Colors.black);

                                    Get.to(() => LoginScreen());

                                    }

                                    else{

                                    package_id = currentPackage.id;
                                    selectedPackagePrice =
                                        currentPackage.price;
                                    print("data ${subscription_id}");

                                    final appid =
                                        CashfreeServices().AppId;
                                    final secKey =
                                        CashfreeServices().SecretKey;
                                    print("Buy button clicked");
                                    Random random = Random();

                                    print("package : ID : $package_id");

                                    // Call function to generate orderDetails from cashfree Api
                                    final datetime  =DateTime.now();
                                    final box = GetStorage();
                                    String userid =await box.read(userID);
                                    String orderId =userid+ datetime.hour.toString()+ datetime.minute.toString()+datetime.second.toString() +datetime.year.toString();


                                    await CashfreeServices()
                                        .callAppBackendForOrderCreation(
                                        amount:double.parse(currentPackage.discountPrice),orderId: orderId )
                                        .then((value) async {
                                    print("response fropm backend for creation ${value["success"]}");
                                    value!=null?CashfreeServices().CallPaymentScreen(myorderid: orderId,paySessionId: value["success"]["payment_session_id"],package: currentPackage,context: context,amount:currentPackage.discountPrice):print("Order not created can't make payment");
                                    });
                                  }

                                          Timer(Duration(seconds: 10), () {
                                            controller.buttonClickedOnce.value =
                                                false;
                                          });
                                          // showIdeal();
                                        },
                                  color: mainColor,
                                  text: 'Buy',
                                ),
                              ),
                              // SizedBox(
                              //   height: h * 0.01,
                              // ),
                              // InkWell(
                              //     onTap: () {
                              //       Get.to(() => SelectGender());
                              //     },
                              //     child: Text(
                              //       "View Details >",
                              //       style: TextStyle(
                              //           color: clickAbleTextColor, fontSize: 10),
                              //     ))
                            ],
                          )
                        ],
                      ),
                      GFAccordion(
                        collapsedTitleBackgroundColor: Colors.grey.shade100,
                        expandedTitleBackgroundColor: Colors.grey.shade100,
                        titleChild: Text('Plan Details'),
                        contentChild: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("‣  Plan Validity - $validity \n"),
                            HtmlWidget(descr)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  //show ideal weight and calories
  void showIdeal() {
    var height = box.read(userHeight);
    var gender = box.read(userGender);
    var weight = box.read(userWeight);
    var activityLvl = box.read(userActivityLevel);
    print("ideal is $height $gender $activityLvl");
    var idealWeight = getIdealWeight(gender, height);
    var idealKcals = getIdealKcals(idealWeight, activityLvl);
    print("ideal is $idealWeight $idealKcals");

    showIdealForDialog(idealWeight, idealKcals, weight);
  }

  void showIdealForDialog(idealWeight, idealKcals, weight) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
                child: const Text(
              '** Ideal Weight & Calories **',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            )),
            content: dialogContent(idealWeight, idealKcals),
            actions: <Widget>[
              Center(
                child: Text(
                  'Note : Our recommended program for you is ${planShow(idealWeight.toString(), idealKcals, weight)}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: CustomButton(
                  text: "Okay",
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          );
        });
  }

  dialogContent(idealWeight, idealKcals) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(
            children: [
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                child: AnimatedTextKit(
                  pause: const Duration(milliseconds: 200),
                  animatedTexts: [
                    TypewriterAnimatedText('$idealWeight kg',
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        speed: Duration(milliseconds: 300)),
                  ],
                  isRepeatingAnimation: false,
                  onTap: () {
                    print("Tap Event");
                  },
                ),
              ),
              const Text(
                "is your Ideal Weight",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0),
          child: Column(
            children: [
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 20.0,
                ),
                child: AnimatedTextKit(
                  pause: const Duration(milliseconds: 200),
                  animatedTexts: [
                    TypewriterAnimatedText('$idealKcals kcals',
                        textStyle: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold),
                        speed: Duration(milliseconds: 300)),
                  ],
                  isRepeatingAnimation: false,
                ),
              ),
              const Text(
                "is your  Ideal Calories Consumptions",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.normal),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // get the packages list from api
  Future<void> getPackagesList() async {
    try {
      // var header = getHeader();
      var header ={'Accept': 'application/json'};
      var uri = Uri.parse(base_url + getPackageListUrl);
      var type = selected!.indexOf(true) + 1;
      print("subscreen typeof - ${type.runtimeType}");
      var body = {"type": type.toString()};
      var response = await post(uri, headers: header, body: body);
      print("getting Packages for subscreen ${response.statusCode} ${response.body}");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        var packageData = data['package'];
        print("package data $data");
        print("\nsubscren : package data $packageData \n");

        try {
          packagesList =
          await packageData.map<Package>((obj) => Package.fromJson(obj))
              .toList();
          ;

          setState(() {
            loadingIsOn = false;
            if (packagesList.length == 0) {
              packageListEmpty = true;
            }
          });
        }catch(e){
          print("subscreen : Error while converting package response to list Error===> $e");
        }
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

        // SessionExpiredFun();
      }else{
        print("subscreen : Statuscode ${response.statusCode}");
      }
    } catch (e) {

      print("subscreen : error while getting packages list $e");
    }
  }

  Widget shimmerEffect(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: RefreshIndicator(
              onRefresh: refreshSubscriptions,
              child: ListView.separated(
                shrinkWrap: true,
                padding: const EdgeInsets.all(1),
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return GFShimmer(
                      mainColor: Colors.grey.shade200,
                      secondaryColor: Colors.grey.shade300,
                      child: Card(
                        elevation: 0,
                        color: const Color(0xFFF9F9F9),
                        shape: const RoundedRectangleBorder(
                          side: BorderSide(
                            color: Colors.white54,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                        ),
                        child: SizedBox(
                          width: w,
                          height: h * 0.15,
                          child: Container(),
                        ),
                      ));
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
          //   child: Text(
          //     'Loading... Please Wait '
          //   ),
          // ),
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
        subscription_id = data['data']['subscription_id'];
        print("subscription id in 200 ==> $subscription_id $packagePrice");
        // makePayment(packageName, packagePrice, packageId,);
        stopLoading(context);

        /// stop loading
        await controller.makePayment(
            amount: packagePrice,
            currency: "IND",
            packageId: package_id.toString(),
            subscriberId: subscription_id.toString(),
            context: context);

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
          subscription_id = data['data']['subscription_id'];
          print("subscription id ==> $subscription_id");
          // makePayment(packageName, packagePrice, packageId);
          await controller.makePayment(
              amount: packagePrice,
              currency: "IND",
              packageId: package_id.toString(),
              subscriberId: subscription_id.toString(),
              context: context);
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

  void makePayment(
    String packageName,
    double packagePrice,
    int packageId,
  ) {
    print("this is payment details $packagePrice $packageName");
    print("Clicked on payment $packageId $subscription_id in make payment");

    var userContact = box.read(userMobileNum);
    var user_email = box.read(userEmail);
    printError(info: "EMAIL is $user_email $userContact");
    var options = {
      'key': 'rzp_test_Pcxw5YZ5JTcfeH',
      'amount': packagePrice * 100,
      'name': 'Swasthin',
      'description': '$packageName',
      'prefill': {'contact': '$userContact', 'email': '$userEmail'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("payment error $e");
    }
  }

  Future<void> updateSuccessPaymentStatus(
      String? paymentId, String subscriberId, String packageId) async {
    try {
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
        "payment_method": "razorpay"
      });
      var responseData = await json.decode(response.body);
      print(
          "this in the success iss and this is code ${response.statusCode} ${response.body} ");
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());

        var responseMessage = data['success'];
        if (responseMessage) {
          GetStorage box = GetStorage();
          box.write(isSubscribed, true);

          var date = DateFormat.yMMMd('en_US').format(DateTime.now());

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
      print("this is error $e");
    }
  }

  void sendPaymentFailedStatus(
      String packageId, String paymentId, String price, String id) async {
    try {
      loadingWithText(context, "Please wait, Loading....");
      var urlIs = Uri.parse(base_url + paymentFailedUrl);

      var header = getHeader();

      var response = await post(urlIs, headers: header, body: {
        "package_id": packageId,
        "payment_id": paymentId,
        "payment_method": "razorpay",
        "price": price,
        // "package_subscriptions_id" : id
      });
      print(
          'payment failed reason ${response.statusCode}  & ${response.body}  ');

      if (response.statusCode == 200) {
        Navigator.pop(context);
      }
    } catch (e) {
      print("Payment Failed Error $e");
    }
  }

  Future refreshSubscriptions() async {
    setState(() {
      loadingIsOn = true;
    });
    getPackagesList();
  }

  String planShow(idealWeight, idealKcals, weight) {
    if (double.tryParse(weight.toString())! <
        double.tryParse(idealWeight.toString())!) {
      return "Yoga + Diet Plans";
    } else if (double.tryParse(weight.toString())! >
        double.tryParse(idealWeight.toString())!) {
      return "Diet + Yoga Plans";
    }

    return "";
  }
}
