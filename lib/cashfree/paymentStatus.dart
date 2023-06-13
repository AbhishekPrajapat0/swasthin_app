import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/button/gf_button.dart';

import '../Models/Packages/PackagesListModel.dart';
import '../contants/Constants.dart';
import '../contants/colors.dart';
import '../controllers/Subscription Plans/StripePaymentController.dart';
import '../screens/SubscriptionScreen/SubscriptionScreen.dart';
import '../screens/auth/LoginScreen.dart';
import 'checkoutPlans.dart';

class CashFreePaymentStatus extends StatefulWidget {
  final Package package;
  final orderid;

  const CashFreePaymentStatus(
      {super.key, required this.package, required this.orderid});

  @override
  State<CashFreePaymentStatus> createState() => _CashFreePaymentStatusState();
}

class _CashFreePaymentStatusState extends State<CashFreePaymentStatus> {
  // late final subsckey;
  final subsc = SubscriptionScreen();
  final mycontroller = Get.put(StripePaymentController());

  final StripePaymentController controller = Get.put(StripePaymentController());
  var package_id;

  var selectedPackagePrice;

  @override
  void initState() {
    super.initState();
    // subsckey = GlobalKey<subsc.createState()>();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;

    var discountedPrice = double.parse(widget.package.discountPrice)
        .toStringAsFixed(1);
    var validity =
        "${widget.package.invoicePeriod} ${widget.package.invoiceInterval}";
    var descr =
        widget.package.description ?? "No description Available";
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50,),
              Text("Current Selected Plan",style: TextStyle(fontSize: 18,color: Colors.black87,fontWeight: FontWeight.w400,fontFamily: "ROBOTO"),),

  SizedBox(height: 15,),
              Divider(endIndent: w*0.3,
                color: Colors.blueGrey,
                thickness: 2,
              ),
              SizedBox(
                height: 20,
              ),
          Container(
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
                                "${widget.package.name}",
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
                                text: '₹ ${widget.package.price} ',  // Originally it was price
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



                                    final box  = await GetStorage();
                                    if(await box.read(loggedIn)==null){

                                      await  Fluttertoast.showToast(msg: "Please Sign In to get access to all Features",fontSize: 14,backgroundColor: Colors.grey.shade200,textColor: Colors.black);

                                      Get.to(() => LoginScreen());

                                    }

                                    else{

                                      package_id = widget.package.id;
                                      selectedPackagePrice =
                                          widget.package.price;
                                      print("data ${"subscription_id"}");

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
                                          amount:double.parse(widget.package.discountPrice),orderId: orderId )
                                          .then((value) async {
                                        print("response fropm backend for creation ${value["success"]}");
                                        value!=null?CashfreeServices().CallPaymentScreen(myorderid: orderId,paySessionId: value["success"]["payment_session_id"],package: widget.package,context: context,amount: widget.package.discountPrice):print("Order not created can't make payment");
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
          ),


              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child:Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: mainColor.withOpacity(0.5),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("OR",),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: mainColor.withOpacity(0.5),

                      ),
                    ),
                  ],
                )
              ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.center,
                child: OutlinedButton(
                  onPressed: () {
                    Get.to(() => SubscriptionScreen());
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0))),
                  ),
                  child: const Text(
                    "Explore Plans",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              Divider(indent: w*0.3,
                color: Colors.blueGrey,
                thickness: 2,
              ),

            ],
          ),
        ),
      ),
    );
  }
}
