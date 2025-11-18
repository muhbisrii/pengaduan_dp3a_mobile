import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/screens/auth/login_screen.dart';
// --- IMPORT BARU UNTUK NAVIGASI ---
import 'package:pengaduan_dp3a/screens/profile/edit_profile_screen.dart';
import 'package:pengaduan_dp3a/screens/auth/forgot_password_screen.dart';
import 'package:pengaduan_dp3a/screens/info/pusat_bantuan_screen.dart';
import 'package:pengaduan_dp3a/screens/info/tentang_aplikasi_screen.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Untuk ambil data user

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    // Ambil data user yang sedang login
    final User? currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- HEADER PROFIL ---
            Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -50,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[200],
                          // Tampilkan inisial nama jika tidak ada foto
                          child: Text(
                            currentUser?.displayName?.substring(0, 1) ?? currentUser?.email?.substring(0, 1).toUpperCase() ?? "U",
                            style: const TextStyle(fontSize: 40, color: AppColors.secondary),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        // Tampilkan nama atau email
                        currentUser?.displayName ?? currentUser?.email ?? "Nama Pengguna",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        currentUser?.email ?? "email@pengguna.com",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 70), 

            // --- MENU PENGATURAN ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildSectionTitle("Akun"),
                  _buildProfileMenu(
                    icon: Icons.person_outline,
                    title: "Edit Profil",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );
                    },
                  ),
                  _buildProfileMenu(
                    icon: Icons.lock_outline,
                    title: "Ubah Kata Sandi",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 20),
                  _buildSectionTitle("Info Lainnya"),
                  _buildProfileMenu(
                    icon: Icons.help_outline,
                    title: "Pusat Bantuan",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PusatBantuanScreen()),
                      );
                    },
                  ),
                  _buildProfileMenu(
                    icon: Icons.info_outline,
                    title: "Tentang Aplikasi",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const TentangAplikasiScreen()),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                  
                  // --- TOMBOL LOGOUT ---
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showLogoutDialog(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.logout),
                      label: const Text("Logout"),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  const Text(
                    "Versi Aplikasi 1.0.0",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget: Judul Section
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: AppStyles.sectionTitle,
        ),
      ),
    );
  }

  // Helper Widget: Item Menu
  Widget _buildProfileMenu({required IconData icon, required String title, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }

  // Fungsi Dialog Konfirmasi Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin logout dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              // Logout dari Firebase
              FirebaseAuth.instance.signOut(); 
              // Kembali ke Login Screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}