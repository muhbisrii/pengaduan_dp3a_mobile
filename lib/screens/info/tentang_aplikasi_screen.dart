import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/styles.dart';

class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Tentang Aplikasi", style: AppStyles.sectionTitle.copyWith(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png', // Logo Anda
                height: 100,
              ),
              const SizedBox(height: 20),
              Text(
                "Layanan Pengaduan DPPPA Banjarmasin",
                style: AppStyles.pageTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "Versi 1.0.0 (Build 1)",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 20),
              Text(
                "Aplikasi ini dibuat untuk memudahkan masyarakat Kota Banjarmasin dalam melaporkan kejadian kekerasan terhadap perempuan dan anak. Dikelola oleh Dinas Pemberdayaan Perempuan dan Perlindungan Anak Kota Banjarmasin.",
                style: AppStyles.bodyText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                "© 2025 - DPPPA Kota Banjarmasin",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}