import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_it/hive/hive_service.dart';
import 'package:time_it/screens/home_screen.dart';
import 'package:time_it/screens/login/login_screen.dart';
import 'package:time_it/services/signin_service.dart';

//! Instance of the SignInController
//used on the clearTextFields(); to clear psswrd
//after user logs out
SignInController signInControllerPwrd = Get.find<
    SignInController>(); //declare it outside of the class SignUpController

class SignUpController extends GetxController {
  //
  //! Making session and user observable
  Rxn<Session> session = Rxn<Session>();
  Rxn<User> user = Rxn<User>();

  // Making text controllers observable
  final emailController = TextEditingController().obs;
  final passwordController = TextEditingController().obs;
  final passwordConfirmationController = TextEditingController().obs;

  //! SUPABASE INSTANCE
  final supabase = Supabase.instance.client;

  //!SIGN UP USER FUNCTION TO BE CALLED WHEN USER CLICKS THE SIGN UP BUTTON
  Future<void> signUpUser() async {
    try {
      if (passwordController.value.text !=
          passwordConfirmationController.value.text) {
        Get.snackbar(
          "Password Error",
          "The password don't match",
          snackPosition: SnackPosition.BOTTOM,
          isDismissible: true,
        );
      } else if (passwordController.value.text.length ==
          passwordConfirmationController.value.text.length) {
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
        //
      }
    } on AuthException catch (e) {
      //! catch any exceptions that occur during the sign up process
      //! show a snackbar only the with the error message
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
    passwordConfirmationController.value.clear();
    signInControllerPwrd.passwordSignInController.value.clear(); //TODO error???
  }

  //!  -------------SIGNOUT-------------
  Future<void> signOut() async {
    // Close user-specific Hive boxes before signing out
    await HiveService.closeUserBoxes();

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
