import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/shared/styles/colors.dart';

import '../resources/global.dart';

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
  final ValueChanged<String>? onFiledSubmitted;
  final ValueChanged<String>? onChanged;
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
    this.onFiledSubmitted,
    this.onChanged,
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
      onFieldSubmitted: onFiledSubmitted,
      onChanged: onChanged,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        fillColor: Colors.white,
        filled: true,
        prefixIcon: prefixIcon,
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey.shade700),
        hintText: hintText,
        contentPadding:
            EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
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

class CustomTextFiled extends StatelessWidget {
  final TextEditingController controller;
  final cubit;
  final snapshot;
  const CustomTextFiled(
      {Key? key,
      required this.controller,
      required this.cubit,
      required this.snapshot})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 15.w),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25.r),
              border: Border.all(color: AppColors.grayRegular),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 200.w,
                  child: TextFormField(
                    controller: controller,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    minLines: 1,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(CupertinoIcons.camera_fill),
                  splashRadius: 5.0.sp,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          width: 6.0.sp,
        ),
        CircleAvatar(
          radius: 20.0.sp,
          backgroundColor: Colors.blueGrey,
          child: IconButton(
            onPressed: () async {
              if (controller.text.isNotEmpty || controller.text.length > 1) {
                await cubit.postComment(
                  postId: snapshot['postId'],
                  name: currentUser!.name,
                  text: controller.text,
                  profilePic: currentUser!.image,
                );
                controller.clear();
              }
            },
            icon: const Icon(Icons.send),
            splashRadius: 5.0.sp,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
