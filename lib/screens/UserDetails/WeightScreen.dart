import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/WeightController.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';

class WeightScreen extends GetView<WeightController> {
  final WeightController _weightController = Get.put(WeightController());

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWithBack(
        context,
        showBack: true,
        title: "Weight",
      ),
      bottomNavigationBar: bottomNavigationButton(context),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: w * 0.9,
              margin: EdgeInsets.only(top: 20),
              // color: kPrimaryGreen,
              child: Text(
                "Please Select your current Weight",
                style: TextStyle(color: textMuted),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              width: w * 0.55,
              child: ToggleSwitch(
                minWidth: w * 0.2722,
                minHeight: w * 0.15,
                cornerRadius: 10,
                fontSize: 20,
                iconSize: 25,
                activeBgColors: [
                  [mainColor],
                  [secondaryColor]
                ],
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey.shade300,
                inactiveFgColor: Colors.black,
                totalSwitches: 2,
                labels: ['Kgs', 'Lbs'],
                onToggle: (index) {
                  _weightController.weightUnit.value = index!;

                  print(
                      'Selected item Position: ${_weightController.weightUnit.value}');
                },
              ),
            ),
            Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Center(
                  child:
                      Obx(() => newWheel(_weightController.weightUnit.value)),
                ),
                // Obx(()=>getWheel(_HeightController.HeightUnit.value),),

                SizedBox(
                  height: h * 0.6,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return Obx(() => CustomButton(
          buttonColor: _weightController.weightUnit.value == 0
              ? mainColor
              : secondaryColor,
          text: "${_weightController.buttonText}",
          onPressed: () {
            print(
                "Click on ext ${_weightController.selectedWeight.value}_selectedWeight");
            _weightController.goToHeightFun(context);
          },
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        ));
  }

  getWheel(int weightUnit) {
    return Obx(() => Center(
          child: Container(
            height: 150,
            child: ListWheelScrollView(
              itemExtent: 40,
              physics: FixedExtentScrollPhysics(),
              children: List.generate(weightUnit == 0 ? 200 : 500, (index) {
                int weight = index + 30;
                return Center(
                  child: Text(
                    weightUnit == 0
                        ? weight.toString() + ' kg'
                        : weight.toString() + ' lbs',
                    style: TextStyle(
                      fontSize: weight == _weightController.selectedWeight.value
                          ? 22
                          : 20,
                      color: weight == _weightController.selectedWeight.value
                          ? kPrimaryGreen
                          : Colors.grey,
                      fontWeight:
                          weight == _weightController.selectedWeight.value
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                );
              }),
              onSelectedItemChanged: (index) {
                print("se;lect weight $index");
                _weightController.selectWeightStateChange(index);
                // setState(() {
                //   _selectedWeight = index + 30;
                // });
              },
            ),
          ),
        ));
  }

  newWheel(int weightUnit) {
    return Center(
      child: Container(
        width: 125,
        height: 300,
        child: CupertinoPicker(
          backgroundColor: Colors.white,
          useMagnifier: true,
          magnification: 1.05,
          looping: true,
          selectionOverlay: CupertinoPickerDefaultSelectionOverlay(
            background: Colors.transparent,
          ),
          onSelectedItemChanged: (value) {
            _weightController.selectedWeight.value = value + 20;
            print("Valie ${value + 20}");
          },
          itemExtent: 75.0,
          children: List.generate(weightUnit == 0 ? 200 : 500, (index) {
            return Text(
              "${index + 20}",
              style: TextStyle(
                  color: weightUnit == 0 ? mainColor : secondaryColor,
                  fontSize: 48,
                  fontWeight: FontWeight.bold),
            );
          }),
        ),
      ),
    );
  }
}
