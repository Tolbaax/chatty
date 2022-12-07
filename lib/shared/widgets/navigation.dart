import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

void navigateTo(context, widget) {
  Navigator.push(
    context,
    PageTransition(
      type: PageTransitionType.fade,
      child: widget,
    ),
  );
}

void navigateAndFinish(context, widget) {
  Navigator.pushAndRemoveUntil(context,
      MaterialPageRoute(builder: (context) => widget), (route) => false);
}
