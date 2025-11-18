// FIXED VERSION OF ReportDetailScreen
// Perbaikan utama: Menambahkan status 'Menunggu' + Loading saat kirim tanggapan

import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportDetailScreen extends StatefulWidget {
  final String laporanId;
  const ReportDetailScreen({super.key, required this.laporanId});

  @override
  State<ReportDetailScreen> createState() => _ReportDetailScreenState();
}

class _ReportDetailScreenState extends State<ReportDetailScreen> {
  String? _selectedStatus;

  final List<String> _statusOptions = [
    'Menunggu',
    'Diproses',
    'Selesai',
    'Ditolak',
  ];

  final TextEditingController _tanggapanController = TextEditingController();
  bool _isLoading = false;

  Future<DocumentSnapshot> _getReportDetails() {
    return FirebaseFirestore.instance
        .collection('laporan')
        .doc(widget.laporanId)
        .get();
  }

  Future<void> _submitTanggapan() async {
    if (_selectedStatus == null || _tanggapanController.text.isEmpty) {
      _showMessage(
        "Status dan Catatan Tanggapan tidak boleh kosong.",
        isError: true,
        context: context,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance
          .collection('laporan')
          .doc(widget.laporanId)
          .update({
        'status': _selectedStatus,
        'tanggapanPetugas': _tanggapanController.text,
        'ditanggapiPada': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        _showMessage("Tanggapan berhasil dikirim!",
            isError: false, context: context);
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showMessage(
          "Gagal mengirim tanggapan: ${e.toString()}",
          isError: true,
          context: context,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text("Detail Pengaduan", style: AppStyles.sectionTitle),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
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

          final data = snapshot.data!.data() as Map<String, dynamic>;

          _selectedStatus ??= data['status'] ?? 'Menunggu';
          _tanggapanController.text = data['tanggapanPetugas'] ?? '';

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildStatusCard(_selectedStatus!),
                      const SizedBox(height: 20),
                      _buildSection("Data Pelapor", children: [
                        _buildInfoRow(
                            "Email Pelapor", data['emailPelapor'] ?? 'N/A'),
                      ]),
                      _buildSection("Detail Kejadian", children: [
                        _buildInfoRow("Kategori", data['kategori'] ?? 'N/A'),
                        _buildInfoRow("Tanggal Kejadian",
                            data['tanggalKejadian'] ?? 'N/A'),
                        _buildInfoRow("Lokasi", data['lokasi'] ?? 'N/A'),
                        _buildInfoRow("Kronologi", data['kronologi'] ?? 'N/A'),
                      ]),
                      _buildSection("Bukti Foto", children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.image_not_supported,
                                    color: Colors.grey, size: 50),
                                Text("Tidak ada foto terlampir",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),

              // ==========================
              //     BAGIAN KIRIM TANGGAPAN
              // ==========================
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tanggapi Laporan", style: AppStyles.sectionTitle),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      initialValue: _selectedStatus,
                      items: _statusOptions.map((String status) {
                        return DropdownMenuItem(
                            value: status, child: Text(status));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedStatus = val),
                      decoration: const InputDecoration(
                        labelText: "Ubah Status Laporan",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 16),

                    TextField(
                      controller: _tanggapanController,
                      decoration: const InputDecoration(
                        labelText: "Tulis Catatan Tanggapan",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _submitTanggapan,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 26,
                                width: 26,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : Text("Kirim Tanggapan",
                                style: AppStyles.buttonText),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(label, style: const TextStyle(color: Colors.grey))),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildStatusCard(String status) {
    Color statusColor;
    switch (status) {
      case 'Diproses':
        statusColor = AppColors.statusProcess;
        break;
      case 'Selesai':
        statusColor = AppColors.statusDone;
        break;
      case 'Ditolak':
        statusColor = AppColors.statusRejected;
        break;
      default:
        statusColor = AppColors.statusPending;
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
          Text("Status: ${status.toUpperCase()}",
              style: AppStyles.sectionTitle.copyWith(color: statusColor)),
          const SizedBox(height: 5),
          Text("ID Laporan: ${widget.laporanId}",
              style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  void _showMessage(String message,
      {required BuildContext context, bool isError = true}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }
}
