import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ContactScreen extends StatelessWidget {
  final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..loadFlutterAsset('assets/maps/maps.html');

  ContactScreen({super.key});

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

      body: Column(
        children: [

          /// MAP DIPISAH DARI SCROLLVIEW — FIX MASALAH HEIGHT
          SizedBox(
            width: double.infinity,
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: WebViewWidget(controller: _controller),
            ),
          ),

          /// SISANYA BOLEH SCROLL
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
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

                    _buildSectionTitle("Alamat Kantor", Icons.location_on_rounded),
                    Text(
                      "Dinas Pemberdayaan Perempuan dan Perlindungan Anak\n"
                      "Jl. Sultan Adam No. 18\n"
                      "Banjarmasin, Kalimantan Selatan 70122",
                      style: AppStyles.bodyText.copyWith(color: Colors.black87),
                    ),
                    const SizedBox(height: 24),

                    _buildSectionTitle("Informasi Kontak", Icons.contact_phone_rounded),
                    _buildContactItem("Telepon", "(0511) 3307-788"),
                    _buildContactItem("Email", "dpppa@banjarmasinkota.go.id"),
                    _buildContactItem("Website", "dpppa.banjarmasinkota.go.id"),
                    const SizedBox(height: 24),

                    _buildSectionTitle("Jam Pelayanan", Icons.access_time_filled_rounded),
                    _buildContactItem("Senin - Kamis", "08:00 - 16:00 WITA"),
                    _buildContactItem("Jumat", "08:00 - 11:00 WITA"),
                    _buildContactItem("Sabtu - Minggu", "Tutup"),
                    const SizedBox(height: 24),

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
                            style: AppStyles.sectionTitle.copyWith(
                              color: AppColors.statusRejected,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Kekerasan Perempuan & Anak:",
                            style: AppStyles.bodyText.copyWith(color: Colors.black87),
                          ),
                          Text(
                            "(0511) 3307-999",
                            style: AppStyles.pageTitle.copyWith(
                              color: AppColors.statusRejected,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: AppStyles.sectionTitle),
      ],
    );
  }

  Widget _buildContactItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 28),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppStyles.bodyText.copyWith(color: Colors.grey[700]),
            ),
          ),
          const Text(": ", style: TextStyle(color: Colors.black87)),
          Expanded(
            child: Text(
              value,
              style: AppStyles.bodyText.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
