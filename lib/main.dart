import 'package:aplikasi_6packs/splash_screen.dart';
import 'package:aplikasi_6packs/views/login_page.dart';
import 'package:aplikasi_6packs/views/register_page.dart';
import 'package:aplikasi_6packs/views/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        textTheme: GoogleFonts.interTextTheme(),
      ),
      routes: {
        '/': (context) => SplashScreen(),
        '/welcome': (context) => WelcomePage(),
        '/daftar': (context) => RegisterPage(),
        '/masuk': (context) => LoginPage(),
      },
      initialRoute: '/',
    );
  }
}


