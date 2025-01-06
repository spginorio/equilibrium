import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equilibrium/services/signin_service.dart';

// Get instance of the controller that must be initialized before use
final signInController = Get.find<SignInController>();

TextButton signInGetxBottomModalSheet(BuildContext context) {
  return TextButton(
    style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)))),
    onPressed: () => Get.bottomSheet(
        Padding(
          // Adjust for keyboard
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              height: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header text
                  Text(
                    "Hello, sign in!",
                    style: TextStyle(
                        fontSize: 22,
                        fontFamily: GoogleFonts.quicksand().fontFamily,
                        color: const Color.fromARGB(186, 0, 150, 135),
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // Email TextField
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) => signInController.setEmail(value),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: "Email..",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 168, 168, 168)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                      ),
                    ),
                  ),

                  // Password TextField
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: (value) => signInController.setPassword(value),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: "Password..",
                        hintStyle: TextStyle(
                            color: Color.fromARGB(255, 168, 168, 168)),
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.grey, width: 1),
                            borderRadius:
                                BorderRadius.all(Radius.circular(30))),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 37, 37, 37),
                              style: BorderStyle.solid),
                        ),
                      ),
                    ),
                  ),

                  // Sign In Button with loading state
                  Obx(() => TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 230, 230, 230)),
                        // Disable button while loading
                        onPressed: signInController.isLoading.value
                            ? null
                            : () async {
                                await signInController.signInUser();
                              },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          // Show loading indicator or text based on state
                          child: signInController.isLoading.value
                              ? const CircularProgressIndicator()
                              : const Text("Sign In"),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
        isScrollControlled: true),
    child: const Padding(
      padding: EdgeInsets.fromLTRB(100, 1, 100, 1),
      child: Text(
        "SIGN IN",
        style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: Color.fromARGB(186, 0, 150, 135),
        ),
      ),
    ),
  );
}
