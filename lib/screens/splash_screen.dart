import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              //! LOGO

              SizedBox(
                height: 15,
              ),
              //! TEXT
              Text(
                "Welcome Back",
                style: TextStyle(fontSize: 40),
              ),

              //! SIGNIN
              TextButton(
                onPressed: () => Get.bottomSheet(
                    SingleChildScrollView(
                      child: Container(
                        height: 300,
                        color: Colors.amber,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            //!EMAIL
                            GetX<SignInController>(
                              builder: (controller) => TextField(
                                controller:
                                    controller.emailSignInController.value,
                              ),
                            ),

                            //!PASSWORD,
                            GetX<SignInController>(
                              builder: (controller) => TextField(
                                controller:
                                    controller.passwordSignInController.value,
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
                    isScrollControlled:
                        true), //TODO: complete this bottomSheet signIn
                child: Text("SIGN IN"),
              ),

              //! SIGNUP
              signUpModalBottomSheet(context),

              //! SIGNUP WITH,
              //TODO
            ],
          ),
        ],
      ),
    );
  }

  //! -----------SIGNUP MODAL BOTTOM SHEET--------------
  //! Handles the user signup process in a modal bottom sheet.

  TextButton signUpModalBottomSheet(BuildContext context) {
    return TextButton(
      onPressed: () {
        showModalBottomSheet<void>(
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
                  height: 300,
                  color: Colors.amber,
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
                          builder: (controller) => TextField(
                            controller: controller.emailController.value,
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
                          builder: (controller) => TextField(
                            controller: controller.passwordController.value,
                            obscureText:
                                true, // obscure the password input field.
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
      child: Text("SIGN UP"),
    );
  }
}
