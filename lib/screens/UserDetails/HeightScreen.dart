import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/HeightController.dart';
import '../../screens/UserDetails/ActivityLevel.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../GlobalWidget/CustomButton.dart';
import '../../GlobalWidget/customAppBars.dart';
import '../../contants/colors.dart';

class HeightScreen extends GetView<HeightController> {
  final HeightController _HeightController = Get.put(HeightController());

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWithBack(
        context,
        showBack: true,
        title: "Height",
      ),
      bottomNavigationBar: bottomNavigationButton(context),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: w * 0.9,
            margin: EdgeInsets.only(top: 20),
            // color: kPrimaryGreen,
            child: Text(
              "Please Select your current Height",
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
              labels: ['cm', 'ft'],
              onToggle: (index) {
                _HeightController.heightUnit.value = index!;
                print(
                    'Selected item Position: ${_HeightController.heightUnit.value}');
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.only(top: h * 0.1),
            child: Center(
              child: Obx(
                () => _heightSelector(),
              ),
            ),
          ),
          // Obx(()=>getWheel(_HeightController.HeightUnit.value),),
        ],
      ),
    );
  }

  bottomNavigationButton(BuildContext context) {
    return Obx(() => CustomButton(
          text: _HeightController.buttonText.value,
          onPressed: () async {
            print(
                "Click on ext ${_HeightController.selectedHeight.value}_selectedHeight");
            await _HeightController.goToNextScreen(context);
          },
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 18),
        ));
  }

  getWheel(int HeightUnit) {
    return Obx(() => Center(
          child: Container(
            height: 150,
            child: ListWheelScrollView(
              itemExtent: 40,
              physics: FixedExtentScrollPhysics(),
              children: List.generate(HeightUnit == 0 ? 200 : 500, (index) {
                var Height = index - 0.5 + 30;
                return Center(
                  child: Text(
                    HeightUnit == 0
                        ? Height.toString() + ' cm'
                        : Height.toString() + ' ft',
                    style: TextStyle(
                      fontSize: Height == _HeightController.selectedHeight.value
                          ? 22
                          : 20,
                      color: Height == _HeightController.selectedHeight.value
                          ? kPrimaryGreen
                          : Colors.grey,
                      fontWeight:
                          Height == _HeightController.selectedHeight.value
                              ? FontWeight.bold
                              : FontWeight.normal,
                    ),
                  ),
                );
              }),
              onSelectedItemChanged: (index) {
                print("select Height $index");
                _HeightController.selectHeightStateChange(index);
                // setState(() {
                //   _selectedHeight = index + 30;
                // });
              },
            ),
          ),
        ));
  }

  _heightSelector() {
    if (_HeightController.heightUnit.value == 1) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
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
                    print("selected height in ft is $value \'");
                    _HeightController.heightft.value = value;
                  },
                  itemExtent: 75.0,
                  children: List.generate(14, (index) {
                    return Text(
                      "$index '",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              ),
              Container(
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
                    print("selected height in ft is $value \"");
                    _HeightController.heightInch.value = value;
                  },
                  itemExtent: 75.0,
                  children: List.generate(12, (index) {
                    return Text(
                      "$index \"",
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 48,
                          fontWeight: FontWeight.bold),
                    );
                  }),
                ),
              )
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
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
                _HeightController.selectedHeight.value = value + 80;
                print("selected height in  is ${value + 80} \"");
              },
              itemExtent: 75.0,
              children: List.generate(381, (index) {
                index += 80;
                return Text(
                  "$index",
                  style: TextStyle(
                      color: mainColor,
                      fontSize: 48,
                      fontWeight: FontWeight.bold),
                );
              }),
            ),
          ),
        ],
      );
    }
  }
}
