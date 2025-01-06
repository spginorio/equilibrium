import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:equilibrium/hive/hive_service.dart';
import 'package:equilibrium/screens/home_screen.dart';
import 'package:equilibrium/screens/login/login_screen.dart';
import 'package:equilibrium/services/signup_service.dart';
import 'package:equilibrium/services/signin_service.dart';
import 'package:equilibrium/services/sign_google_apple.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    //dotenv
    await dotenv.load(fileName: "assets/.env");

    //supabase init
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_KEY']!,
    );

    //hive
    await Hive.initFlutter();
    await HiveService.init();

    // Initialize controllers
    Get.put(SignUpController(), permanent: true);
    Get.put(SignInController(), permanent: true);
    Get.put(SignGoogleAppleController(), permanent: true);

    runApp(MainApp());
  } catch (e) {
    log('Error during initialization: $e');
    // Handle initialization error appropriately
  }
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
