import 'package:flutter/material.dart'; // <-- PERBAIKAN TYPO DI SINI
import 'package:pengaduan_dp3a/core/colors.dart';
// import 'package:pengaduan_dp3a/core/styles.dart'; // Ini sudah benar dikomentari
import 'tabs/admin_dashboard_tab.dart';
import 'package:pengaduan_dp3a/screens/home/tabs/profile_tab.dart';
import 'tabs/report_management_tab.dart';

class AdminHomeScreen extends StatefulWidget {
  final String namaPengguna;
  const AdminHomeScreen({super.key, required this.namaPengguna});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      AdminDashboardTab(namaPengguna: widget.namaPengguna), // Ini akan hijau lagi
      const ReportManagementTab(),
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
                offset: const Offset(0, -5)),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.secondary,
          unselectedItemColor: Colors.grey, // Ini akan hijau lagi
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.folder_shared_rounded),
              label: 'Laporan',
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