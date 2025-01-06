import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:equilibrium/hive/hive_service.dart';
import 'package:equilibrium/screens/home_screen.dart';
import 'package:equilibrium/screens/login/login_screen.dart';

class SignUpController extends GetxController {
  final supabase = Supabase.instance.client;

  // Observable states
  final Rxn<Session> session = Rxn<Session>();
  final Rxn<User> user = Rxn<User>();
  final isLoading = false.obs;

  // Form fields as observable strings
  final _email = ''.obs;
  final _password = ''.obs;
  final _passwordConfirmation = ''.obs;

  // Setters for form fields
  void setEmail(String value) => _email.value = value.trim();
  void setPassword(String value) => _password.value = value;
  void setPasswordConfirmation(String value) =>
      _passwordConfirmation.value = value;

  Future<void> signUpUser() async {
    if (!_validateInputs()) return;

    try {
      isLoading.value = true;

      final AuthResponse res = await supabase.auth.signUp(
        email: _email.value,
        password: _password.value,
      );

      session.value = res.session;
      user.value = res.user;

      if (user.value != null) {
        Get.offAll(() => const HomeScreen());
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Sign Up Error",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red[100],
      );
      log("Error signing up: $e");
    } catch (e) {
      log("Unexpected error during sign up: $e");
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (_email.value.isEmpty ||
        _password.value.isEmpty ||
        _passwordConfirmation.value.isEmpty) {
      Get.snackbar(
        "Validation Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (_password.value != _passwordConfirmation.value) {
      Get.snackbar(
        "Password Error",
        "The passwords don't match",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    if (_password.value.length < 6) {
      Get.snackbar(
        "Password Error",
        "Password must be at least 6 characters long",
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    return true;
  }

  void clearForm() {
    _email.value = '';
    _password.value = '';
    _passwordConfirmation.value = '';
  }

  Future<void> signOut() async {
    try {
      await HiveService.closeUserBoxes();
      await supabase.auth.signOut();
      user.value = null;
      clearForm();
      Get.offAll(() => const SplashPage());
    } catch (e) {
      log("Error during sign out: $e");
      rethrow;
    }
  }
}
