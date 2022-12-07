import 'package:buildcondition/buildcondition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/modules/feeds/cubit/cubit.dart';
import 'package:social_app/modules/feeds/cubit/states.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/styles/images.dart';

import '../../shared/widgets/post_item.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({Key? key}) : super(key: key);

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeedsCubit()..getPosts(),
      child: BlocConsumer<FeedsCubit, FeedsStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            body: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .orderBy('time', descending: true)
                  .snapshots(),
              builder: (context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                return BuildCondition(
                  condition:
                      currentUser != null && state is! GetPostsLoadingState,
                  builder: (context) => BuildCondition(
                    condition: snapshot.data!.docs.isNotEmpty,
                    builder: (context) => ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) => BuildPostItem(
                              snapshot: snapshot.data!.docs[index].data(),
                              index: index,
                            ),
                        separatorBuilder: (context, index) => SizedBox(
                              height: 8.h,
                            ),
                        itemCount: FeedsCubit.get(context)
                            .posts
                            .length //snapshot.data!.docs.length,
                        ),
                    fallback: (context) => Center(
                      child: SizedBox(
                        height: 350.h,
                        child: Column(
                          children: [
                            Lottie.asset(
                              ImageAssets.empty,
                              width: double.infinity,
                              height: 250.h,
                            ),
                            Text('No Posts Yet', textScaleFactor: 2.sp),
                          ],
                        ),
                      ),
                    ),
                  ),
                  fallback: (context) => const Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueGrey,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
