import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final ApiService _apiService = ApiService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  final _namaController = TextEditingController();
  final _nikController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    _nikController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_isLoading) return;
    if (!_formKey.currentState!.validate()) {
      _showMessage("Harap isi semua data dengan benar.", isError: true);
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage("Konfirmasi password tidak cocok.", isError: true);
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final result = await _apiService.register(
        _emailController.text.trim(),
        _passwordController.text,
        _namaController.text.trim(),
        _nikController.text.trim(),
      );

      if (result['success'] == true && mounted) {
        _showMessage("Registrasi berhasil! Silakan login.", isError: false);
        Navigator.pop(context); // Kembali ke halaman login
      } else if (mounted) {
        _showMessage(result['message'] ?? 'Terjadi kesalahan.', isError: true);
      }
    } catch (e) {
      if (mounted) {
        _showMessage("Error: ${e.toString()}", isError: true);
      }
    } finally {
      if (mounted) {
        setState(() { _isLoading = false; });
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Daftar Akun Baru", style: AppStyles.sectionTitle.copyWith(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Buat Akun", style: AppStyles.pageTitle),
              const Text("Isi data diri Anda untuk mendaftar.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),

              _buildLabel("Nama Lengkap *"),
              TextFormField(
                controller: _namaController,
                decoration: _inputDecoration("Masukkan Nama Lengkap"),
                validator: (val) => (val == null || val.isEmpty) ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 20),
              
              _buildLabel("NIK *"),
              TextFormField(
                controller: _nikController,
                decoration: _inputDecoration("Masukkan 16 digit NIK"),
                keyboardType: TextInputType.number,
                validator: (val) => (val == null || val.length != 16) ? 'NIK harus 16 digit' : null,
              ),
              const SizedBox(height: 20),

              _buildLabel("Email *"),
              TextFormField(
                controller: _emailController,
                decoration: _inputDecoration("email@anda.com"),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => (val == null || !val.contains('@')) ? 'Email tidak valid' : null,
              ),
              const SizedBox(height: 20),

              _buildLabel("Password *"),
              TextFormField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration("Minimal 6 karakter").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.grey),
                    onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                validator: (val) => (val == null || val.length < 6) ? 'Password minimal 6 karakter' : null,
              ),
              const SizedBox(height: 20),

              _buildLabel("Konfirmasi Password *"),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: !_isPasswordVisible,
                decoration: _inputDecoration("Ulangi password"),
                validator: (val) => (val == null || val.isEmpty) ? 'Harap konfirmasi password' : null,
              ),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _handleRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text("Daftar", style: AppStyles.buttonText),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sudah punya akun? "),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Login Sekarang",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: AppStyles.formLabel),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[200]!)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary)),
    );
  }
}