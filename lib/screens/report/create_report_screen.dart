import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
// --- IMPORT BARU ---
import 'package:pengaduan_dp3a/services/api_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateReportScreen extends StatefulWidget {
  const CreateReportScreen({super.key});

  @override
  State<CreateReportScreen> createState() => _CreateReportScreenState();
}

class _CreateReportScreenState extends State<CreateReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isChecked = false;

  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _lokasiController = TextEditingController();
  final TextEditingController _kronologiController = TextEditingController();
  String? _selectedCategory;

  final User? _currentUser = FirebaseAuth.instance.currentUser;

  final List<String> _categories = [
    'Kekerasan Fisik',
    'Kekerasan Psikis',
    'Kekerasan Seksual',
    'Penelantaran',
    'Lainnya'
  ];

  @override
  void dispose() {
    _dateController.dispose();
    _lokasiController.dispose();
    _kronologiController.dispose();
    super.dispose();
  }

  // --- FUNGSI PILIH TANGGAL ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // --- FUNGSI KIRIM LAPORAN (DIPERBAIKI LOADINGNYA) ---
  Future<void> _handleKirimLaporan() async {
    if (_isLoading) return; // ⛔ cegah double-click submit

    if (!_formKey.currentState!.validate()) {
      _showMessage("Harap isi semua data yang wajib diisi.", isError: true);
      return;
    }
    if (!_isChecked) {
      _showMessage("Anda harus menyetujui pernyataan di bawah.", isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      bool success = await _apiService.kirimLaporan(
        kategori: _selectedCategory!,
        tanggalKejadian: _dateController.text,
        lokasi: _lokasiController.text,
        kronologi: _kronologiController.text,
      );

      if (success && mounted) {
        _showMessage("Laporan Anda berhasil dikirim.", isError: false);
        Navigator.pop(context);
      } else if (mounted) {
        _showMessage("Gagal mengirim laporan. Coba lagi.", isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showMessage("Terjadi error: ${e.toString()}", isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Buat Pengaduan",
          style: AppStyles.sectionTitle.copyWith(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Data Pelapor", style: AppStyles.sectionTitle),
                    const SizedBox(height: 10),
                    _buildReadOnlyField(
                        "Email Pelapor", _currentUser?.email ?? 'Tidak Ditemukan'),
                    const Divider(height: 40, thickness: 1),

                    Text("Detail Kejadian", style: AppStyles.sectionTitle),
                    const SizedBox(height: 15),

                    _buildLabel("Kategori Kekerasan *"),
                    DropdownButtonFormField<String>(
                      decoration: _inputDecoration("Pilih kategori kekerasan"),
                      value: _selectedCategory,
                      items: _categories.map((String category) {
                        return DropdownMenuItem(
                            value: category, child: Text(category));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedCategory = val),
                      validator: (val) =>
                          val == null ? 'Harap pilih kategori' : null,
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Tanggal Kejadian *"),
                    TextFormField(
                      controller: _dateController,
                      readOnly: true,
                      onTap: () => _selectDate(context),
                      decoration: _inputDecoration("Pilih tanggal kejadian")
                          .copyWith(
                        suffixIcon: const Icon(Icons.calendar_today,
                            color: Colors.grey),
                      ),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Tanggal wajib diisi' : null,
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Lokasi Kejadian *"),
                    TextFormField(
                      controller: _lokasiController,
                      maxLines: 2,
                      decoration:
                          _inputDecoration("Masukkan alamat lengkap kejadian"),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Lokasi wajib diisi' : null,
                    ),
                    const SizedBox(height: 15),

                    _buildLabel("Kronologi Singkat *"),
                    TextFormField(
                      controller: _kronologiController,
                      maxLines: 5,
                      decoration: _inputDecoration(
                          "Ceritakan kronologi kejadian secara singkat..."),
                      validator: (val) =>
                          (val == null || val.isEmpty) ? 'Kronologi wajib diisi' : null,
                    ),
                    const SizedBox(height: 20),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        "Saya menyatakan bahwa data yang saya isi adalah benar dan dapat dipertanggungjawabkan.",
                        style: TextStyle(fontSize: 12),
                      ),
                      value: _isChecked,
                      activeColor: AppColors.primary,
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: (val) {
                        setState(() => _isChecked = val!);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          // --- TOMBOL KIRIM Laporan DENGAN LOADING ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: const Offset(0, -5))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      (_isChecked && !_isLoading) ? AppColors.primary : Colors.grey,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed:
                    (_isChecked && !_isLoading) ? _handleKirimLaporan : null,
                child: _isLoading
                    ? const SizedBox(
                        height: 26,
                        width: 26,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          color: Colors.white,
                        ),
                      )
                    : Text("Kirim Laporan", style: AppStyles.buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: AppStyles.formLabel),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey[300]!)),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: AppColors.primary)),
      errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.red)),
      focusedErrorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(color: Colors.red)),
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 120,
              child: Text(label, style: const TextStyle(color: Colors.grey))),
          const Text(": ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child:
                  Text(value, style: const TextStyle(fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }
}
