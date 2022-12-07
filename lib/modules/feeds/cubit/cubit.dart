import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/feeds/cubit/states.dart';
import 'package:social_app/network/models/post_model.dart';
import 'package:social_app/shared/resources/global.dart';
import 'package:uuid/uuid.dart';

class FeedsCubit extends Cubit<FeedsStates> {
  FeedsCubit() : super(FeedsInitialState());

  static FeedsCubit get(context) => BlocProvider.of(context);

  List<PostModel> posts = [];

  void getPosts({String? postId}) {
    emit(GetPostsLoadingState());
    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        posts.add(PostModel.fromJson(element.data()));
      }
      emit(GetPostsSuccessState());
    }).catchError((error) {
      emit(GetPostsErrorState());
      log(error.toString());
    });
  }

  Future likePost({required String? postId, List? likes}) async {
    try {
      if (likes!.contains(uId)) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayRemove([uId]),
        });
        emit(LikePostSuccessState());
      } else {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'likes': FieldValue.arrayUnion([uId]),
        });
        emit(LikePostSuccessState());
      }
    } catch (e) {
      emit(LikePostErrorState());
      log(e.toString());
    }
  }

  Future postComment(
      {String? postId, String? text, String? name, String? profilePic}) async {
    try {
      if (text!.isNotEmpty) {
        String commentId = const Uuid().v1();
        emit(CommentLoadingState());
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'name': name,
          'text': text,
          'uId': uId,
          'profilePic': profilePic,
          'commentId': commentId,
          'datePublished': DateTime.now().toString(),
        }).then((value) {
          emit(CommentSuccessState());
        });
      } else {
        log('Text is empty');
        emit(CommentsErrorState());
      }
    } catch (e) {
      log(e.toString());
      emit(CommentsErrorState());
    }
  }
}
