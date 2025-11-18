import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/services/api_service.dart'; // <-- IMPORT BARU
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';// <-- IMPORT BARU
import '../report_detail_screen.dart'; 

class ReportManagementTab extends StatefulWidget {
  const ReportManagementTab({super.key});

  @override
  State<ReportManagementTab> createState() => _ReportManagementTabState();
}

class _ReportManagementTabState extends State<ReportManagementTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ApiService _apiService = ApiService(); // <-- TAMBAHKAN API SERVICE

  // --- HAPUS LIST DUMMY '_allReports' ---

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this); 
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // --- HAPUS FUNGSI '_getFilteredReports' ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Manajemen Laporan", style: AppStyles.sectionTitle.copyWith(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        // Tab Filter (Tidak Berubah)
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: AppColors.primary,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppColors.primary,
          tabs: const [
            Tab(text: "Semua"),
            Tab(text: "Menunggu"),
            Tab(text: "Diproses"),
            Tab(text: "Selesai"),
            Tab(text: "Ditolak"),
          ],
        ),
      ),
      // --- PERUBAHAN BODY: MENGGUNAKAN STREAM DI TIAP TAB ---
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildReportList('Semua'),
          _buildReportList('Menunggu'),
          _buildReportList('Diproses'),
          _buildReportList('Selesai'),
          _buildReportList('Ditolak'),
        ],
      ),
    );
  }

  // --- WIDGET BARU: MENGGUNAKAN STREAMBUILDER ---
  Widget _buildReportList(String status) {
    return StreamBuilder<QuerySnapshot>(
      stream: _apiService.getStreamLaporanAdmin(status),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("Tidak ada data laporan '$status'."));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            // Kirim data dan doc.id ke card
            return _buildReportCard(context, data, doc.id);
          },
        );
      },
    );
  }

  // --- WIDGET CARD DIPERBARUI (MENERIMA DATA ASLI) ---
  Widget _buildReportCard(BuildContext context, Map<String, dynamic> data, String docId) {
    final status = data['status'] ?? 'N/A';
    final kategori = data['kategori'] ?? 'N/A';
    // Ambil tanggal dari 'dibuatPada' (Timestamp) dan format
    final String tanggal;
    if (data['dibuatPada'] != null) {
      tanggal = DateFormat('d MMM yyyy, HH:mm', 'id_ID')
          .format((data['dibuatPada'] as Timestamp).toDate());
    } else {
      tanggal = 'N/A';
    }

    final statusInfo = _getStatusInfo(status);

    return GestureDetector(
      onTap: () {
        // --- KIRIM ID DOKUMEN KE HALAMAN DETAIL ---
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReportDetailScreen(laporanId: docId)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(docId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey), overflow: TextOverflow.ellipsis)),
                Text(tanggal, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Text(
                    kategori,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusInfo['bgColor'],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusInfo['color'], fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper warna (Tidak berubah)
  Map<String, Color> _getStatusInfo(String status) {
    switch (status) {
      case 'Diproses':
        return {'color': AppColors.statusProcess, 'bgColor': AppColors.statusProcess.withOpacity(0.1)};
      case 'Selesai':
        return {'color': AppColors.statusDone, 'bgColor': AppColors.statusDone.withOpacity(0.1)};
      case 'Ditolak':
        return {'color': AppColors.statusRejected, 'bgColor': AppColors.statusRejected.withOpacity(0.1)};
      default: // Menunggu
        return {'color': AppColors.statusPending, 'bgColor': Colors.grey[200]!};
    }
  }
}