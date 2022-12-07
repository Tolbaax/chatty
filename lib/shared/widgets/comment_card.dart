import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timeago/timeago.dart' as timeago;

class CommentCard extends StatelessWidget {
  final Map<String, dynamic> snapshot;

  const CommentCard({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 20.sp,
          backgroundImage: NetworkImage(snapshot['profilePic']),
        ),
        SizedBox(width: 8.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: Container(
                  width: 240.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    color: Colors.blueGrey.shade100.withOpacity(0.4),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.sp, vertical: 5.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot['name'],
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14.5.sp),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        snapshot['text'],
                        textWidthBasis: TextWidthBasis.parent,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                      ),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(start: 5.sp, top: 4),
              child: Text(
                timeago.format(DateTime.parse(
                  snapshot['datePublished'],
                )),
                style: TextStyle(fontSize: 12.sp),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
