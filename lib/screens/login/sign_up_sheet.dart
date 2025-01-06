import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:equilibrium/services/signup_service.dart';

final signUpController = Get.find<SignUpController>();

TextButton signUpModalBottomSheet(BuildContext context) {
  return TextButton(
    style: TextButton.styleFrom(
        backgroundColor: Colors.grey.shade200,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)))),
    onPressed: () => Get.bottomSheet(
        Padding(
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
                  Text(
                    "Create your account",
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
                      onChanged: signUpController.setEmail,
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
                      onChanged: signUpController.setPassword,
                      obscureText: true,
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

                  // Password Confirmation TextField
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: signUpController.setPasswordConfirmation,
                      obscureText: true,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 20),
                        hintText: "Confirm Password..",
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

                  Text(
                    "Password must be at least 6 characters long",
                    style: TextStyle(color: Colors.grey.shade400),
                  ),
                  const SizedBox(height: 5),

                  // Sign Up Button with loading state
                  Obx(() => TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 230, 230, 230)),
                        onPressed: signUpController.isLoading.value
                            ? null
                            : () async {
                                await signUpController.signUpUser();
                              },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: signUpController.isLoading.value
                              ? const CircularProgressIndicator()
                              : const Text("SIGN UP"),
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
        "SIGN UP",
        style: TextStyle(
            color: Color.fromARGB(225, 255, 109, 64),
            fontSize: 21,
            letterSpacing: 2,
            fontWeight: FontWeight.bold),
      ),
    ),
  );
}
