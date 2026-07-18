import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:last_version/core/utils/app_images.dart';
import 'package:last_version/features/auth/screens/login_screen.dart';
import 'package:last_version/features/notes/screens/home_page_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double scale = 0.5;
  double opacity = 0;
  bool showText = false;

  @override
  void initState() {
    super.initState();

    // Logo animation
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;

      setState(() {
        scale = 1;
        opacity = 1;
      });
    });

    // Text animation
    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      setState(() {
        showText = true;
      });
    });

    // Navigate to the next screen
    Future.delayed(const Duration(seconds: 3), () {
      if (!mounted) return;

      final user = FirebaseAuth.instance.currentUser;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) {
            if (user != null && user.emailVerified) {
              return const HomePageScreen();
            }

            return LoginScreen();
          },
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 1000),
              child: AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutBack,
                child: Image.asset(AppImages.appLogo, width: 220, height: 220),
              ),
            ),

            const SizedBox(height: 20),

            AnimatedOpacity(
              opacity: showText ? 1 : 0,
              duration: const Duration(milliseconds: 800),
              child: AnimatedSlide(
                offset: showText ? Offset.zero : const Offset(0, 0.5),
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOut,
                child: Column(
                  children: [
                    Text(
                      "app_name".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      "write_anything".tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
