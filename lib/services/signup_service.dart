import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_it/screens/home_screen.dart';
import 'package:time_it/screens/login/splash_screen.dart';

class SignUpController extends GetxController {
  //
  //! Making session and user observable
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
      //
      //! catch any exceptions that occur during the sign up process
      //! show a snackbar only the with the error message
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

  //! clear the controllers
  void clearTextFields() {
    emailController.value.clear();
    passwordController.value.clear();
  }

  //!  -------------SIGNOUT-------------
  Future<void> signOut() async {
    //sign out from Supabase and clear the session and user observables
    await supabase.auth.signOut();

    //makes user null
    user.value = null;

    //clear the controllers of email and password
    clearTextFields();

    //navigate back to the splash screen if user is signed out
    if (user.value == null) {
      Get.offAll(() => SplashPage());
    }
  }

  @override
  void dispose() {
    emailController.value.dispose();
    passwordController.value.dispose();
    super.dispose();
  }
}
