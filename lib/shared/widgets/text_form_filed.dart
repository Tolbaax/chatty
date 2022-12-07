import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DefaultTextFormFiled extends StatelessWidget {
  final String? hintText;
  final bool secure;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final FormFieldValidator? validator;
  final String? label;
  final FormFieldSetter? onSaved;
  final Function()? onTab;
  final Function()? suffixTab;
  final IconData? suffix;
  final TextInputAction? textInputAction;
  final Widget? prefixIcon;
  const DefaultTextFormFiled({
    Key? key,
    this.hintText,
    this.secure = false,
    this.inputType,
    this.controller,
    this.validator,
    this.label,
    this.suffix,
    this.onTab,
    this.suffixTab,
    this.onSaved,
    this.prefixIcon,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: inputType,
      obscureText: secure,
      controller: controller,
      onSaved: onSaved,
      onTap: onTab,
      validator: validator,
      textInputAction: textInputAction,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: prefixIcon,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade700),
        hintText: hintText,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 15.sp, vertical: 17.sp),
        suffixIcon: GestureDetector(
          onTap: suffixTab,
          child: Icon(suffix),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0.r),
          borderSide: const BorderSide(color: Colors.blue),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0.r),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }
}
