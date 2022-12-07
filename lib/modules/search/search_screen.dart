import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../shared/widgets/text_form_filed.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.sp),
          child: Column(
            children: [
              const DefaultTextFormFiled(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
              ),
              Expanded(
                child: Lottie.network(
                    'https://assets6.lottiefiles.com/packages/lf20_l5qvxwtf.json'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
