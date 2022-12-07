import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/layout/cubit/states.dart';
import 'package:social_app/modules/chats/chats_screen.dart';
import 'package:social_app/modules/feeds/feeds_screen.dart';
import 'package:social_app/modules/settings/settings_screen.dart';
import 'package:social_app/modules/users/users_screen.dart';
import 'package:social_app/shared/lcoal/cache_helper.dart';
import 'package:social_app/shared/resources/global.dart';

import '../../network/models/user_model.dart';

class LayoutCubit extends Cubit<LayoutStates> {
  LayoutCubit() : super(LayoutInitialSate());

  static LayoutCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    const FeedsScreen(),
    const ChatsScreen(),
    const UsersScreen(),
    const SettingsScreen(),
  ];

  List<String> titles = [
    'Chatty',
    'Chats',
    'Users',
    'Settings',
  ];
  void changeBottomNav(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  // SIGN OUT
  void signOut(context) {
    FirebaseAuth.instance.signOut().then((value) {
      CacheHelper.removeData(key: 'uId');
      emit(SignOutSuccessState());
    }).then((value) {
      changeBottomNav(0);
      emit(ChangeBottomNavState());
    });
  }

  Future<void> getUserData() async {
    await FirebaseFirestore.instance.collection('users').doc(uId).get().then(
      (value) {
        currentUser = UserModel.fromJson(value.data()!);
      },
    ).catchError((error) {
      log(error.toString());
    });
  }
}
