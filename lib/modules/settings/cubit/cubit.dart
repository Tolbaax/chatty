import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/modules/settings/cubit/states.dart';
import 'package:social_app/network/models/user_model.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/widgets/show_toast.dart';

class SettingsCubit extends Cubit<SettingsStates> {
  SettingsCubit() : super(SettingsInitialState());

  static SettingsCubit get(context) => BlocProvider.of(context);

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  File? profileImage;
  File? coverImage;
  final picker = ImagePicker();

  //GET USER DATA
  Future<void> getUserData() async {
    emit(GetUserDataLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(uId).get().then(
      (value) {
        currentUser = UserModel.fromJson(value.data()!);
        emit(GetUserDataSuccessState());
      },
    ).catchError((error) {
      emit(GetUserDataErrorState());
      log(error.toString());
    });
  }

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      uploadProfileImage();
      emit(ProfileImagePickedSuccess());
    } else {
      if (kDebugMode) {
        print('No image selected');
        emit(ProfileImagePickedError());
      }
    }
  }

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      uploadCoverImage();
      emit(CoverImagePickedSuccess());
    } else {
      if (kDebugMode) {
        print('No image selected');
        emit(CoverImagePickedError());
      }
    }
  }

  void uploadProfileImage() {
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateUserImage(image: value);
        showToast(text: 'Updated Successfully', state: ToastState.success);
        emit(UploadProfileImageSuccess());
      });
    }).catchError((error) {
      emit(UploadProfileImageError());
    });
  }

  void uploadCoverImage() {
    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        updateCoverImage(cover: value);
        showToast(text: 'Updated Successfully', state: ToastState.success);
        emit(UploadCoverImageSuccess());
      });
    }).catchError((error) {
      emit(UploadCoverImageError());
    });
  }

  void updateUserImage({String? image, String? postId, String? commentId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update({'image': image}).then((value) {
      getUserData();
    }).catchError(
      (error) {
        log(error.toString());
      },
    );
  }

  void updateCoverImage({String? cover}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .update({'header': cover}).then((value) {
      getUserData();
    }).catchError(
      (error) {
        log(error.toString());
      },
    );
  }

  void updateUserData() {
    if (formKey.currentState!.validate()) {
      emit(UpdateUserDataLoading());
      FirebaseFirestore.instance.collection('users').doc(uId).update({
        'name': nameController.text,
        'phone': phoneController.text,
        'bio': bioController.text,
      }).then((value) {
        getUserData();
        showToast(text: 'Updated Successfully', state: ToastState.success);
        emit(UpdateUserDataSuccess());
      }).catchError((error) {
        log(error.toString());
        emit(UpdateUserDataError());
      });
    }
  }
}
