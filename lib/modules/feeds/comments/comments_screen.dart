import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/feeds/cubit/cubit.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/widgets/comment_card.dart';
import 'package:social_app/shared/widgets/text_form_filed.dart';

class CommentsScreen extends StatelessWidget {
  final Map<String, dynamic> snapshot;
  final int index;

  const CommentsScreen({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();
    final cubit = FeedsCubit.get(context);
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: AppColors.grayRegular,
        ),
        title: const Text(
          'Comments',
          style: TextStyle(color: AppColors.grayRegular),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.0.sp, vertical: 10.0.sp),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .doc(snapshot['postId'])
                    .collection('comments')
                    .orderBy('datePublished', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.hasError ||
                      snapshot.data!.docs.isEmpty ||
                      snapshot.connectionState == ConnectionState.none) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.chat_bubble_text,
                            size: 135.sp,
                            color: Colors.grey.shade400.withOpacity(0.8),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            'No Comments Yet',
                            style: TextStyle(
                              fontSize: 22.sp,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            'Be the first to comment',
                            style: TextStyle(fontSize: 16.sp),
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                        ],
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 10.h),
                      child: CommentCard(
                        snapshot:
                            (snapshot.data! as dynamic).docs[index].data(),
                      ),
                    ),
                  );
                },
              ),
            ),
            CustomTextFiled(
              controller: commentController,
              cubit: cubit,
              snapshot: snapshot,
            ),
          ],
        ),
      ),
    );
  }
}
