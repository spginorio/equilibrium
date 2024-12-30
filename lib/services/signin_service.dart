import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_it/screens/home_screen.dart';

class SignInController extends GetxController {
  //
  //! SUPABASE INSTANCE
  final supabase = Supabase.instance.client;

  //! Making session and user observable
  Rxn<Session> session = Rxn<Session>();
  Rxn<User> user = Rxn<User>();

  //! Making text controllers observable
  final emailSignInController = TextEditingController().obs;
  final passwordSignInController = TextEditingController().obs;

  Future<void> signInUser() async {
    try {
      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: emailSignInController.value.text,
        password: passwordSignInController.value.text,
      );
      session.value = res.session;
      user.value = res.user;

      //! Navigate to home screen if user is successfully signed up
      if (user.value != null) {
        Get.offAll(() => HomeScreen()); // Navigate and remove previous routes
      }
      //
      //
    } on AuthException catch (e) {
      Get.snackbar(
        "Sign Up Error",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
      );

      // Log the error for debugging purposes
      log("Error signing up: $e");
    }
  }

  @override
  void dispose() {
    emailSignInController.value.dispose();
    passwordSignInController.value.dispose();
    super.dispose();
  }
}
