import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/services/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pengaduan_dp3a/screens/report/user_report_detail_screen.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  State<HistoryTab> createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final ApiService _apiService = ApiService();

  Future<void> _refresh() async {
    // Firestore StreamBuilder akan otomatis listen, sehingga cukup panggil setState
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 500)); 
  }

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
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _apiService.getStreamLaporanUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Terjadi error: ${snapshot.error}"));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: const [
                  SizedBox(height: 200),
                  Center(
                    child: Column(
                      children: [
                        Icon(Icons.history_toggle_off, size: 60, color: Colors.grey),
                        SizedBox(height: 10),
                        Text("Belum ada riwayat pengaduan."),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }

          final docs = snapshot.data!.docs;

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: docs.length,
              itemBuilder: (context, index) {
                final doc = docs[index];
                final data = doc.data() as Map<String, dynamic>;
                return _buildHistoryCard(data, doc.id);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHistoryCard(Map<String, dynamic> data, String docId) {
    final String status = data['status'] ?? 'Menunggu';
    final String kategori = data['kategori'] ?? 'Tidak ada Kategori';

    String tanggal = 'Tidak ada Tanggal';
    try {
      final timestamp = data['dibuatPada'] as Timestamp;
      final DateTime dateTime = timestamp.toDate();
      tanggal = "${dateTime.day} ${getMonthName(dateTime.month)} ${dateTime.year}, ${dateTime.hour}:${dateTime.minute}";
    } catch (e) {
      tanggal = data['tanggalKejadian'] ?? 'Tanggal Tidak Dikenal';
    }

    final String kronologi = data['kronologi'] ?? 'Tidak ada kronologi.';

    Color statusColor;
    Color statusBgColor;

    switch (status) {
      case 'Diproses':
        statusColor = AppColors.statusProcess;
        statusBgColor = AppColors.statusProcess.withOpacity(0.1);
        break;
      case 'Selesai':
        statusColor = AppColors.statusDone;
        statusBgColor = AppColors.statusDone.withOpacity(0.1);
        break;
      case 'Ditolak':
        statusColor = AppColors.statusRejected;
        statusBgColor = AppColors.statusRejected.withOpacity(0.1);
        break;
      default:
        statusColor = AppColors.statusPending;
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ID: ${docId.substring(0, 8).toUpperCase()}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: Colors.grey),
              ),
              Text(
                tanggal,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const Divider(height: 24),

          Text(
            kategori,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.secondary),
          ),

          const SizedBox(height: 6),

          Text(
            kronologi,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),

          const SizedBox(height: 16),

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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserReportDetailScreen(laporanId: docId, reportId: ''),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    "Lihat Detail >",
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  String getMonthName(int month) {
    switch (month) {
      case 1: return 'Jan';
      case 2: return 'Feb';
      case 3: return 'Mar';
      case 4: return 'Apr';
      case 5: return 'Mei';
      case 6: return 'Jun';
      case 7: return 'Jul';
      case 8: return 'Agu';
      case 9: return 'Sep';
      case 10: return 'Okt';
      case 11: return 'Nov';
      case 12: return 'Des';
      default: return '';
    }
  }
}
