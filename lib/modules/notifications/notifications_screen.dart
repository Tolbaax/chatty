import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/shared/styles/colors.dart';

import '../../shared/styles/images.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(fontSize: 20.0.sp),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(ImageAssets.notifications),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 15.h),
                child: Text(
                  'No notifications yet!',
                  style: TextStyle(
                    fontSize: 20.0.sp,
                    color: AppColors.grayRegular,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
