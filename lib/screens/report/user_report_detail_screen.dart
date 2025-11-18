import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserReportDetailScreen extends StatelessWidget {
  final String laporanId;
  const UserReportDetailScreen({super.key, required this.laporanId});

  // Fungsi untuk mengambil data detail laporan
  Future<DocumentSnapshot> _getReportDetails() {
    return FirebaseFirestore.instance
        .collection('laporan')
        .doc(laporanId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Detail Laporan Anda", style: AppStyles.sectionTitle.copyWith(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _getReportDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("Laporan tidak ditemukan."));
          }

          // Data ditemukan, kita tampilkan
          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'] ?? 'N/A';
          final tanggapan = data['tanggapanPetugas'] as String?;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(status, laporanId), // Tampilkan Status
                const SizedBox(height: 20),

                _buildSection("Detail Laporan Anda", children: [
                  _buildInfoRow("Kategori", data['kategori'] ?? 'N/A'),
                  _buildInfoRow("Tanggal Kejadian", data['tanggalKejadian'] ?? 'N/A'),
                  _buildInfoRow("Lokasi", data['lokasi'] ?? 'N/A'),
                  _buildInfoRow("Kronologi", data['kronologi'] ?? 'N/A'),
                ]),
                
                // --- BAGIAN PALING PENTING: TANGGAPAN ADMIN ---
                _buildSection("Tanggapan Petugas", children: [
                  (tanggapan == null || tanggapan.isEmpty)
                  ? const Text(
                      "Laporan Anda sedang ditinjau. Petugas akan segera memberikan tanggapan.",
                      style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
                    )
                  : Text(
                      tanggapan,
                      style: AppStyles.bodyText.copyWith(color: Colors.black87),
                    ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper Widget untuk Section
  Widget _buildSection(String title, {required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppStyles.sectionTitle),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children
            ),
          ),
        ],
      ),
    );
  }

  // Helper Widget untuk Baris Info
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.grey))),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // Helper Widget untuk Kartu Status
  Widget _buildStatusCard(String status, String docId) {
    Color statusColor;
    switch (status) {
      case 'Diproses': statusColor = AppColors.statusProcess; break;
      case 'Selesai': statusColor = AppColors.statusDone; break;
      case 'Ditolak': statusColor = AppColors.statusRejected; break;
      default: statusColor = AppColors.statusPending;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Status: ${status.toUpperCase()}", style: AppStyles.sectionTitle.copyWith(color: statusColor)),
          const SizedBox(height: 5),
          Text("ID Laporan: $docId", style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}