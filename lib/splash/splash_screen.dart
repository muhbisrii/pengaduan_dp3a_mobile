import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late AnimationController slideController;
  late Animation<Offset> slideAnimation;

  late AnimationController scaleController;
  late Animation<double> scaleAnimation;

  late AnimationController fadeController;
  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    // ANIMASI LOGO TURUN DARI ATAS
    slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.5), // posisi dari atas
      end: Offset.zero,             // ke tengah layar
    ).animate(
      CurvedAnimation(parent: slideController, curve: Curves.easeOutBack),
    );

    slideController.forward();

    // Setelah turun, logo zoom out
    Future.delayed(const Duration(milliseconds: 1000), () {
      scaleController.forward();
    });

    // ANIMASI ZOOM OUT
    scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 4.0, // membesar full layar
    ).animate(
      CurvedAnimation(parent: scaleController, curve: Curves.easeInOut),
    );

    // Setelah zoom, fade out
    Future.delayed(const Duration(milliseconds: 1800), () {
      fadeController.forward();
    });

    // ANIMASI FADE OUT
    fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(fadeController);

    // Setelah fade out → masuk login
    fadeController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    });
  }

  @override
  void dispose() {
    slideController.dispose();
    scaleController.dispose();
    fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // background putih
      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: SlideTransition(
              position: slideAnimation,
              child: Image.asset(
                "assets/images/logo2.png",
                width: 160,
                height: 160,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
