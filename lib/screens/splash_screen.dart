import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_it/services/signup_service.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  //
  //! retreive the signup controller
  final controller = Get.find<SignUpController>();

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
                onPressed: null,
                child: Text("SIGN IN"),
              ),

              //! SIGNUP
              signUpModalBottomSheet(context),

              //! SIGNUP WITH
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
                              await controller.signUpUser();
                              if (controller.user.value != null) {
                                // Check if signup was successful
                                FocusScope.of(context).unfocus();
                                // Close the bottom sheet first
                                // Use Get.off instead of Get.to to prevent going back
                              } else {
                                // Show error message
                                Get.snackbar(
                                  'Error',
                                  'Signup failed. Please try again.',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
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
