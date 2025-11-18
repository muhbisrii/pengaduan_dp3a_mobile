import 'package:flutter/material.dart';

// PASTIKAN NAMA CLASS-NYA "AppColors" (A besar, C besar)
class AppColors {
  // Warna Utama sesuai Desain
  static const Color primary = Color(0xFF009688); // Teal/Hijau Tosca
  static const Color secondary = Color(0xFF1A233A); // Navy Gelap (Header)
  static const Color background = Color(0xFFF5F7FA); // Abu-abu muda (Background)
  
  // Warna Status Laporan
  static const Color statusPending = Color(0xFF757575); // Menunggu (Abu/Hitam pudar)
  static const Color statusProcess = Color(0xFF2196F3); // Diproses (Biru)
  static const Color statusDone = Color(0xFF4CAF50);    // Selesai (Hijau)
  static const Color statusRejected = Color(0xFFE53935); // Ditolak (Merah)
  
  // Warna Teks
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}