import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_it/screens/login/sign_in_sheet.dart';
import 'package:time_it/screens/login/sign_up_sheet.dart';
import 'package:time_it/services/sign_google_apple.dart';
import 'package:time_it/services/signin_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //
  //! retreive the signup controller
  final signInController = Get.find<SignInController>();
  final signGoogleAppleController = Get.find<SignGoogleAppleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              //! LOGO,
              SizedBox(
                height: 50,
              ),
              Text(
                "APPLICATION",
                style: TextStyle(fontSize: 44),
              ),

              SizedBox(
                height: 150,
              ),
              //! TEXT
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 40),
              ),
              SizedBox(
                height: 90,
              ),

              //! SIGNIN
              signInGetxBottomModalSheet(context),

              SizedBox(
                height: 20,
              ),

              //! SIGNUP
              signUpModalBottomSheet(context),

              //! SIGNUP WITH GOOGLE or APPLE ID
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    await signGoogleAppleController.googleSignIn();
                  },
                  child: Text("Sign in with Google"))
            ],
          ),
        ],
      ),
    );
  }
}
