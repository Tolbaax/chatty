import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/layout/cubit/cubit.dart';
import 'package:social_app/shared/styles/colors.dart';

class DefaultButton extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;
  final Color? color;
  const DefaultButton({
    Key? key,
    required this.title,
    this.onTap,
    this.color = AppColors.darkBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        width: 250.w,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15.r),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0.sp,
              letterSpacing: 1,
            ),
          ),
        ),
      ),
    );
  }
}

class BuildCameraIcon extends StatelessWidget {
  final VoidCallback? onPressed;
  const BuildCameraIcon({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: CircleAvatar(
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade400,
                blurRadius: 1.0.r,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 80.r,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.camera_alt_outlined,
              color: AppColors.darkBlue,
              size: 15.h,
            ),
          ),
        ),
      ),
      splashRadius: 20,
    );
  }
}

class BottomTabBar extends StatelessWidget {
  final IconData icon;
  final Function onPressed;
  final int index;
  const BottomTabBar({
    Key? key,
    required this.icon,
    required this.onPressed,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        onPressed(index);
      },
      iconSize: 25.0,
      icon: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            icon,
            color: LayoutCubit.get(context).currentIndex == index
                ? Colors.blueGrey.shade600
                : Colors.grey,
          ),
          if (LayoutCubit.get(context).currentIndex == index)
            Container(
              height: 1.h,
              width: 18.w,
              decoration: const BoxDecoration(
                color: AppColors.tealBlue,
              ),
            ),
        ],
      ),
    );
  }
}
