import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/colors.dart';

class TrackReportScreen extends StatefulWidget {
  const TrackReportScreen({super.key});

  @override
  State<TrackReportScreen> createState() => _TrackReportScreenState();
}

class _TrackReportScreenState extends State<TrackReportScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  Map<String, dynamic>? _foundData;
  String? _errorMessage;

  // 🔥 Fungsi untuk mencari data laporan di Firestore + efek loading
  Future<void> _handleSearch() async {
    final inputId = _searchController.text.trim();

    if (inputId.isEmpty) {
      setState(() {
        _errorMessage = "Masukkan ID laporan terlebih dahulu.";
        _foundData = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _foundData = null;
    });

    try {
      // 👉 Tambahkan delay agar terlihat loading "seperti online"
      await Future.delayed(const Duration(seconds: 2));

      final doc = await FirebaseFirestore.instance
          .collection('laporan')
          .doc(inputId)
          .get();

      setState(() {
        _isSearching = false;

        if (!doc.exists) {
          _errorMessage =
              "Nomor Tiket tidak ditemukan. Mohon periksa kembali.";
          return;
        }

        _foundData = doc.data()!;
        _foundData!['id'] = doc.id;
      });
    } catch (e) {
      setState(() {
        _isSearching = false;
        _errorMessage = "Terjadi kesalahan: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Lacak Status",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search_rounded,
                    size: 60, color: AppColors.primary),
              ),
            ),

            const SizedBox(height: 30),

            const Text("Masukkan ID Laporan",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Cek perkembangan pengaduan Anda secara real-time.",
                style: TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),

            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Contoh: abc123xyz",
                prefixIcon: const Icon(Icons.qr_code, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSearching ? null : _handleSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _isSearching
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2.3),
                      )
                    : const Text("Lacak Sekarang",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),

            const SizedBox(height: 40),

            if (_isSearching)
              Center(
                child: Column(
                  children: const [
                    SizedBox(height: 10),
                    CircularProgressIndicator(),
                    SizedBox(height: 12),
                    Text("Mengambil data dari server...",
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),

            if (_errorMessage != null && !_isSearching)
              Center(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 40),
                    const SizedBox(height: 10),
                    Text(_errorMessage!,
                        style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),

            if (_foundData != null && !_isSearching)
              _buildResultCard(_foundData!),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> data) {
    final status = data['status'] ?? 'Menunggu';
    Color statusColor = Colors.blue;

    if (status == "Selesai") statusColor = AppColors.statusDone;
    if (status == "Diproses") statusColor = AppColors.statusProcess;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 5)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Status Terkini",
                  style: TextStyle(color: Colors.grey)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                      color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const Divider(height: 30),

          _buildRowInfo("ID Laporan", data['id']),
          _buildRowInfo("Kategori", data['kategori'] ?? "Tidak ada"),
          _buildRowInfo("Lokasi", data['lokasi'] ?? "Tidak ada"),
          _buildRowInfo("Tanggal", data['dibuatPada']?.toString() ?? "-"),

          const SizedBox(height: 10),
          const Text("Catatan Petugas:",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              data['tanggapanPetugas'] ?? "Belum ada tanggapan.",
              style: const TextStyle(color: Colors.black87, fontSize: 13),
            ),
          )
        ],
      ),
    );
  }

  // ✔ teks panjang otomatis wrap
  Widget _buildRowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ),
        ],
      ),
    );
  }
}
