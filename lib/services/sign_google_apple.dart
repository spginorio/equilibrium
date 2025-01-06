import 'dart:async';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:equilibrium/screens/home_screen.dart';
import 'package:equilibrium/screens/login/login_screen.dart';

class SignGoogleAppleController extends GetxController {
  final supabaseGoogleAuth = Supabase.instance.client;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    serverClientId:
        '254152626182-452f42tdl4k2n7q6is5tkgu4ck02fh7b.apps.googleusercontent.com',
  );

  Rx<User?> user = Rx<User?>(null);
  StreamSubscription<AuthState>? _authStateSubscription;

  @override
  void onInit() {
    super.onInit();
    _initAuthListener();
  }

  void _initAuthListener() {
    _authStateSubscription?.cancel();
    _authStateSubscription =
        supabaseGoogleAuth.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      user.value = session?.user;

      if (user.value != null) {
        Get.offAll(() => const HomeScreen());
      } else {
        log('User is logged out');
      }
    });
  }

  Future<AuthResponse> googleSignIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw 'Google sign-in was canceled.';
      }

      final googleAuth = await googleUser.authentication;
      final accessToken = googleAuth.accessToken;
      final idToken = googleAuth.idToken;

      if (accessToken == null) throw 'No Access Token found.';
      if (idToken == null) throw 'No ID Token found.';

      return await supabaseGoogleAuth.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
    } catch (e) {
      log('Google sign-in error: $e');
      rethrow;
    }
  }

  Future<void> googleSignOut() async {
    try {
      await supabaseGoogleAuth.auth.signOut();
      if (await _googleSignIn.isSignedIn()) {
        await _googleSignIn.signOut();
      }
      Get.offAll(() => const SplashPage());
    } catch (e) {
      log('Error during sign out: $e');
      rethrow;
    }
  }

  @override
  void onClose() {
    _authStateSubscription?.cancel();
    super.onClose();
  }
}
