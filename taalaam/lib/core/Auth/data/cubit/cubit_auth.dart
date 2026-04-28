import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:student_app/FireBase/firebase.dart';
import 'package:student_app/core/Auth/ScreenAuth/controller_auth.dart';
import 'package:student_app/core/Auth/data/Model/model_auth.dart';
import 'package:student_app/core/Auth/data/cubit/state_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> formKey1 = GlobalKey<FormState>();
  AuthCubit() : super(AuthInitial());

  Future<void> register(AuthRequestModel model) async {
    emit(AuthLoading());

    final response = await FirebaseHelper.register(model);
    if (response == null) {
      await sendVerificationEmail();
      emit(AuthSuccess());
      return;
    }
    emit(AuthError());
  }

  Future<void> login(AuthRequestModel model) async {
    emit(AuthLoading());

    final response = await FirebaseHelper.login(model);

    log("aaaaaaaaaaaaaaaa");
    if (response == null &&
        FirebaseHelper.fireauth.currentUser?.emailVerified == true) {
      emit(AuthSuccess());
      return;
    }

    emit(
      AuthError(
        errorCode: FirebaseHelper.fireauth.currentUser?.emailVerified == false
            ? 0
            : null,
      ),
    );
  }

  Future<void> googleSignIn() async {
    final response = await FirebaseHelper.googleSignIN();
    if (response == null) {
      emit(AuthSuccess());
      return;
    }
    emit(AuthError());
  }

  Future<void> sendVerificationEmail() async {
    try {
      await FirebaseHelper.fireauth.currentUser?.sendEmailVerification();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    emit(AuthLoading());
    await FirebaseHelper.sendPasswordResetEmail(email);
    emit(AuthSuccess());
  }
}

class KRegex {
  static final username = RegExp(r'^[a-zA-Z0-9_]{3,20}$');
  static final email = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
  static final passwordRegex = RegExp(
    r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#\$&*~]).{6,}$',
  );

  static String? validator(
    String? value,
    RegExp regularExpression,
    String errorMessage,
  ) {
    if (value == null || !regularExpression.hasMatch(value)) {
      return errorMessage;
    }
    return null;
  }

  static String? validatorName(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    return null;
  }
}
