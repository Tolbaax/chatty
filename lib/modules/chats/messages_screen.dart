import 'dart:io';

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
    final ScrollController scrollController = ScrollController();
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
                  backgroundColor: AppColors.darkBlue.withOpacity(0.45),
                ),
                body: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.0.sp),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BuildCondition(
                        condition: cubit.messages.isNotEmpty,
                        builder: (context) {
                          return Expanded(
                            child: ListView.separated(
                              controller: scrollController,
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
                        fallback: (context) => Column(
                          children: [
                            SizedBox(
                              height: 110.h,
                            ),
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
                      if (cubit.chatImage != null &&
                          cubit.chatImage!.isNotEmpty) ...{
                        Container(
                          height: 100.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.grayRegular.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) => Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image(
                                          width: 110.w,
                                          height: 150.h,
                                          fit: BoxFit.fill,
                                          image: FileImage(File(
                                              cubit.chatImage![index].path)),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          cubit.removeImageFromMessage(index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: CircleAvatar(
                                            backgroundColor:
                                                Colors.grey.withOpacity(0.8),
                                            radius: 15,
                                            child: Icon(
                                              Icons.close,
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    width: 5,
                                  ),
                              itemCount: cubit.chatImage!.length),
                        ),
                      },
                      Column(
                        children: [
                          if (state is UploadMessageImageLoadingState)
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 4.0, top: 8, right: 10, left: 10),
                              child: LinearProgressIndicator(
                                color: const Color(0xFF128c7e),
                                backgroundColor:
                                    const Color(0xFF128c7e).withOpacity(0.2),
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
                                    padding: EdgeInsets.only(
                                        left: 15.w, bottom: 2.sp),
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 200.w,
                                          child: TextFormField(
                                            controller: messageController,
                                            keyboardType:
                                                TextInputType.multiline,
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
                                          onPressed: () {
                                            cubit.getChatImage();
                                          },
                                          icon: const Icon(
                                              CupertinoIcons.photo_fill),
                                          splashRadius: 5.0.sp,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(
                                          width: 8.w,
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
                                      if (cubit.chatImage == null) {
                                        if (messageController.text.isNotEmpty) {
                                          ChatsCubit.get(context).sendMessage(
                                            receiverId: userModel.uID!,
                                            dateTime: DateTime.now(),
                                            text: messageController.text,
                                            messageImage: [],
                                          );

                                          await LocalNotificationService
                                              .sendNotification(
                                            title: '${currentUser!.name}',
                                            message: message,
                                            token: fcmToken,
                                          );

                                          messageController.clear();
                                        }
                                      } else {
                                        if (cubit.chatImage != null) {
                                          cubit
                                              .sendMessageWithImages(
                                            receiverId: userModel.uID!,
                                            dateTime: DateTime.now(),
                                            text: messageController.text,
                                          )
                                              .then((value) async {
                                            await LocalNotificationService
                                                .sendNotification(
                                              title: '${currentUser!.name}',
                                              message:
                                                  messageController.text.isEmpty
                                                      ? 'Image..'
                                                      : message,
                                              token: fcmToken,
                                            );
                                            messageController.clear();
                                          });
                                        }
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
    return Column(
      children: [
        if (chatModel.text != null && chatModel.text != '')
          Padding(
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
                padding:
                    EdgeInsets.symmetric(vertical: 8.sp, horizontal: 10.0.sp),
                child: Text(
                  '${chatModel.text}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        if (chatModel.messageImage != null &&
            chatModel.messageImage!.isNotEmpty)
          Directionality(
            textDirection: TextDirection.rtl,
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: 80.sp),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemBuilder: (context, index) => Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0, color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(
                      chatModel.messageImage![index],
                      fit: BoxFit.fill,
                      height: 150,
                      width: 150,
                    )),
                itemCount: chatModel.messageImage!.length,
              ),
            ),
          ),
      ],
    );
  }
}

class ReceiverMessage extends StatelessWidget {
  final ChatModel chatModel;

  const ReceiverMessage({Key? key, required this.chatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (chatModel.text != null && chatModel.text != '')
          Align(
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
                padding:
                    EdgeInsets.symmetric(vertical: 10.sp, horizontal: 10.0.sp),
                child: Text(
                  '${chatModel.text}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
        if (chatModel.messageImage != null &&
            chatModel.messageImage!.isNotEmpty)
          Directionality(
            textDirection: TextDirection.ltr,
            child: Padding(
              padding: EdgeInsetsDirectional.only(end: 80.sp),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemBuilder: (context, index) => Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 1.0, color: Colors.grey.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.network(
                      chatModel.messageImage![index],
                      fit: BoxFit.fill,
                      height: 150,
                      width: 150,
                    )),
                itemCount: chatModel.messageImage!.length,
              ),
            ),
          ),
      ],
    );
  }
}
