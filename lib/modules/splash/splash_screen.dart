import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/layout/layout_screen.dart';
import 'package:social_app/modules/login/login_screen.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/styles/images.dart';
import 'package:social_app/shared/widgets/navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      const Duration(milliseconds: 2500),
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
      appBar: AppBar(),
      body: Center(
        child: Lottie.asset(ImageAssets.splash),
      ),
    );
  }
}
