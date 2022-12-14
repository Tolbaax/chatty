import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../layout/layout_screen.dart';
import '../../shared/resources/global.dart';
import '../../shared/styles/images.dart';
import '../../shared/widgets/navigation.dart';
import '../login/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(milliseconds: 2000),
      () {
        if (uId != null) {
          navigateAndFinish(context, const LayoutScreen());
        } else {
          navigateAndFinish(context, const LoginScreen());
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImageAssets.splashLogo, width: 210.w),
      ),
    );
  }
}
