import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/screens/home/tabs/dashboard_tab.dart';
import 'package:pengaduan_dp3a/screens/home/tabs/history_tab.dart';
import 'package:pengaduan_dp3a/screens/home/tabs/profile_tab.dart';

// 1. Tambahkan parameter 'namaPengguna'
class HomeScreen extends StatefulWidget {
  final String namaPengguna;
  const HomeScreen({super.key, required this.namaPengguna});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // 2. Buat _pages menjadi 'late final' agar bisa di-init
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // 3. Inisialisasi _pages DI SINI, sambil mengirim nama ke DashboardTab
    _pages = [
      DashboardTab(namaPengguna: widget.namaPengguna), // <-- Kirim nama ke tab
      const HistoryTab(),
      const ProfileTab(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Langsung body
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history), // Ikon disesuaikan
              label: 'Riwayat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}