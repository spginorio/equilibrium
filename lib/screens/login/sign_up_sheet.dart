import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_it/services/signup_service.dart';

//! -----------SIGNUP MODAL BOTTOM SHEET--------------
//! Handles the user signup process in a modal bottom sheet.

final signUnController = Get.find<SignUpController>();

//
TextButton signUpModalBottomSheet(BuildContext context) {
  return TextButton(
    style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
            //side: BorderSide(color: Colors.black),
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
                                  color:
                                      const Color.fromARGB(255, 168, 168, 168)),
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

                      //TODO enter password confirmation
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
                                  color:
                                      const Color.fromARGB(255, 168, 168, 168)),
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
      padding: const EdgeInsets.fromLTRB(100, 1, 100, 1),
      child: Text(
        "SIGN UP",
        style: TextStyle(
            color: Colors.deepOrangeAccent,
            fontSize: 20,
            letterSpacing: 2,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}
