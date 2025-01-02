import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:time_it/hive/hive_service.dart';
import 'package:time_it/screens/home_screen.dart';
import 'package:time_it/screens/login/login_screen.dart';
import 'package:time_it/services/signup_service.dart';
import 'package:time_it/services/signin_service.dart';
import 'package:time_it/services/sign_google_apple.dart';

void main() async {
  // initialize widget
  WidgetsFlutterBinding.ensureInitialized();

  //supabase init
  await Supabase.initialize(
    url: 'https://hkwtumvjxusmevckzbxm.supabase.co',
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imhrd3R1bXZqeHVzbWV2Y2t6YnhtIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQzMzI2NzksImV4cCI6MjA0OTkwODY3OX0.p9inriMRkr0L9KrKxhuYQTqXg4uFf2lY4u6yCo52rxk",
  );

  // Initialize Hive
  await Hive.initFlutter();
  await HiveService.init();

  //singleton instance of the SignUpController
  Get.put(SignUpController());

  //singleton instance SingInControler
  Get.put(SignInController());

  //singleton instance SignGoogleAppleController
  Get.put(SignGoogleAppleController());

  //run app
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  //! SUPABASE INSTANCE
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.teal),
          textTheme: GoogleFonts.interTextTheme(),
        ),
        home: supabase.auth.currentUser != null
            ? const HomeScreen() // User is logged in
            : const SplashPage() // User needs to log in
        );
  }
}
