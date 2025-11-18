import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/screens/auth/login_screen.dart';
import 'package:pengaduan_dp3a/screens/profile/edit_profile_screen.dart';
import 'package:pengaduan_dp3a/screens/auth/forgot_password_screen.dart';
import 'package:pengaduan_dp3a/screens/info/pusat_bantuan_screen.dart';
import 'package:pengaduan_dp3a/screens/info/tentang_aplikasi_screen.dart';

class ProfileTab extends StatefulWidget {
  const ProfileTab({super.key});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  bool _isLoggingOut = false;

  final User? currentUser = FirebaseAuth.instance.currentUser;

  // 🟢 FUNGSI LOGOUT — Sudah ditambahkan delay agar terasa “online”
  Future<void> _handleLogout(BuildContext context) async {
    if (_isLoggingOut) return;

    setState(() {
      _isLoggingOut = true;
    });

    try {
      // ⏳ Tambahkan jeda 1.2 detik agar terlihat melakukan koneksi ke server
      await Future.delayed(const Duration(milliseconds: 1200));

      await FirebaseAuth.instance.signOut();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Logout failed: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal melakukan logout: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoggingOut = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return const Center(
        child: Text("Pengguna tidak ditemukan. Silakan login ulang."),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(currentUser!),

            const SizedBox(height: 70),

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
                        MaterialPageRoute(
                          builder: (context) => const EditProfileScreen(),
                        ),
                      );
                    },
                  ),
                  _buildProfileMenu(
                    icon: Icons.lock_outline,
                    title: "Ubah Kata Sandi",
                    onTap: () {
                      if (currentUser!.email != null &&
                          currentUser!.email!.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const ForgotPasswordScreen(),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Fitur ini hanya untuk akun dengan email."),
                          ),
                        );
                      }
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
                        MaterialPageRoute(
                          builder: (context) => const PusatBantuanScreen(),
                        ),
                      );
                    },
                  ),
                  _buildProfileMenu(
                    icon: Icons.info_outline,
                    title: "Tentang Aplikasi",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TentangAplikasiScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // 🔴 TOMBOL LOGOUT
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _isLoggingOut
                          ? null
                          : () => _showLogoutDialog(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isLoggingOut
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: const CircularProgressIndicator(
                                color: Colors.red,
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.logout),
                      label: Text(
                        _isLoggingOut ? "Sedang Logout..." : "Logout",
                      ),
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

  Widget _buildProfileHeader(User currentUser) {
    String getInitials(User user) {
      if (user.displayName != null && user.displayName!.isNotEmpty) {
        return user.displayName!
            .trim()
            .split(RegExp(r'\s+'))
            .where((s) => s.isNotEmpty)
            .map((namePart) => namePart[0])
            .take(2)
            .join()
            .toUpperCase();
      }
      return user.email?.substring(0, 1).toUpperCase() ?? "U";
    }

    final String initials = getInitials(currentUser);
    final String displayName =
        currentUser.displayName ?? currentUser.email!.split('@').first;
    final String email = currentUser.email ?? "email tidak tersedia";

    return Stack(
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
                  child: Text(
                    initials,
                    style: const TextStyle(
                      fontSize: 40,
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                displayName,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                email,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(title, style: AppStyles.sectionTitle),
      ),
    );
  }

  Widget _buildProfileMenu(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
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
        trailing: const Icon(Icons.arrow_forward_ios,
            size: 16, color: Colors.grey),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin logout dari akun ini?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Batal", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _handleLogout(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child:
                const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
