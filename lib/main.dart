import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/screens/auth/login_screen.dart';
import 'package:pengaduan_dp3a/splash/splash_screen.dart'; // path sesuai ralat: lib/splash/splash_screen.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Intl.defaultLocale = 'id_ID';

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSy... ... ...",
        authDomain: "pengaduan-dpppa-bjm.firebaseapp.com",
        projectId: "pengaduan-dpppa-bjm",
        storageBucket: "pengaduan-dpppa-bjm.appspot.com",
        messagingSenderId: "1234567890",
        appId: "1:1234567890:web:...",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Layanan Pengaduan DPPPA',

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('id', 'ID'),
      ],

      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        useMaterial3: true,
      ),

      // --- Mulai dari SplashScreen ---
      home: const SplashScreen(),

      // --- Routes: pastikan SplashScreen dapat nav ke '/login' ---
      routes: {
        '/login': (context) => const LoginScreen(),
        // tambahkan route lain di sini jika diperlukan
      },
    );
  }
}
