import 'package:firebase_auth/firebase_auth.dart';

abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginErrorState extends LoginStates {
  final FirebaseAuthException? error;
  LoginErrorState({this.error});
}

class ChangeVisibility extends LoginStates {}
