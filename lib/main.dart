import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'views/splash_screen.dart'; // Tambahkan SplashScreen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Better-Nak',
      home: const SplashScreen(), // Awali dengan Splash Screen
    );
  }
}
