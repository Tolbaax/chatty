import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:social_app/network/models/user_model.dart';

class Auth {
  static Future<void> createUser({
    required String? name,
    String? phoneNumber,
    required String? email,
    required String? uID,
    bool? isEmailVerified = false,
    String bio = 'Write your bio..',
    String header =
        'https://images.unsplash.com/photo-1619426017013-0d6db7b74d1a?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1771&q=80',
    String image =
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ_b9At51R9Ol4LI9btHNnDqmo1T0wmlpomVA&usqp=CAU',
  }) async {
    UserModel model = UserModel(
      name: name,
      phone: phoneNumber ?? '',
      email: email,
      uID: uID,
      isEmailVerified: isEmailVerified,
      bio: bio,
      header: header,
      image: image,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(uID)
        .set(model.toJson())
        .catchError((onError) {
      if (kDebugMode) {
        print(onError.toString());
      }
    });
  }
}
