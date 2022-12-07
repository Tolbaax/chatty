import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/shared/styles/colors.dart';

class LogoContainer extends StatelessWidget {
  const LogoContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      width: 80.w,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0.r),
            bottomRight: Radius.circular(20.0.r),
            bottomLeft: Radius.circular(20.0.r),
          )),
      child: Center(
        child: Container(
          height: 40.h,
          width: 40.w,
          decoration: BoxDecoration(
              color: AppColors.darkBlue,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30.0.r),
                topLeft: Radius.circular(30.0.r),
                bottomRight: Radius.circular(30.0.r),
              )),
        ),
      ),
    );
  }
}
