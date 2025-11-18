import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart'; // <-- Tambahkan untuk fitur Copy

class UserReportDetailScreen extends StatelessWidget {
  final String laporanId;

  const UserReportDetailScreen({
    super.key,
    required this.laporanId,
    required String reportId, // tetap dipertahankan agar tidak error pada route sebelumnya
  });

  Future<DocumentSnapshot> _getReportDetails() {
    return FirebaseFirestore.instance
        .collection('laporan')
        .doc(laporanId)
        .get();
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return DateFormat('dd MMMM yyyy, HH:mm').format(timestamp.toDate());
    }
    return timestamp?.toString() ?? 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    if (laporanId.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Detail Laporan"),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const Center(
          child: Text("ID Laporan tidak valid. Silakan kembali."),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Detail Laporan Anda",
            style: AppStyles.sectionTitle.copyWith(color: Colors.black)),
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
            return Center(child: Text("Error memuat data: ${snapshot.error}"));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
                child: Text("Laporan tidak ditemukan. ID mungkin tidak valid."));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final status = data['status'] ?? 'Menunggu';
          final tanggapan = data['tanggapanPetugas'] as String?;

          final dibuatPada = data['dibuatPada'];
          final tanggalKejadian = data['tanggalKejadian'];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusCard(context, status, laporanId),
                const SizedBox(height: 20),

                _buildSection("Waktu Pelaporan", children: [
                  _buildInfoRow("Dibuat Pada", _formatTimestamp(dibuatPada)),
                ]),
                const SizedBox(height: 20),

                _buildSection("Detail Laporan Anda", children: [
                  _buildInfoRow("Kategori", data['kategori'] ?? 'N/A'),
                  _buildInfoRow("Tanggal Kejadian",
                      _formatTimestamp(tanggalKejadian)),
                  _buildInfoRow("Lokasi", data['lokasi'] ?? 'N/A'),
                  _buildInfoRow("Kronologi", data['kronologi'] ?? 'N/A',
                      isKronologi: true),
                ]),

                _buildSection("Tanggapan Petugas", children: [
                  (tanggapan == null || tanggapan.isEmpty)
                      ? const Text(
                          "Laporan Anda sedang ditinjau. Petugas akan segera memberikan tanggapan.",
                          style: TextStyle(
                              color: Colors.grey, fontStyle: FontStyle.italic),
                        )
                      : Text(
                          tanggapan,
                          style: AppStyles.bodyText
                              .copyWith(color: Colors.black87),
                        ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value,
      {bool isKronologi = false}) {
    if (isKronologi) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child:
                  Text(label, style: const TextStyle(color: Colors.grey))),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  // -------------------------------
  // Fitur: STATUS + COPY ID LAPORAN
  // -------------------------------
  Widget _buildStatusCard(BuildContext context, String status, String docId) {
    Color statusColor;
    Color iconColor;
    IconData statusIcon;

    switch (status) {
      case 'Diproses':
        statusColor = AppColors.statusProcess;
        iconColor = Colors.orange.shade800;
        statusIcon = Icons.hourglass_top;
        break;
      case 'Selesai':
        statusColor = AppColors.statusDone;
        iconColor = Colors.green.shade800;
        statusIcon = Icons.check_circle_outline;
        break;
      case 'Ditolak':
        statusColor = AppColors.statusRejected;
        iconColor = Colors.red.shade800;
        statusIcon = Icons.cancel_outlined;
        break;
      default:
        statusColor = AppColors.statusPending;
        iconColor = Colors.blue.shade800;
        statusIcon = Icons.pending_actions;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(statusIcon, color: iconColor, size: 28),
          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Status: ${status.toUpperCase()}",
                  style: AppStyles.sectionTitle.copyWith(
                    color: iconColor,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),

                // --- ID + COPY BUTTON ---
                Row(
                  children: [
                    Text(
                      "ID: $docId",
                      style: TextStyle(
                          fontSize: 12, color: iconColor.withOpacity(0.9)),
                    ),
                    const SizedBox(width: 8),
                    
                    GestureDetector(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: docId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("ID Laporan berhasil disalin!"),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      child: const Icon(Icons.copy, size: 18, color: Colors.black87),
                    )
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
