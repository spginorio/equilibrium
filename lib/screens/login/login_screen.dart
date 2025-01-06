import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:equilibrium/screens/login/sign_in_sheet.dart';
import 'package:equilibrium/screens/login/sign_up_sheet.dart';
import 'package:equilibrium/services/sign_google_apple.dart';
import 'package:equilibrium/services/signin_service.dart';

// retrieve the signup controller
final signInController = Get.find<SignInController>();
final signGoogleAppleController = Get.find<SignGoogleAppleController>();

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //

  @override
  Widget build(BuildContext context) {
    // This will make the icons dark (suitable for light background)
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: 40,
              ),
              //! LOGO
              FittedBox(
                fit: BoxFit.contain,
                child: Lottie.asset(
                  "assets/clock.json",
                  height: 250,
                  width: 250,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Equilibrium",
                style: TextStyle(
                  fontSize: 59,
                  color: Colors.teal,
                  fontFamily: GoogleFonts.sansita().fontFamily,
                ),
              ),

              SizedBox(
                height: 110,
              ),
              //! TEXT
              Text(
                "Welcome Back",
                style: TextStyle(
                    fontSize: 32,
                    color: const Color.fromARGB(186, 0, 150, 135),
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 60,
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
              GestureDetector(
                onTap: () async {
                  try {
                    await signGoogleAppleController.googleSignIn();
                  } catch (e) {
                    log(e.toString());
                  }
                },
                child: Image.asset(
                  "assets/google.png",
                  height: 50,
                  width: 200,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
