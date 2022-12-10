import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../modules/feeds/comments/comments_screen.dart';
import '../../modules/feeds/cubit/cubit.dart';
import '../styles/colors.dart';

class BuildPostItem extends StatefulWidget {
  final Map<String, dynamic> snapshot;
  final int index;
  const BuildPostItem({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  State<BuildPostItem> createState() => _BuildPostItemState();
}

class _BuildPostItemState extends State<BuildPostItem> {
  int commentsLen = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  // TO GET COMMENTS LENGTH
  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snapshot['postId'])
          .collection('comments')
          .get();
      commentsLen = snap.docs.length;
    } catch (e) {
      log(e.toString());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cubit = FeedsCubit.get(context);
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(horizontal: 2.0.sp),
      elevation: cubit.posts[widget.index] == cubit.posts.last ? 4.0 : 20.0,
      child: Padding(
        padding: EdgeInsetsDirectional.only(top: 10.h, bottom: 10.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.sp),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10.sp),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 25.sp,
                          backgroundImage:
                              NetworkImage(widget.snapshot['image']),
                          backgroundColor: Colors.grey.shade100,
                        ),
                        SizedBox(
                          width: 10.0.sp,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 200.w,
                                  child: Text(
                                    widget.snapshot['name'],
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            SizedBox(
                              width: 150.w,
                              child: Row(
                                children: [
                                  Text(
                                    timeago.format(DateTime.parse(
                                        widget.snapshot['time'])),
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: AppColors.grayRegular,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 3.w),
                                    child: Container(
                                      height: 1.8.h,
                                      width: 1.8.w,
                                      decoration: const BoxDecoration(
                                        color: AppColors.grayRegular,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.public,
                                    size: 13.sp,
                                    color: Colors.grey.shade600,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.more_horiz),
                          splashRadius: 20.sp,
                        )
                      ],
                    ),
                  ),
                  if (widget.snapshot['postText'] != '')
                    Padding(
                      padding: EdgeInsets.only(bottom: 5.h),
                      child: Text(
                        widget.snapshot['postText'],
                        style: TextStyle(
                          height: 1.2.h,
                          fontWeight: FontWeight.w600,
                          fontSize: 13.5.sp,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            if (widget.snapshot['postImage'] != '')
              Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                margin: EdgeInsets.only(
                    top: 5, right: 7.0.sp, left: 7.0.sp, bottom: 5.sp),
                elevation: 4.0,
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  foregroundDecoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('${widget.snapshot['postImage']}'),
                    ),
                  ),
                ),
              ),
            SizedBox(
              height: 5.h,
            ),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 5.h, right: 8.0.sp, left: 8.0),
                  child: Row(
                    children: [
                      if (widget.snapshot['likes'].isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.heart_circle_fill,
                              size: 19.sp,
                              color: Colors.red,
                            ),
                            SizedBox(
                              width: 4.sp,
                            ),
                            Text(
                              '${widget.snapshot['likes'].length}',
                              style: TextStyle(
                                color: AppColors.grayRegular,
                                fontSize: 13.sp,
                              ),
                            ),
                          ],
                        ),
                      const Spacer(),
                      if (commentsLen > 0)
                        Text(
                          '$commentsLen comments',
                          style: TextStyle(
                            color: AppColors.grayRegular,
                            fontSize: 13.sp,
                          ),
                        ),
                    ],
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await cubit.likePost(
                          postId: widget.snapshot['postId'],
                          likes: widget.snapshot['likes'],
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            widget.snapshot['likes'].contains(uId)
                                ? CupertinoIcons.heart_solid
                                : CupertinoIcons.heart,
                            size: 18.sp,
                            color: widget.snapshot['likes'].contains(uId)
                                ? Colors.red
                                : AppColors.grayRegular,
                          ),
                          SizedBox(
                            width: 5.sp,
                          ),
                          Text(
                            'Love',
                            style: TextStyle(
                              color: AppColors.grayRegular,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (context) => SizedBox(
                            height: MediaQuery.of(context).size.height * 0.91,
                            child: CommentsScreen(
                              snapshot: widget.snapshot,
                              index: widget.index,
                            ),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            CupertinoIcons.text_bubble,
                            size: 17.sp,
                            color: AppColors.grayRegular,
                          ),
                          SizedBox(
                            width: 5.sp,
                          ),
                          Text(
                            'Comment',
                            style: TextStyle(
                              color: AppColors.grayRegular,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          Icon(
                            Icons.share,
                            size: 17.sp,
                            color: AppColors.grayRegular,
                          ),
                          SizedBox(
                            width: 5.sp,
                          ),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: AppColors.grayRegular,
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
