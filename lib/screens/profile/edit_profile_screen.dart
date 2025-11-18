import 'package:flutter/material.dart';
import 'package:pengaduan_dp3a/core/styles.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil", style: AppStyles.sectionTitle.copyWith(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.construction, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "Segera Hadir",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
               Text(
                "Fitur untuk mengubah data profil Anda sedang dalam pengembangan.",
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}