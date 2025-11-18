import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// --- PERBAIKAN DI SINI ---
import 'package:pengaduan_dp3a/core/colors.dart'; // Menggunakan jalur absolut

class AppStyles {
  // --- Judul Halaman ---
  static final TextStyle pageTitle = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary, // Ini akan hijau lagi
  );

  // --- Sub-Judul atau Judul Section ---
  static final TextStyle sectionTitle = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // --- Teks Isi / Body ---
  static final TextStyle bodyText = GoogleFonts.poppins(
    fontSize: 14,
    color: AppColors.textSecondary,
    height: 1.5, // Jarak antar baris
  );

  // --- Label untuk Form Input ---
  static final TextStyle formLabel = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );
  
  // --- Teks untuk Tombol ---
  static final TextStyle buttonText = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
}