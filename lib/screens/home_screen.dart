import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:time_it/services/sign_google_apple.dart';
import 'package:time_it/services/signup_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  //! retreive the signup controller
  final controller = Get.find<SignUpController>();
  final googleAppleController = Get.find<SignGoogleAppleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await controller.signOut();
                await googleAppleController.googleSignOut();
              },
              child: Text("Sign Out"),
            ),
            //
            //
            Text("This is the HOMESCREEN"),
          ],
        ),
      ),
    );
  }
}
