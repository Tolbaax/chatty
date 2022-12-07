import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_app/modules/post/cubit/states.dart';
import 'package:social_app/network/models/post_model.dart';
import 'package:social_app/network/models/user_model.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:social_app/shared/widgets/show_toast.dart';
import 'package:uuid/uuid.dart';

class AddPostCubit extends Cubit<AddPostStates> {
  AddPostCubit() : super(AddPostInitialState());

  static AddPostCubit get(context) => BlocProvider.of(context);

  final postTextController = TextEditingController();
  File? postImage;

  //GET USER DATA
  Future<void> getUserData() async {
    emit(GetUserDataLoadingState());
    await FirebaseFirestore.instance.collection('users').doc(uId).get().then(
      (value) {
        currentUser = UserModel.fromJson(value.data()!);
        emit(GetUserDataSuccessState());
      },
    ).catchError((error) {
      emit(GetUserDataErrorState(error: error.toString()));
    });
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(PostImagePickedSuccessState());
    } else {
      log('No image selected');
      emit(PostImagePickedErrorState());
    }
  }

  Future uploadPostImage() async {
    emit(CreatePostLoadingState());
    await FirebaseStorage.instance
        .ref()
        .child('postImages/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        createNewPost(image: value);
      });
    }).catchError((error) {
      log(error.toString());
    });
  }

  // Future uploadPostImage() async {
  //   List<String> imagesURL = [];
  //   for (final element in postImages!) {
  //     await FirebaseStorage.instance
  //         .ref()
  //         .child('postImages/${Uri.file(element.path).pathSegments.last}')
  //         .putFile(File(element.path))
  //         .then((value) async {
  //       await value.ref.getDownloadURL().then((value) {
  //         imagesURL.add(value);
  //         createNewPost();
  //       }).catchError((onError) {
  //         log(onError.toString());
  //       });
  //     });
  //   }
  //   return imagesURL;
  // }

  void createNewPost({String? image}) async {
    if (postTextController.text.isNotEmpty || postImage != null) {
      emit(CreatePostLoadingState());
      String postId = const Uuid().v1();
      PostModel model = PostModel(
        name: currentUser!.name,
        image: currentUser!.image,
        uID: currentUser!.uID,
        postText: postTextController.text,
        postId: postId,
        time: DateTime.now().toString(),
        postImage: image ?? '',
        likes: [],
      );
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .set(model.toJson())
          .then((value) {
        emit(CreatePostSuccessState());
      }).catchError(
        (error) {
          log(error.toString());
          emit(CreatePostErrorState());
        },
      );
    } else {
      showToast(text: 'Please write a post', state: ToastState.error);
    }
  }

  void removePostImage() {
    postImage = null;
    emit(RemovePostImageState());
  }
}
