// --- Import 'firebase_core.dart' SUDAH DIHAPUS ---
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApiService {
  
  // Referensi ke layanan Firebase
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- 1. FUNGSI AUTENTIKASI ---

  // Fungsi Login (Tidak Berubah)
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      // 1. Coba login
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // 2. Ambil data role user dari database Firestore
        DocumentSnapshot userData =
            await _firestore.collection('users').doc(user.uid).get();
        
        if (!userData.exists) {
          return {'success': false, 'message': 'Data user (role) tidak ditemukan di database.'};
        }
        
        String role = userData.get('role'); // 'masyarakat' atau 'admin'
        String nama = userData.get('nama');

        return {'success': true, 'role': role, 'nama': nama, 'user': user};
      }
      return {'success': false, 'message': 'User tidak ditemukan'};
    } on FirebaseAuthException catch (e) {
      // Handle error login yang lebih spesifik
      if (e.code == 'user-not-found' || e.code == 'wrong-password' || e.code == 'invalid-credential') {
        return {'success': false, 'message': 'Email atau Password salah.'};
      }
      return {'success': false, 'message': e.message ?? 'Terjadi kesalahan'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: ${e.toString()}'};
    }
  }

  // Fungsi Logout (Tidak Berubah)
  Future<void> logout() async {
    await _auth.signOut();
  }

  // --- FUNGSI BARU (FITUR C) ---
  Future<Map<String, dynamic>> forgotPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return {'success': true};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message ?? 'Gagal mengirim email reset.'};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
  // --- AKHIR FUNGSI BARU ---

  // Fungsi Registrasi (Tidak Berubah, sudah kita buat sebelumnya)
  Future<Map<String, dynamic>> register(
      String email, String password, String nama, String nik) async {
    try {
      // 1. Buat user di Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;

      if (user != null) {
        // 2. Simpan data tambahan user di Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'nama': nama,
          'nik': nik,
          'role': 'masyarakat', // Role default saat daftar
          'createdAt': FieldValue.serverTimestamp(),
        });
        return {'success': true};
      }
      return {'success': false, 'message': 'Gagal membuat user'};
    } on FirebaseAuthException catch (e) {
      return {'success': false, 'message': e.message ?? 'Terjadi kesalahan'};
    }
  }

  // --- 2. FUNGSI LAPORAN (PENGADUAN) ---

  // Fungsi Kirim Laporan (Tidak Berubah)
  Future<bool> kirimLaporan({
    required String kategori,
    required String tanggalKejadian,
    required String lokasi,
    required String kronologi,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      // 2. Simpan data laporan ke Firestore
      await _firestore.collection('laporan').add({
        'userId': user.uid,
        'emailPelapor': user.email,
        'kategori': kategori,
        'tanggalKejadian': tanggalKejadian,
        'lokasi': lokasi,
        'kronologi': kronologi,
        'fotoBukti': null, // <-- FOTO SELALU NULL
        'status': 'Menunggu', // Status awal
        'dibuatPada': FieldValue.serverTimestamp(),
        'tanggapanPetugas': null,
      });
      return true;
    } catch (e) {
      debugPrint("Error kirimLaporan: $e");
      return false;
    }
  }

  // --- 3. FUNGSI MENGAMBIL DATA (STREAM) ---
  // (Semua fungsi di bawah ini tidak berubah)
  Stream<QuerySnapshot> getStreamLaporanUser() {
    User? user = _auth.currentUser;
    return _firestore
        .collection('laporan')
        .where('userId', isEqualTo: user?.uid)
        .orderBy('dibuatPada', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getStreamLaporanAdmin(String status) {
    Query query = _firestore.collection('laporan').orderBy('dibuatPada', descending: true);
    
    if (status != 'Semua') {
      query = query.where('status', isEqualTo: status);
    }
    
    return query.snapshots();
  }

  Stream<QuerySnapshot> getStreamStatistikAdmin() {
     return _firestore.collection('laporan').snapshots();
  }
}