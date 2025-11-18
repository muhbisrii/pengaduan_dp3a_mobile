import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
// --- IMPORT BARU ---
import 'package:pengaduan_dp3a/services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  // --- INISIALISASI API SERVICE ---
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          "Riwayat Pengaduan",
          style: AppStyles.sectionTitle.copyWith(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        automaticallyImplyLeading: false, // Hilangkan tombol back
      ),
      // --- GUNAKAN STREAMBUILDER UNTUK DATA REAL-TIME ---
      body: StreamBuilder<QuerySnapshot>(
        // Panggil fungsi stream dari ApiService
        stream: _apiService.getStreamLaporanUser(),
        builder: (context, snapshot) {
          // 1. Saat loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Jika ada error
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi error: ${snapshot.error}"));
          }

          // 3. Jika tidak ada data / data kosong
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_toggle_off, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Belum ada riwayat pengaduan."),
                ],
              ),
            );
          }

          // 4. Jika data ada, tampilkan list
          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              // Ambil satu dokumen laporan
              final doc = docs[index];
              // Ubah data menjadi Map
              final data = doc.data() as Map<String, dynamic>;
              
              // Kirim data ke card widget
              return _buildHistoryCard(data, doc.id);
            },
          );
        },
      ),
    );
  }

  // --- Widget Card (Sekarang mengambil data dinamis) ---
  Widget _buildHistoryCard(Map<String, dynamic> data, String docId) {
    // Ambil data dari Map (pastikan nama field SAMA dengan di Firestore)
    final String status = data['status'] ?? 'Menunggu';
    final String kategori = data['kategori'] ?? 'Tidak ada Kategori';
    final String tanggal = data['tanggalKejadian'] ?? 'Tidak ada Tanggal';
    final String kronologi = data['kronologi'] ?? 'Tidak ada kronologi.';
    
    // Logika Menentukan Warna Badge berdasarkan Status
    Color statusColor;
    Color statusBgColor;
    
    switch (status) {
      case 'Diproses':
        statusColor = AppColors.statusProcess; // Biru
        statusBgColor = AppColors.statusProcess.withOpacity(0.1);
        break;
      case 'Selesai':
        statusColor = AppColors.statusDone; // Hijau
        statusBgColor = AppColors.statusDone.withOpacity(0.1);
        break;
      case 'Ditolak':
        statusColor = AppColors.statusRejected; // Merah
        statusBgColor = AppColors.statusRejected.withOpacity(0.1);
        break;
      default: // Menunggu
        statusColor = AppColors.statusPending; // Abu-abu
        statusBgColor = Colors.grey[200]!;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Baris Atas: ID Tiket & Tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: $docId", // Gunakan ID Dokumen
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                tanggal, // Gunakan tanggal dari data
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const Divider(height: 24),
          
          // Judul Kategori
          Text(
            kategori,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondary),
          ),
          const SizedBox(height: 6),
          
          // Deskripsi Singkat
          Text(
            kronologi,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),

          // Badge Status & Tombol Detail
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () {
                  // Nanti bisa diarahkan ke Detail Laporan (Gambar 9)
                  // Kita bisa kirim 'docId' ke halaman detail
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Lihat Detail >",
                    style: TextStyle(
                      fontSize: 12, 
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}