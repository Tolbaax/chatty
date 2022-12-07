import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../layout/cubit/cubit.dart';

class SignOut extends StatelessWidget {
  const SignOut({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  'Sign Out',
                ),
                content: Text(
                  'Are you sure want to exit?',
                  style: TextStyle(fontSize: 14.sp),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'No',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      LayoutCubit.get(context).signOut(context);
                    },
                    child: const Text(
                      'Yes',
                    ),
                  ),
                ],
              );
            });
      },
      icon: const Icon(Icons.logout),
    );
  }
}
