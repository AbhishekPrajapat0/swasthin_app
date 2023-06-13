import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../contants/colors.dart';



class CustomTextFormFieldProfileUpdate extends StatefulWidget {
  const CustomTextFormFieldProfileUpdate(
      {Key? key,
        this.controller,
        this.icon,
        required this.textHintColor,
        this.formatters,
        required this.hintText,
        // required this.text,
        required this.inputType,
        this.showText = true,
        this.topPadding = 0,
        this.bottomPadding = 0,
        this.maxLength = 100,
        this.suffixIcon,
        this.onTap,
        this.onTapEdit,
        this.enabled = true,
        this.showLabel = false,
        this.showEditIcon = false,
        this.label,
        this.validator,
        this.suffixWidget,
        required this.labelColor,
        required this.showLabel2, this.label2,
        // required this.label2Color
      })
      : super(key: key);

  final TextEditingController? controller;
  final IconData? icon;
  final String hintText;
  // final String text;
  final Function()? onTap;
  final Function()? onTapEdit;
  final TextInputType inputType;
  final bool showText;
  final bool enabled;
  final bool textHintColor;
  final double? topPadding;
  final double? bottomPadding;
  final double? maxLength;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final bool showLabel;
  final bool showLabel2;
  final bool showEditIcon;
  final String? label;
  final String? label2;
  final Color labelColor;
  // final Color label2Color;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;

  @override
  State<CustomTextFormFieldProfileUpdate> createState() => _CustomTextFormFieldProfileUpdateState();
}

class _CustomTextFormFieldProfileUpdateState extends State<CustomTextFormFieldProfileUpdate> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding!, bottom: widget.bottomPadding!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.showLabel)Row(
            children: [
              SizedBox(width: w*0.03,),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child:  RichText(
                  text: TextSpan(
                    text: widget.label!,
                    style:TextStyle(fontSize: 12, color: widget.labelColor, fontWeight: FontWeight.w400),
                    children:  <TextSpan>[
                      widget.showLabel2 ? TextSpan(text: widget.label2!, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)) : TextSpan(text: "",)
                    ],
                  ),
                ),
              ),

            ],
          ),
          SizedBox(
            height: h*0.1,
            child: Stack(
              children: [
                Container(
                  height: w*0.14,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: (widget.icon == null) ? 20 : 0),
                      child: Stack(
                        children: [
                          Center(
                            child: TextFormField(
                            showCursor: true,
                            enabled: widget.enabled,
                            obscureText: !widget.showText,
                            keyboardType: widget.inputType,
                            controller: widget.controller,
                            validator: widget.validator,
                            // initialValue: widget.text,
                            inputFormatters: (widget.formatters == null) ? null : widget.formatters,
                            decoration: InputDecoration(
                                helperText: ' ',
                                border: InputBorder.none,
                                prefixIcon: (widget.icon != null)
                                    ? Icon(
                                  widget.icon,
                                  color: Colors.grey,
                                )
                                    : null,
                                suffixIcon: widget.suffixWidget ?? ((widget.suffixIcon != null)
                                    ? IconButton(icon: Icon(widget.suffixIcon, color: kHintText,), onPressed: widget.onTap,)
                                    : null),
                                hintText: widget.hintText,
                                hintStyle: TextStyle(
                                    color: widget.textHintColor ? kPrimaryBlack : kHintText
                                    , fontWeight: FontWeight.w400 )),
                        ),
                          ),

                          widget.showEditIcon ?  Positioned(
                              right: 0,
                              top: 5,
                              child: IconButton(onPressed: widget.onTapEdit,icon: Icon(Icons.edit),)
                          ): Container()

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class CustomTextFormFieldHeight extends StatefulWidget {
  const CustomTextFormFieldHeight(
      {Key? key,
        this.controller,
        this.icon,
        required this.textHintColor,
        this.formatters,
        required this.hintText,
        // required this.text,
        required this.inputType,
        this.showText = true,
        this.topPadding = 0,
        this.bottomPadding = 0,
        this.suffixIcon,
        this.onTap,
        this.enabled = true, this.showLabel = false, this.label, this.validator, this.suffixWidget, required this.labelColor, this.maxLimit,
        required this.showLabel2, this.label2,})
      : super(key: key);

  final TextEditingController? controller;
  final IconData? icon;
  final String hintText;
  // final String text;
  final Function()? onTap;
  final TextInputType inputType;
  final bool showText;
  final bool enabled;
  final bool textHintColor;
  final double? topPadding;
  final int? maxLimit;
  final double? bottomPadding;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final bool showLabel;
  final bool showLabel2;
  final String? label;
  final String? label2;
  final Color labelColor;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;



  @override
  State<CustomTextFormFieldHeight> createState() => _CustomTextFormFieldHeight();
}

class _CustomTextFormFieldHeight extends State<CustomTextFormFieldHeight> {
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    return Padding(
      padding: EdgeInsets.only(top: widget.topPadding!, bottom: widget.bottomPadding!),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(widget.showLabel)Row(
            children: [
              SizedBox(width: w*0.03,),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: RichText(
                  text: TextSpan(
                    text: widget.label!,
                    style:TextStyle(fontSize: 12, color: widget.labelColor, fontWeight: FontWeight.w400),
                    children:  <TextSpan>[
                      widget.showLabel2 ? TextSpan(text: widget.label2!, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red)) : TextSpan(text: "",)
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: h*0.1,
            child: Stack(
              children: [
                Container(
                  height: w*0.14,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Center(
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: (widget.icon == null) ? 20 : 0),
                      child: TextFormField(
                        showCursor: true,
                        enabled: widget.enabled,
                        obscureText: !widget.showText,
                        keyboardType: widget.inputType,
                        controller: widget.controller,
                        maxLength: widget.maxLimit,
                        validator: widget.validator,
                        // initialValue: widget.text,
                        inputFormatters: (widget.formatters == null) ? null : widget.formatters,
                        decoration: InputDecoration(
                            helperText: ' ',
                            border: InputBorder.none,
                            prefixIcon: (widget.icon != null)
                                ? Icon(
                              widget.icon,
                              color: Colors.grey,
                            )
                                : null,
                            suffixIcon: widget.suffixWidget ?? ((widget.suffixIcon != null)
                                ? IconButton(icon: Icon(widget.suffixIcon, color: kHintText,), onPressed: widget.onTap,)
                                : null),
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                                color: widget.textHintColor ? kPrimaryBlack : kHintText
                                , fontWeight: FontWeight.w400 )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}