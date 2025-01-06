import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:equilibrium/screens/home_screen.dart';

class SignInController extends GetxController {
  final supabase = Supabase.instance.client;

  final _email = ''.obs;
  final _password = ''.obs;

  // CHANGE 2: Added loading state for better UX
  final isLoading = false.obs;

  // Kept existing session and user observables
  Rxn<Session> session = Rxn<Session>();
  Rxn<User> user = Rxn<User>();

  void setEmail(String value) => _email.value = value.trim();
  void setPassword(String value) => _password.value = value;

  Future<void> signInUser() async {
    // CHANGE 4: Added validation before attempting sign in
    if (_email.value.isEmpty || _password.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;

      final AuthResponse res = await supabase.auth.signInWithPassword(
        email: _email.value,
        password: _password.value,
      );

      session.value = res.session;
      user.value = res.user;

      if (user.value != null) {
        Get.offAll(() => HomeScreen());
      }
    } on AuthException catch (e) {
      Get.snackbar(
        "Sign In Error",
        e.message,
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
      );
      log("Error signing in: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
