import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        log(error.toString());
      });
    }
  }

  sendMessage({
    required String receiverId,
    required DateTime dateTime,
    required String text,
  }) {
    ChatModel model = ChatModel(
      senderId: uId,
      receiverId: receiverId,
      time: DateTime.now().toString(),
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
}
