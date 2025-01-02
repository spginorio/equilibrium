import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
                child:
                    Lottie.asset("assets/clock.json", height: 250, width: 250),
              ),
              SizedBox(
                height: 35,
              ),
              Text(
                "Equilibrium",
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.teal,
                  fontFamily: GoogleFonts.quicksand().fontFamily,
                ),
              ),

              SizedBox(
                height: 150,
              ),
              //! TEXT
              Text(
                "Welcome Back!",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.teal,
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
                  await signGoogleAppleController.googleSignIn();
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
