import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:social_app/shared/styles/colors.dart';

void showToast({
  required String text,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

// enum
enum ToastState { success, error, warning }

Color? chooseToastColor(ToastState state) {
  Color? color;

  switch (state) {
    case ToastState.success:
      color = AppColors.darkBlue.withOpacity(0.8);
      break;
    case ToastState.error:
      break;
    case ToastState.warning:
      break;
  }

  switch (state) {
    case ToastState.error:
      color = Colors.red;
      break;
    case ToastState.success:
      break;
    case ToastState.warning:
      break;
  }

  switch (state) {
    case ToastState.warning:
      color = Colors.orangeAccent;
      break;
    case ToastState.success:
      break;
    case ToastState.error:
      break;
  }

  return color;
}
