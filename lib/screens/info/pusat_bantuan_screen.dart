import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/styles.dart';
import 'package:pengaduan_dp3a/core/colors.dart';

class PusatBantuanScreen extends StatelessWidget {
  const PusatBantuanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Pusat Bantuan", style: AppStyles.sectionTitle.copyWith(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text("Pertanyaan Sering Diajukan (FAQ)", style: AppStyles.pageTitle),
          const SizedBox(height: 20),

          _buildFaqItem(
            "Bagaimana cara membuat laporan?",
            "Anda dapat membuat laporan dengan menekan tombol 'Buat Pengaduan' di halaman Beranda. Isi semua data yang diperlukan dan tekan tombol 'Kirim Laporan'.",
          ),
          _buildFaqItem(
            "Apa saja yang bisa saya laporkan?",
            "Anda dapat melaporkan semua kejadian yang terkait dengan kekerasan terhadap perempuan dan anak, termasuk kekerasan fisik, psikis, seksual, dan penelantaran.",
          ),
          _buildFaqItem(
            "Apakah data saya aman?",
            "Ya. Kami menjamin kerahasiaan data pelapor. Informasi Anda hanya akan digunakan oleh petugas berwenang untuk menindaklanjuti laporan.",
          ),
          _buildFaqItem(
            "Berapa lama laporan saya ditanggapi?",
            "Petugas akan meninjau laporan Anda dalam 1x24 jam (hari kerja). Anda dapat memantau statusnya secara real-time di halaman 'Riwayat'.",
          ),
          
          const Divider(height: 40),
          Text("Butuh Bantuan Lebih Lanjut?", style: AppStyles.sectionTitle),
          const SizedBox(height: 10),
          Text("Jika Anda mengalami kendala teknis atau pertanyaan lain, silakan hubungi kami melalui:", style: AppStyles.bodyText),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Icons.email, color: AppColors.primary),
            title: const Text("Email"),
            subtitle: const Text("dpppa@banjarmasinkota.go.id"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: AppColors.primary),
            title: const Text("Telepon Kantor"),
            subtitle: const Text("(0511) 3307-788"),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      shape: const RoundedRectangleBorder(), // Menghilangkan border
      collapsedShape: const RoundedRectangleBorder(), // Menghilangkan border
      tilePadding: const EdgeInsets.all(0),
      childrenPadding: const EdgeInsets.only(bottom: 16),
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold)),
      children: [
        Text(answer, style: AppStyles.bodyText),
      ],
    );
  }
}