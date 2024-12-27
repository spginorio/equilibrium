import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_it/screens/home_screen.dart';
import 'package:time_it/screens/splash_screen.dart';
import 'package:time_it/services/signup_service.dart';

void main() async {
  // initialize widget
  WidgetsFlutterBinding.ensureInitialized();

  //supabase init
  await Supabase.initialize(
    url: 'https://hkwtumvjxusmevckzbxm.supabase.co',
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhrd3R1bXZqeHVzbWV2Y2t6YnhtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzMzI2NzksImV4cCI6MjA0OTkwODY3OX0.p9inriMRkr0L9KrKxhuYQTqXg4uFf2lY4u6yCo52rxk",
  );

  //run app
  runApp(MainApp());

//singleton instance of the SignUpController
  Get.put(SignUpController());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  //! SUPABASE INSTANCE
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: supabase.auth.currentUser != null
          ? const HomeScreen() // User is logged in
          : const SplashPage(), // User needs to log in
    );
  }
}
