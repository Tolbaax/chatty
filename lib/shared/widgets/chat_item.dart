import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:page_transition/page_transition.dart';
import 'package:social_app/modules/chats/messages_screen.dart';
import 'package:social_app/network/models/user_model.dart';
import 'package:social_app/shared/styles/colors.dart';

class BuildChatItem extends StatelessWidget {
  final UserModel userModel;

  const BuildChatItem({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            type: PageTransitionType.fade,
            child: ChatDetailsScreen(userModel: userModel),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.only(top: 15.0.sp, left: 20.0.sp, right: 20.0.sp),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 26.sp,
                backgroundImage: NetworkImage(userModel.image.toString())),
            SizedBox(
              width: 8.w,
            ),
            Center(
              child: Text(
                '${userModel.name}',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
            ),
            const Spacer(),
            const Text(
              '3:25',
              style: TextStyle(color: AppColors.grayRegular),
            ),
          ],
        ),
      ),
    );
  }
}
