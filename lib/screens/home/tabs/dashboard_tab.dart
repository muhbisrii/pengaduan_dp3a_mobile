import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/screens/report/create_report_screen.dart';
import 'package:pengaduan_dp3a/screens/report/track_report_screen.dart';
import 'package:pengaduan_dp3a/screens/info/contact_screen.dart';

class DashboardTab extends StatefulWidget {
  final String namaPengguna;
  const DashboardTab({super.key, required this.namaPengguna});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  int diproses = 0;
  int selesai = 0;
  int ditolak = 0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final query = await FirebaseFirestore.instance
        .collection('laporan')
        .where('userId', isEqualTo: user.uid)
        .get();

    int p = 0;
    int s = 0;
    int t = 0;

    for (var doc in query.docs) {
      final status = (doc['status'] ?? "").toString().toLowerCase();

      if (status == "diproses") p++;
      if (status == "selesai") s++;
      if (status == "ditolak") t++;
    }

    setState(() {
      diproses = p;
      selesai = s;
      ditolak = t;
    });
  }

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
                            style: AppStyles.bodyText.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Portal Pengaduan",
                            style: AppStyles.bodyText.copyWith(color: Colors.white70, fontSize: 12),
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
                    style: AppStyles.sectionTitle.copyWith(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // BANNER DARURAT — TIDAK DIUBAH
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE53935), Color(0xFFFF5252)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE53935).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "DARURAT 24 JAM",
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Butuh Bantuan \nSegera?",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.phone, size: 16, color: Color(0xFFE53935)),
                          label: const Text("Hubungi 112",
                              style: TextStyle(color: Color(0xFFE53935), fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFFE53935),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                            minimumSize: const Size(0, 36),
                          ),
                        )
                      ],
                    ),
                  ),
                  const Icon(Icons.support_agent_rounded, size: 80, color: Colors.white24),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // LAYANAN UTAMA — TIDAK DIUBAH
            const Text("Layanan Utama", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.85,
              children: [
                _buildMenuCard(
                  context,
                  title: "Buat\nPengaduan",
                  icon: Icons.edit_document,
                  color: Colors.orange,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const CreateReportScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  title: "Cek\nStatus",
                  icon: Icons.track_changes,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => const TrackReportScreen()));
                  },
                ),
                _buildMenuCard(
                  context,
                  title: "Kontak\nDinas",
                  icon: Icons.contact_phone,
                  color: Colors.green,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => ContactScreen()));
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ⭐⭐⭐ BAGIAN STATISTIK — HANYA BAGIAN INI YANG BERUBAH ⭐⭐⭐
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Statistik Laporan Anda", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatItem(diproses.toString(), "Diproses", Colors.blue),
                      _buildStatItem(selesai.toString(), "Selesai", Colors.green),
                      _buildStatItem(ditolak.toString(), "Ditolak", Colors.red),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET ASLI — TIDAK DIUBAH

  Widget _buildMenuCard(
    BuildContext context,
    {required String title, required IconData icon, required Color color, required VoidCallback onTap}
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String count, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}
