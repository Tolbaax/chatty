import 'dart:io';

import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_app/modules/feeds/cubit/cubit.dart';
import 'package:social_app/modules/post/cubit/cubit.dart';
import 'package:social_app/modules/post/cubit/states.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/widgets/show_toast.dart';

import '../../shared/styles/colors.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPostCubit, AddPostStates>(
      listener: (context, state) {
        final cubit = AddPostCubit.get(context);

        if (state is CreatePostSuccessState) {
          cubit.postTextController.clear();
          cubit.postImage = null;
          Navigator.pop(context,
              BlocProvider(create: (context) => FeedsCubit()..getPosts()));
          showToast(
              text: 'Post Created Successfully', state: ToastState.success);
        }
      },
      builder: (context, state) {
        final cubit = AddPostCubit.get(context);

        final userModel = currentUser;
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_ios),color: AppColors.grayRegular,),
            titleSpacing: 0.0,
            title: const Text(
              'Create Post',
              style: TextStyle(
                color: AppColors.grayRegular,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    cubit.postImage == null
                        ? cubit.createNewPost()
                        : cubit.uploadPostImage();
                  },
                  child: const Text(
                    'POST',
                    style: TextStyle(fontSize: 17),
                  )),
              SizedBox(
                width: 10.w,
              )
            ],
          ),
          body: BuildCondition(
            condition: userModel != null,
            builder: (context) => Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: Column(
                children: [
                  if (state is CreatePostLoadingState)
                    const LinearProgressIndicator(
                      color: AppColors.darkBlue,
                    ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 25.sp,
                        backgroundImage:
                            NetworkImage(userModel!.image.toString()),
                      ),
                      SizedBox(
                        width: 20.0.sp,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: 25.w),
                          child: Text(
                            userModel.name.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  TextFormField(
                    controller: cubit.postTextController,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value.toString().isEmpty) {
                        return 'post must not be empty';
                      } else if (value.toString().length < 3) {
                        return 'post must contain at least 3 characters';
                      }
                      return null;
                    },
                    maxLines: 7,
                    decoration: const InputDecoration(
                      hintText: 'What\'s on your mind?',
                      border: InputBorder.none,
                      filled: true,
                    ),
                  ),
                  SizedBox(
                    height: 80.h,
                  ),
                  if (cubit.postImage != null)
                    Expanded(
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(10.r),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: FileImage(
                                  File(cubit.postImage!.path),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              cubit.removePostImage();
                            },
                            icon: const CircleAvatar(
                                backgroundColor: Colors.blueGrey,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                )),
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  if (cubit.postImage == null) const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            cubit.getPostImage();
                          },
                          child: Row(
                            children: [
                              const Icon(CupertinoIcons.photo_on_rectangle),
                              SizedBox(
                                width: 10.w,
                              ),
                              const Text('Photo')
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              const Text('#Tags')
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            fallback: (context) => const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            ),
          ),
        );
      },
    );
  }
}
