import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/feeds/cubit/cubit.dart';
import 'package:social_app/modules/feeds/cubit/states.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/styles/colors.dart';
import 'package:social_app/shared/widgets/comment_card.dart';

class CommentsScreen extends StatelessWidget {
  final Map<String, dynamic> snapshot;
  final int index;

  const CommentsScreen({Key? key, required this.snapshot, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentController = TextEditingController();
    return BlocConsumer<FeedsCubit, FeedsStates>(
      listener: (context, state) {},
      builder: (context, state) {
        final cubit = FeedsCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back_ios),
              color: AppColors.grayRegular,
            ),
            titleSpacing: 0.0,
            title: const Text(
              'Comments',
              style: TextStyle(color: AppColors.grayRegular),
            ),
            centerTitle: true,
          ),
          body: Column(
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
                      return Column(
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
                      );
                    }
                    return ListView.builder(
                      itemCount: (snapshot.data! as dynamic).docs.length,
                      itemBuilder: (context, index) => Padding(
                        padding: EdgeInsets.only(
                          right: 10.0.w,
                          left: 20.0.w,
                          top: 10.h,
                        ),
                        child: CommentCard(
                          snapshot:
                              (snapshot.data! as dynamic).docs[index].data(),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 45.h,
                margin: EdgeInsets.symmetric(vertical: 8.h, horizontal: 10.w),
                padding: EdgeInsets.only(
                  left: 16.w,
                  right: 8.w,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30.r),
                    border: Border.all(color: AppColors.grayRegular)),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: commentController,
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Type a message...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await cubit.postComment(
                          postId: snapshot['postId'],
                          name: currentUser!.name,
                          text: commentController.text,
                          profilePic: currentUser!.image,
                        );
                        commentController.clear();
                      },
                      icon: const Icon(Icons.send),
                      splashRadius: 5.0.sp,
                      color: Colors.blue.shade700,
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
