import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/modules/chats/cubit/states.dart';
import 'package:social_app/network/models/chat_model.dart';
import 'package:social_app/shared/resources/global.dart';

import '../../../network/models/user_model.dart';

class ChatsCubit extends Cubit<ChatStates> {
  ChatsCubit() : super(ChatInitState());

  static ChatsCubit get(context) => BlocProvider.of(context);

  List<UserModel> users = [];
  List<ChatModel> messages = [];

  void getUsers() {
    emit(GetAllUsersLoadingState());
    if (users.isEmpty) {
      FirebaseFirestore.instance.collection('users').get().then(
        (value) {
          for (var element in value.docs) {
            if (element.data()['uId'] != currentUser!.uID) {
              users.add(UserModel.fromJson(element.data()));
            }
          }
          emit(GetAllUsersSuccessState());
        },
      ).catchError((error) {
        emit(GetAllUsersErrorState());
        if (kDebugMode) {
          print(error.toString());
        }
      });
    }
  }

  sendMessage({
    required String receiverId,
    required DateTime dateTime,
    required List<String> messageImage,
    required String text,
  }) {
    ChatModel model = ChatModel(
      senderId: uId,
      receiverId: receiverId,
      time: DateTime.now().toString(),
      messageImage: messageImage,
      text: text,
    );

    // Save messages in sender chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });

    // Save Messages in receiver chats
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(uId)
        .collection('messages')
        .add(model.toJson())
        .then((value) {
      emit(SendMessageSuccessState());
    }).catchError((error) {
      emit(SendMessageErrorState());
    });
  }

  void getMessages({required String receiverId}) {
    emit(GetMessageLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('time', descending: false)
        .snapshots()
        .listen((event) {
      messages.clear();
      for (var element in event.docs) {
        messages.add(ChatModel.fromJson(element.data()));
      }
      emit(GetMessageSuccessState());
    });
  }

  List<XFile>? chatImage;
  Future<void> getChatImage() async {
    final pickedFile = await picker.pickMultiImage();
    // ignore: unnecessary_null_comparison
    if (pickedFile != null) {
      chatImage = pickedFile;
      emit(ChatImagePickedSuccessState());
    } else {
      if (kDebugMode) {
        print('No image selected');
      }
      emit(ChatImagePickedErrorState());
    }
  }

  void removeImageFromMessage(index) {
    chatImage!.removeAt(index);
    emit(ChatImagePickedSuccessState());
  }

  Future uploadChatImage() async {
    List<String> imagesURL = [];
    emit(UploadMessageImageLoadingState());
    for (final element in chatImage!) {
      await FirebaseStorage.instance
          .ref()
          .child('chatImages/${Uri.file(element.path).pathSegments.last}')
          .putFile(File(element.path))
          .then((value) async {
        await value.ref.getDownloadURL().then((value) {
          imagesURL.add(value);
          if (kDebugMode) {
            print(value);
          }
        }).catchError((onError) {
          if (kDebugMode) {
            print(onError.toString());
          }
        });
      });
    }
    return imagesURL;
  }

  Future<void> sendMessageWithImages({
    required String receiverId,
    required DateTime dateTime,
    required String text,
  }) async {
    final imagesURL = await uploadChatImage();
    sendMessage(
      receiverId: receiverId,
      dateTime: dateTime,
      messageImage: imagesURL,
      text: text,
    );
    chatImage!.clear();
    emit(UploadMessageImageSuccessState());
  }
}
