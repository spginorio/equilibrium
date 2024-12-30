import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_it/services/signin_service.dart';

//!-----------SIGN IN GETX BOTTOM MODAL SHEET-----------------
//! Handles the sign in process in a getx bottom sheet

final signInController = Get.find<SignInController>();

TextButton signInGetxBottomModalSheet(BuildContext context) {
  return TextButton(
    style: TextButton.styleFrom(
        shape: RoundedRectangleBorder(
            side: BorderSide(),
            borderRadius: BorderRadius.all(Radius.circular(50)))),
    onPressed: () => Get.bottomSheet(
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
