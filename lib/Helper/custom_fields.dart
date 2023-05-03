import 'package:blind_date/Helper/Color.dart';
import 'package:flutter/material.dart';

class CustomFields extends StatelessWidget {
  final TextEditingController? controller;
  final String? title;
  final int? mxLength;
  final TextInputType? keyboard;
  final String? Function(String?)? validate;
  final double? width;
  final double? height;
  const CustomFields({Key? key, this.controller, this.title, this.mxLength, this.keyboard, this.validate, this.width, this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.only(left: 15, top: 8, bottom: 4),
      height: height != 0 ? height : 50,
      // decoration: BoxDecoration(
      //     color: Theme.of(context).colorScheme.lightWhite,
      //     borderRadius: BorderRadius.circular(50),
      //     border: Border.all(color: colors.primary)
      // ),
      // width: width != 0 ? width : MediaQuery.of(context).size.width,
      child: TextFormField(
        style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor),
        keyboardType: keyboard,
        maxLength: mxLength,
        controller: controller,
        validator: validate,
        decoration: InputDecoration(
          focusColor: colors.primary,
            counterText: '',
            // border: InputBorder.none,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: colors.primary, width: 1),
              borderRadius: BorderRadius.circular(60)
            ),
            hintText: title,
          hintStyle: TextStyle(
            fontWeight: FontWeight.w400
          )
        ),
      ),
    );
  }
}
