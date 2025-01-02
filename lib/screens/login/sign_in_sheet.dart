import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //!EMAIL
                  GetX<SignInController>(
                    builder: (controller) => TextField(
                      //TODO format the textfield
                      controller: controller.emailSignInController.value,
                    ),
                  ),

                  //!PASSWORD,
                  GetX<SignInController>(
                    builder: (controller) => TextField(
                      //TODO format the textfield
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
      padding: const EdgeInsets.fromLTRB(100, 1, 100, 1),
      child: Text(
        "SIGN IN",
        style: TextStyle(
            fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2),
      ),
    ),
  );
}
