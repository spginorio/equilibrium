import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_it/services/sign_google_apple.dart';
import 'package:time_it/services/signup_service.dart';
import 'package:time_it/services/signin_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //
  //! retreive the signup controller
  final signUnController = Get.find<SignUpController>();
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

  //!-----------SIGN IN GETX BOTTOM MODAL SHEET-----------------
  //! Handles the sign in process in a getx bottom sheet

  TextButton signInGetxBottomModalSheet(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: BorderSide(),
              borderRadius: BorderRadius.all(Radius.circular(50)))),
      onPressed: () => Get.bottomSheet(
          Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Container(
                height: 300,
                color: Colors.amber,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    //!EMAIL
                    GetX<SignInController>(
                      builder: (controller) => TextField(
                        controller: controller.emailSignInController.value,
                      ),
                    ),

                    //!PASSWORD,
                    GetX<SignInController>(
                      builder: (controller) => TextField(
                        controller: controller.passwordSignInController.value,
                      ),
                    ),
                    //!SIGN IN BUTTON,
                    TextButton(
                      onPressed: () async {
                        await signInController.signInUser();
                      },
                      child: Text("Sing In"),
                    )
                  ],
                ),
              ),
            ),
          ),
          isScrollControlled: true),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(70, 1, 70, 1),
        child: Text(
          "SIGN IN",
          style: TextStyle(fontSize: 29),
        ),
      ),
    );
  }

  //! -----------SIGNUP MODAL BOTTOM SHEET--------------
  //! Handles the user signup process in a modal bottom sheet.

  TextButton signUpModalBottomSheet(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
              side: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.all(Radius.circular(50)))),
      onPressed: () {
        showModalBottomSheet<void>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return Padding(
              padding: EdgeInsets.only(

                  //!moves the modal bottom sheet up on the screen
                  //!in case that the keyboard is visible
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  height: 300,
                  // color: Colors.amber,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        //
                        //!EMAIL
                        /*
                        user email input field. this is passed to the SignUpController.
                        make sure to append the .value property to access the controller's value.
                        */
                        GetX<SignUpController>(
                          builder: (controller) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controller.emailController.value,
                              decoration: InputDecoration(
                                hintText: "Email..",
                                hintStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 168, 168, 168)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color:
                                          const Color.fromARGB(255, 37, 37, 37),
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        //
                        //!PASSWORD
                        /*
                        password input field. 
                        passed to the SignUpController.
                        */
                        GetX<SignUpController>(
                          builder: (controller) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: controller.passwordController.value,
                              obscureText:
                                  true, // obscure the password input field.
                              decoration: InputDecoration(
                                hintText: "Password..",
                                hintStyle: TextStyle(
                                    color: const Color.fromARGB(
                                        255, 168, 168, 168)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30))),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(
                                      color:
                                          const Color.fromARGB(255, 37, 37, 37),
                                      style: BorderStyle.solid),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        //
                        //!SIGNUP BUTTON
                        /*
                        on pressing the button the signUpUser() method
                        is called from the SignUpController.
                        */
                        TextButton(
                            onPressed: () async {
                              await signUnController.signUpUser();
                              if (signUnController.user.value != null) {
                                // Check if signup was successful
                                FocusScope.of(context).unfocus();
                                // Close the bottom sheet first
                                // Use Get.off instead of Get.to to prevent going back
                              }
                            },
                            child: Text("SIGN UP")),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(70, 1, 70, 1),
        child: Text(
          "SIGN UP",
          style: TextStyle(fontSize: 29),
        ),
      ),
    );
  }
}
