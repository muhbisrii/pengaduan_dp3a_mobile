import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pengaduan_dp3a/screens/auth/login_screen.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:firebase_core/firebase_core.dart';
// --- IMPORT BARU UNTUK CEK PLATFORM ---
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // --- PERBAIKAN DI SINI ---
  // Cek apakah kita berjalan di Web
  if (kIsWeb) {
    // Platform WEB: WAJIB pakai 'options' manual
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        // --- PASTE KONFIGURASI ANDA DARI FIREBASE CONSOLE DI SINI ---
        apiKey: "AIzaSy... ... ...", // <-- GANTI INI
        authDomain: "pengaduan-dpppa-bjm.firebaseapp.com", // <-- GANTI INI
        projectId: "pengaduan-dpppa-bjm", // <-- GANTI INI
        storageBucket: "pengaduan-dpppa-bjm.appspot.com", // <-- GANTI INI
        messagingSenderId: "1234567890", // <-- GANTI INI
        appId: "1:1234567890:web:..." // <-- GANTI INI
      ),
    );
  } else {
    // Platform ANDROID / iOS:
    // Panggil TANPA 'options'. Dia akan otomatis membaca 'google-services.json'
    await Firebase.initializeApp();
  }
  // --- AKHIR PERBAIKAN ---

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Layanan Pengaduan DPPPA', // Nama aplikasi
      theme: ThemeData(
        // Mengatur Font Default jadi Poppins/Inter
        textTheme: GoogleFonts.poppinsTextTheme(),
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        useMaterial3: true,
      ),
      // Halaman pertama yang dibuka adalah Login
      home: const LoginScreen(),
    );
  }
}