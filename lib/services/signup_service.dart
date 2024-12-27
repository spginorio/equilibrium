import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_it/screens/home_screen.dart';
import 'package:time_it/screens/splash_screen.dart';

class SignUpController extends GetxController {
  // Making session and user observable
  Rxn<Session> session = Rxn<Session>();
  Rxn<User> user = Rxn<User>();

  // Making text controllers observable
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;

  //! SUPABASE INSTANCE
  final supabase = Supabase.instance.client;

  //!SIGN UP USER FUNCTION TO BE CALLED WHEN USER CLICKS THE SIGN UP BUTTON
  Future<void> signUpUser() async {
    try {
      final AuthResponse res = await supabase.auth.signUp(
        email: emailController.value.text,
        password: passwordController.value.text,
      );
      session.value = res.session;
      user.value = res.user;

      //! Navigate to home screen if user is successfully signed up
      if (user.value != null) {
        Get.offAll(() => HomeScreen()); // Navigate and remove previous routes
      }
    } catch (e) {
      log("Error signing up: $e");
    }
  }

  //!SIGNOUT
  Future<void> signOut() async {
    await supabase.auth.signOut();
    Get.offAll(() => SplashPage());
  }

  @override
  void dispose() {
    emailController.value.dispose();
    passwordController.value.dispose();
    super.dispose();
  }
}
