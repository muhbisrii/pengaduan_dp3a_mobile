import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/screens/admin/report_detail_screen.dart';
import 'package:pengaduan_dp3a/services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AdminDashboardTab extends StatefulWidget {
  final String namaPengguna;

  const AdminDashboardTab({super.key, required this.namaPengguna});

  @override
  State<AdminDashboardTab> createState() => _AdminDashboardTabState();
}

class _AdminDashboardTabState extends State<AdminDashboardTab> {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100.0),
        child: AppBar(
          backgroundColor: AppColors.secondary,
          elevation: 0,
          automaticallyImplyLeading: false,
          flexibleSpace: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 35,
                        errorBuilder: (c, o, s) => const Icon(Icons.error, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "DP3A Banjarmasin",
                            style: AppStyles.bodyText
                                .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Portal Pengaduan",
                            style: AppStyles.bodyText.copyWith(
                                color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0).copyWith(bottom: 8.0),
                  child: Text(
                    "Selamat datang, ${widget.namaPengguna}",
                    style: AppStyles.sectionTitle
                        .copyWith(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- TITLE + REFRESH ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Ringkasan Laporan",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {}); // <-- BENAR-BENAR REFRESH
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),

            _buildStatistikStream(),

            const SizedBox(height: 25),

            // --- TITLE + REFRESH ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Perlu Tindakan (Menunggu)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    setState(() {}); // <-- BENAR-BENAR REFRESH
                  },
                ),
              ],
            ),
            const SizedBox(height: 15),

            _buildPerluTindakanStream(),
          ],
        ),
      ),
    );
  }

  // === STREAM STATISTIK ===
  Widget _buildStatistikStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: _apiService.getStreamStatistikAdmin(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        int masuk = 0;
        int diproses = 0;
        int selesai = 0;
        int ditolak = 0;

        for (var doc in snapshot.data!.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final status = data['status'];

          if (status == 'Menunggu') masuk++;
          else if (status == 'Diproses') diproses++;
          else if (status == 'Selesai') selesai++;
          else if (status == 'Ditolak') ditolak++;
        }

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            _buildStatCard("Laporan Masuk", masuk.toString(), Colors.orange, Icons.inbox),
            _buildStatCard("Diproses", diproses.toString(), Colors.blue, Icons.sync),
            _buildStatCard("Selesai", selesai.toString(), Colors.green, Icons.check_circle),
            _buildStatCard("Ditolak", ditolak.toString(), Colors.red, Icons.cancel),
          ],
        );
      },
    );
  }

  // === STREAM PERLU TINDAKAN ===
  Widget _buildPerluTindakanStream() {
    return StreamBuilder<QuerySnapshot>(
      stream: _apiService.getStreamLaporanAdmin('Menunggu'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Tidak ada laporan yang perlu ditindaklanjuti."));
        }

        final docs = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            final doc = docs[index];
            final data = doc.data() as Map<String, dynamic>;
            return _buildTaskItem(context, data, doc.id);
          },
        );
      },
    );
  }

  // === WIDGET KARTU STATISTIK ===
  Widget _buildStatCard(String title, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5, offset: const Offset(0, 2)),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 24),
              Text(count,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          Text(title,
              style:
                  const TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  // === WIDGET ITEM LAPORAN ===
  Widget _buildTaskItem(BuildContext context, Map<String, dynamic> data, String docId) {
    final kategori = data['kategori'] ?? 'N/A';
    final email = data['emailPelapor'] ?? 'N/A';

    final String tanggal;
    if (data['dibuatPada'] != null) {
      tanggal = DateFormat('d MMM yyyy, HH:mm', 'id_ID')
          .format((data['dibuatPada'] as Timestamp).toDate());
    } else {
      tanggal = 'N/A';
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReportDetailScreen(laporanId: docId)),
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
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.crisis_alert, color: Colors.orange),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(kategori, style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text("Pelapor: $email • $tanggal",
                      style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
