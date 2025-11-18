import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/services/api_service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final ApiService _apiService = ApiService();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _handleResetPassword() async {
    if (_isLoading) return;
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      _showMessage("Harap masukkan alamat email yang valid.", isError: true);
      return;
    }

    setState(() { _isLoading = true; });

    try {
      final result = await _apiService.forgotPassword(_emailController.text.trim());
      if (result['success'] == true && mounted) {
        _showMessage("Link reset password telah dikirim ke email Anda. Silakan cek inbox/spam.", isError: false);
        Navigator.pop(context); // Kembali ke login
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Lupa Kata Sandi", style: AppStyles.pageTitle),
            const Text(
              "Masukkan email Anda. Kami akan mengirimkan link untuk mengatur ulang kata sandi Anda.",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email Terdaftar",
                prefixIcon: Icon(Icons.email_outlined, color: Colors.grey),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _handleResetPassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text("Kirim Link Reset", style: AppStyles.buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}