import 'package:Swasthin/contants/images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/shimmer/gf_shimmer.dart';
import 'package:intl/intl.dart';
import '../../../GlobalWidget/customAppBars.dart';
import '../../../contants/colors.dart';
import '../../../controllers/Subscription Plans/TransactionController.dart';

class TransactionListScreen extends GetView<TransactionController> {
  final TransactionController transactionController =
      Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kPrimaryWhite,
      appBar:
          appBarWithBack(context, showBack: true, title: "Transaction History"),
      body: Obx(() => transactionController.loadingIsOn.value
          ? ShimmerEffect(context)
          : transactionController.noTransactions.value
              ? noTransactionUi(context)
              : getTransactionList(context)),
    );
  }

  noTransactionUi(BuildContext context) {
    return Center(
      child: Text("You have No Transactions to show"),
    );
  }

  getTransactionList(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    var data = transactionController.transactionHistoryModel.data!;
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          var trxId = data[index].transactionId;

          var price = double.parse(data[index].price!) ?? 0.0;
          var date = data[index].date;
          var time = data[index].time;
          DateTime tempDate = new DateFormat("dd/MM/yyyy").parse(date!);
          var finalDate = new DateFormat.yMMMd('en_US').format(tempDate);
          print("date =======> $tempDate v $finalDate");
          var name = data[index].package!.name;
          return Column(
            children: [
              Container(
                width: w,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                // height: h*0.19,
                decoration: BoxDecoration(
                  color: kPrimaryWhite,
                  border: Border.all(
                    color: plansBorderColor, // set border color
                    width: 0.50, // set border width
                  ),
                  borderRadius:
                      BorderRadius.circular(10.0), // set border radius
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Transaction Id :",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: w * 0.025,
                                    color: textExtraMuted)),
                            Text(
                              "$trxId",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: w * 0.035),
                            ),
                          ],
                        ),
                        Text("$finalDate",
                            style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: w * 0.038)),
                        // Container(
                        //   width: w*0.223,
                        //     decoration: BoxDecoration(
                        //       color:  kPrimaryGreen ,
                        //       borderRadius: BorderRadius.all(Radius.circular(500)),
                        //     ),
                        //     child: Container(
                        //       padding: const EdgeInsets.all(8.0),
                        //       child:  Text("Success" , textAlign:TextAlign.center,style: TextStyle(
                        //           fontSize: 10,
                        //           color: Colors.white
                        //       ),),
                        //     )
                        // )
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "₹ ${price.toStringAsFixed(1)}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: w * 0.065),
                            ),
                            SizedBox(
                              height: h * 0.01,
                            ),
                            Container(
                                width: w * 0.5,
                                child: Text(
                                  "$name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: w * 0.045),
                                )),
                            Text("$finalDate, $time",
                                style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: w * 0.03,
                                    color: textExtraMuted)),
                            // SizedBox(height: h*0.01,),
                          ],
                        ),
                        Image.asset(
                          data[index].status == "succeeded"
                              ? successTwoGif
                              : failGif,
                          width: data[index].status == "authorized"
                              ? w * 0.2
                              : w * 0.16,
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(),
              )
            ],
          );
        });
  }

  Widget ShimmerEffect(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            child: GFShimmer(
              mainColor: Colors.grey.shade200,
              secondaryColor: Colors.grey.shade300,
              child: Container(
                height: h * 0.19,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    color: Colors.white),
                // color: Colors.grey.shade200,
                child: Card(
                  elevation: 15.5,
                ),
              ),
            ),
          );
        });
  }
}
