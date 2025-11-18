import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Kontak Dinas",
          style: AppStyles.sectionTitle.copyWith(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- 1. GAMBAR ILUSTRASI / PETA ---
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.grey[200],
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder Peta
                  Image.network(
                    'https://media.wired.com/photos/59269cd37034dc5f91bec0f1/191:100/w_1280,c_limit/GoogleMapTA.jpg',
                    fit: BoxFit.cover,
                    errorBuilder: (c, o, s) => const Center(child: Icon(Icons.map, size: 50, color: Colors.grey)),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                      ),
                    ),
                  ),
                  // Nama Kantor di atas Peta
                  Positioned(
                    bottom: 16,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Dinas Pemberdayaan Perempuan",
                          style: AppStyles.sectionTitle.copyWith(color: Colors.white),
                        ),
                        Text(
                          "dan Perlindungan Anak",
                          style: AppStyles.sectionTitle.copyWith(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // --- 2. KONTEN INFORMASI BARU ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kontak Dinas Pemberdayaan Perempuan dan Perlindungan Anak",
                    style: AppStyles.pageTitle,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Informasi kontak dan alamat Dinas Pemberdayaan Perempuan dan Perlindungan Anak Kota Banjarmasin",
                    style: AppStyles.bodyText,
                  ),
                  const Divider(height: 30),

                  // --- ALAMAT KANTOR ---
                  _buildSectionTitle("Alamat Kantor", Icons.location_on_rounded),
                  Text(
                    "Dinas Pemberdayaan Perempuan dan Perlindungan Anak\nJl. Sultan Adam No. 18\nBanjarmasin, Kalimantan Selatan 70122",
                    style: AppStyles.bodyText.copyWith(color: Colors.black87),
                  ),
                  const SizedBox(height: 24),

                  // --- INFORMASI KONTAK ---
                  _buildSectionTitle("Informasi Kontak", Icons.contact_phone_rounded),
                  _buildContactItem("Telepon", "(0511) 3307-788"),
                  _buildContactItem("Email", "dpppa@banjarmasinkota.go.id"),
                  _buildContactItem("Website", "dpppa.banjarmasinkota.go.id"),
                  const SizedBox(height: 24),

                  // --- JAM PELAYANAN ---
                  _buildSectionTitle("Jam Pelayanan", Icons.access_time_filled_rounded),
                  _buildContactItem("Senin - Kamis", "08:00 - 16:00 WITA"),
                  _buildContactItem("Jumat", "08:00 - 11:00 WITA"),
                  _buildContactItem("Sabtu - Minggu", "Tutup"),
                  const SizedBox(height: 24),

                  // --- HOTLINE DARURAT ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.statusRejected.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.statusRejected),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hotline Darurat 24 Jam",
                          style: AppStyles.sectionTitle.copyWith(color: AppColors.statusRejected),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Kekerasan Perempuan & Anak:",
                          style: AppStyles.bodyText.copyWith(color: Colors.black87),
                        ),
                        Text(
                          "(0511) 3307-999",
                          style: AppStyles.pageTitle.copyWith(color: AppColors.statusRejected, fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper untuk Judul Section
  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppStyles.sectionTitle),
      ],
    );
  }

  // Helper untuk baris info (Telepon, Email, dll)
  Widget _buildContactItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 28), // Lurus dengan judul
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120, // Lebar label konsisten
            child: Text(label, style: AppStyles.bodyText.copyWith(color: Colors.grey[700])),
          ),
          const Text(": ", style: TextStyle(color: Colors.black87)),
          Expanded(
            child: Text(value, style: AppStyles.bodyText.copyWith(color: Colors.black87, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}