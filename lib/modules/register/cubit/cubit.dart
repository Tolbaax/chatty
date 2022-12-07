import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/register/cubit/states.dart';
import 'package:social_app/network/auth/auth.dart';
import 'package:social_app/network/models/user_model.dart';
import 'package:social_app/shared/widgets/show_toast.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitState());
  static RegisterCubit get(context) => BlocProvider.of(context);

  // USER REGISTER
  final email = TextEditingController();
  final password = TextEditingController();
  final name = TextEditingController();
  final phone = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  UserModel? userModel;
  void userRegister() {
    if (formKey.currentState!.validate()) {
      emit(RegisterLoadingState());
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text)
          .then((value) async {
        await Auth.createUser(
          name: name.text,
          email: email.text,
          phoneNumber: phone.text,
          uID: value.user!.uid,
        );
        emit(RegisterSuccessState());
      }).catchError(
        (onError) {
          if (onError is FirebaseAuthException) {
            showToast(text: onError.code.toString(), state: ToastState.error);
            emit(RegisterErrorState());
          }
        },
      );
    }
  }

  // CHANGE VISIBILITY
  bool isPassword = true;
  IconData suffix = Icons.visibility_outlined;
  changeVisibility() {
    isPassword = !isPassword;
    suffix =
        isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined;
    emit(ChangeVisibility());
  }
}
