import 'dart:developer';

import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_it/screens/home_screen.dart';
import 'package:time_it/screens/login/login_screen.dart';

class SignGoogleAppleController extends GetxController {
  final supabaseGoogleAuth = Supabase.instance.client;
  Rx<User?> user = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();

    //! LISTEN FOR AUTH CHANGES
    supabaseGoogleAuth.auth.onAuthStateChange.listen((event) {
      final session = event.session;
      user.value = session?.user;

      //when the user logs in with google it will be picked up by the
      //listener and triger the if. sending the user to the homescreen
      //and deleting all the other views so the user can't go back to
      //the login page
      if (user.value != null) {
        Get.offAll(() => HomeScreen());
      } else {
        log('User is logged out');
      }
    });
  }

  Future<AuthResponse> googleSignIn() async {
    /// Web Client ID that you registered with Google Cloud.
    const webClientId =
        '254152626182-452f42tdl4k2n7q6is5tkgu4ck02fh7b.apps.googleusercontent.com';

    // iOS Client ID that you registered with Google Cloud.
    // const iosClientId = 'my-ios.apps.googleusercontent.com';

    // Google sign in on Android will work without providing the Android
    // Client ID registered on Google Cloud.

    final GoogleSignIn googleSignIn = GoogleSignIn(
      // clientId: iosClientId,
      serverClientId: webClientId,
    );
    final googleUser = await googleSignIn.signIn();
    final googleAuth = await googleUser!.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return supabaseGoogleAuth.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<void> googleSignOut() async {
    //supabase logout
    await supabaseGoogleAuth.auth.signOut();

    //google logout
    final GoogleSignIn googleSignIn = GoogleSignIn();
    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }
    Get.offAll(() => SplashPage());
  }
}
