import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spozfy/screens/splash/spash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF08131F);

    return GetMaterialApp(
      title: 'Spozfy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: primaryColor,
        canvasColor: primaryColor,

        appBarTheme: const AppBarTheme(
          backgroundColor: primaryColor,
          elevation: 0,
        ),

        colorScheme: const ColorScheme.dark(
          primary: primaryColor,
          surface: primaryColor,
        ),
      ),

      home: const SplashScreen(),
    );
  }
}