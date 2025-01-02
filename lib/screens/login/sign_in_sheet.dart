import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:time_it/services/signin_service.dart';

//!-----------SIGN IN GETX BOTTOM MODAL SHEET-----------------
//! Handles the sign in process in a getx bottom sheet

final signInController = Get.find<SignInController>();

TextButton signInGetxBottomModalSheet(BuildContext context) {
  return TextButton(
    style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(
            // side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(50)))),
    onPressed: () => Get.bottomSheet(
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 400,
              child: Column(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //!Signin text

                  Text(
                    "Hello, sign in!",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                        color: const Color.fromARGB(186, 0, 150, 135),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  //!EMAIL
                  GetX<SignInController>(
                    builder: (controller) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller.emailSignInController.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: " Email..",
                          hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 168, 168, 168)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                        ),
                      ),
                    ),
                  ),

                  //!PASSWORD,
                  GetX<SignInController>(
                    builder: (controller) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: controller.passwordSignInController.value,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(left: 20),
                          hintText: "Password..",
                          hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 168, 168, 168)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey, width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30))),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                                color: const Color.fromARGB(255, 37, 37, 37),
                                style: BorderStyle.solid),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //!SIGN IN BUTTON,
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 230, 230, 230)),
                    onPressed: () async {
                      await signInController.signInUser();
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Text("Sing In"),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: true),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(100, 1, 100, 1),
      child: Text(
        "SIGN IN",
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: const Color.fromARGB(186, 0, 150, 135),
        ),
      ),
    ),
  );
}
