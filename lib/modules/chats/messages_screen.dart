import 'package:buildcondition/buildcondition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:social_app/modules/chats/cubit/states.dart';
import 'package:social_app/network/models/chat_model.dart';
import 'package:social_app/network/models/user_model.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/styles/images.dart';

import '../../network/services/notification_service.dart';
import '../../shared/styles/colors.dart';
import 'cubit/cubit.dart';

class ChatDetailsScreen extends StatelessWidget {
  final UserModel userModel;

  const ChatDetailsScreen({Key? key, required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var messageController = TextEditingController();
    return Builder(builder: (context) {
      String? fcmToken = '';
      ChatsCubit.get(context).getMessages(receiverId: userModel.uID!);
      try {
        FirebaseFirestore.instance.collection('users').get().then(
          (value) {
            for (var element in value.docs) {
              fcmToken = element.data()['fcmToken'];
            }
          },
        );
      } catch (e) {
        fcmToken = '';
      }
      return BlocConsumer<ChatsCubit, ChatStates>(
        listener: (context, state) {},
        builder: (context, state) {
          final cubit = ChatsCubit.get(context);
          return SafeArea(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ImageAssets.chatBackgroundImage),
                  fit: BoxFit.fill,
                ),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: SizedBox(
                    width: 200.w,
                    child: Center(
                      child: Text(
                        '${userModel.name}',
                        style: TextStyle(color: Colors.white, fontSize: 20.sp),
                        overflow: TextOverflow.clip,
                      ),
                    ),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back_ios),
                    color: Colors.white,
                  ),
                  backgroundColor: AppColors.darkBlue.withOpacity(0.5),
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      BuildCondition(
                        condition: cubit.messages.isNotEmpty,
                        builder: (context) {
                          return Expanded(
                            child: ListView.separated(
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                var message = cubit.messages[index];
                                if (uId == message.senderId) {
                                  return SenderMessage(
                                    chatModel: message,
                                  );
                                } else {
                                  return ReceiverMessage(
                                    chatModel: message,
                                  );
                                }
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 10.h),
                              itemCount: cubit.messages.length,
                            ),
                          );
                        },
                        fallback: (context) => Center(
                          child: Column(
                            children: [
                              Lottie.asset(ImageAssets.noMessages),
                              SizedBox(
                                height: 30.h,
                              ),
                              Text(
                                'No messages here yet',
                                style: TextStyle(fontSize: 18.sp),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.only(
                          bottom: 10.0.sp,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding:
                                    EdgeInsets.only(left: 15.w, bottom: 2.sp),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25.r),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: 200.w,
                                      child: TextFormField(
                                        controller: messageController,
                                        keyboardType: TextInputType.multiline,
                                        maxLines: 5,
                                        minLines: 1,
                                        decoration: const InputDecoration(
                                          hintText: 'Type a message...',
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                          CupertinoIcons.camera_fill),
                                      splashRadius: 5.0.sp,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 6.0.sp,
                            ),
                            CircleAvatar(
                              radius: 20.0.sp,
                              backgroundColor: const Color(0xFF128c7e),
                              child: IconButton(
                                onPressed: () async {
                                  String message = messageController.text;
                                  if (messageController.text.isNotEmpty ||
                                      messageController.text.length > 1) {
                                    ChatsCubit.get(context).sendMessage(
                                      receiverId: userModel.uID!,
                                      dateTime: DateTime.now(),
                                      text: messageController.text,
                                    );

                                    await LocalNotificationService
                                        .sendNotification(
                                      title: '${currentUser!.name}',
                                      message: message,
                                      token: fcmToken,
                                    );

                                    messageController.clear();
                                  }
                                },
                                icon: const Icon(Icons.send),
                                splashRadius: 5.0.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      );
    });
  }
}

class SenderMessage extends StatelessWidget {
  final ChatModel chatModel;

  const SenderMessage({Key? key, required this.chatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 50.sp),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFdcf8c6),
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(15.sp),
              bottomStart: Radius.circular(15.sp),
              bottomEnd: Radius.circular(15.sp),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.0.sp),
          child: Text(
            '${chatModel.text}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}

class ReceiverMessage extends StatelessWidget {
  final ChatModel chatModel;

  const ReceiverMessage({Key? key, required this.chatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 50.sp),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(15.sp),
              topEnd: Radius.circular(15.sp),
              bottomStart: Radius.circular(15.sp),
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.0.sp),
          child: Text(
            '${chatModel.text}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}
