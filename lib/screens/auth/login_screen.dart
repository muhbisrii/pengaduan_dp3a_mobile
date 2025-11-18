import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/screens/home/home_screen.dart';
import 'package:pengaduan_dp3a/screens/admin/admin_home_screen.dart';
import 'package:pengaduan_dp3a/services/api_service.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'package:shared_preferences/shared_preferences.dart'; // <-- IMPORT BARU

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _checkingAutoLogin = true; // <-- TAMBAHAN STATUS LOADING AWAL

  @override
  void initState() {
    super.initState();
    _loadSavedLogin();
  }

  // ---- AUTOFILL + AUTO LOGIN ----
  void _loadSavedLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('saved_email');
    String? savedPassword = prefs.getString('saved_password');

    if (savedEmail != null) _emailController.text = savedEmail;
    if (savedPassword != null) _passwordController.text = savedPassword;

    // Jika ada email & password tersimpan → LANGSUNG LOGIN OTOMATIS
    if (savedEmail != null && savedPassword != null) {
      await Future.delayed(const Duration(milliseconds: 350));
      _autoLogin(savedEmail, savedPassword);
    } else {
      setState(() => _checkingAutoLogin = false);
    }
  }

  // -------- FUNGSI AUTO LOGIN -------
  void _autoLogin(String email, String password) async {
    try {
      final result = await _apiService.login(email, password);

      if (result['success'] == true) {
        final String role = result['role'];
        final String nama = result['nama'];

        if (!mounted) return;

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen(namaPengguna: nama)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(namaPengguna: nama)),
          );
        }
        return;
      }
    } catch (e) {
      // Abaikan error → tampilkan login form saja
    }

    if (mounted) setState(() => _checkingAutoLogin = false);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- LOGIKA LOGIN (Tetap sama, hanya tambah simpan data) ---
  void _handleLogin() async {
    if (_isLoading) return;
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showMessage("Email dan Password tidak boleh kosong.");
      return;
    }

    setState(() => _isLoading = true);

    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text;

      final result = await _apiService.login(email, password);

      if (result['success'] == true) {
        // ---------- SIMPAN EMAIL & PASSWORD ----------
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_email', email);
        await prefs.setString('saved_password', password);
        // --------------------------------------------------

        final String role = result['role'];
        final String nama = result['nama'];

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminHomeScreen(namaPengguna: nama)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen(namaPengguna: nama)),
          );
        }
      } else {
        _showMessage(result['message'] ?? 'Terjadi kesalahan');
      }
    } catch (e) {
      _showMessage("Error: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
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

    // Saat cek auto login → tampilkan loading putih
    if (_checkingAutoLogin) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              width: double.infinity,
              child: Column(
                children: [
                  Image.asset(
                    'assets/images/logo.png',
                    height: 50,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.local_police, size: 50, color: Colors.white);
                    },
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Layanan Pengaduan Dinas Pemberdayaan Perempuan dan Perlindungan Anak",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Kota Banjarmasin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Text(
                        "Selamat Datang!",
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Silakan login untuk melanjutkan",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 25),

                      _buildLabel("Email"),
                      TextFormField(
                        controller: _emailController,
                        decoration: _inputDecoration("email@anda.com"),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),

                      _buildLabel("Kata Sandi"),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: _inputDecoration("Masukkan kata sandi").copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() => _isPasswordVisible = !_isPasswordVisible);
                            },
                          ),
                        ),
                      ),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                            );
                          },
                          child: const Text(
                            "Lupa Kata Sandi?",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : const Text(
                                  "Masuk",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Belum punya akun? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const RegisterScreen()),
                              );
                            },
                            child: const Text(
                              "Daftar Sekarang",
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
    );
  }
}
