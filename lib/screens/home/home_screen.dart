import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/colors.dart';
import 'package:pengaduan_dp3a/screens/home/tabs/dashboard_tab.dart';
import 'package:pengaduan_dp3a/screens/home/tabs/history_tab.dart';
import 'package:pengaduan_dp3a/screens/home/tabs/profile_tab.dart';
// Import LoginScreen untuk akses fungsi clearSavedLogin()

class HomeScreen extends StatefulWidget {
  final String namaPengguna;
  const HomeScreen({super.key, required this.namaPengguna});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      // Kirim nama pengguna ke DashboardTab
      DashboardTab(namaPengguna: widget.namaPengguna), 
      const HistoryTab(),
      const ProfileTab(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- FUNGSI LOGOUT (SOLUSI MASALAH ANDA) ---
  // ------------------------------------------


  @override
  Widget build(BuildContext context) {
    // Kita akan membungkus konten di IndexedStack agar BottomNavigationBar
    // bisa berfungsi dan kemudian menempatkannya di Scaffold yang sama.
    // Setiap tab (widget di _pages) HARUS sudah memiliki Scaffold-nya sendiri
    // jika ingin memiliki AppBar, seperti ProfileTab.
    
    // Karena kita perlu tombol Logout, kita akan menempatkannya di ProfileTab
    // atau di App Bar yang dinamis. 
    
    // Namun, jika Anda ingin tombol logout muncul HANYA di ProfileTab, 
    // Anda harus mengimplementasikannya di ProfileTab.
    // Jika Anda ingin tombol Logout SELALU tersedia di AppBar utama:
    return Scaffold(
      // Body akan menampilkan Tab yang dipilih
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      
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
              label: 'Beranda',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history), 
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