import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_app/modules/login/cubit/states.dart';
import 'package:social_app/shared/lcoal/cache_helper.dart';
import 'package:social_app/shared/widgets/show_toast.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitState());
  static LoginCubit get(context) => BlocProvider.of(context);

  // USER LOGIN
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey();
  void userLogin() {
    if (formKey.currentState!.validate()) {
      emit(LoginLoadingState());

      FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      )
          .then((value) {
        CacheHelper.saveData(key: 'uId', value: value.user!.uid);
        emit(LoginSuccessState());
      }).catchError((error) {
        if (error is FirebaseAuthException) {
          showToast(text: error.code.toString(), state: ToastState.error);
          emit(LoginErrorState());
        }
      });
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
