import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../contants/colors.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField(
      {Key? key,
        this.controller,
        this.icon,
        this.formatters,
        required this.hintText,
        required this.inputType,
        this.showText = true,
        this.topPadding = 0,
        this.maxLength = 50,
        this.bottomPadding = 0,
        this.suffixIcon,
        this.onTap,
        this.onEditingComplete,
        this.enabled = true, this.showLabel = false, this.label, this.validator, this.suffixWidget})
      : super(key: key);

  final TextEditingController? controller;
  final IconData? icon;
  final String hintText;
  final Function()? onTap;
  final Function(String text)? onEditingComplete;
  final TextInputType inputType;
  final bool showText;
  final bool enabled;
  final double? topPadding;
  final int? maxLength;
  final double? bottomPadding;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final bool showLabel;
  final String? label;
  final List<TextInputFormatter>? formatters;
  final String? Function(String?)? validator;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
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
                margin: const EdgeInsets.symmetric(vertical: 2),
                child: Text(widget.label!, style: const TextStyle(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400),),
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
                      child: InkWell(
                        child: TextFormField(
                          onChanged: widget.onEditingComplete,
                          // onEditingComplete: widget.onEditingComplete,
                          maxLength: widget.maxLength,
                          showCursor: true,
                          enabled: widget.enabled,
                          obscureText: !widget.showText,
                          keyboardType: widget.inputType,
                          controller: widget.controller,
                          validator: widget.validator,
                          inputFormatters: (widget.formatters == null) ? null : widget.formatters,
                          decoration: InputDecoration(
                            counterText: "",
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
                              hintStyle: TextStyle(color: kHintText, fontWeight: FontWeight.w400)),
                        ),
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