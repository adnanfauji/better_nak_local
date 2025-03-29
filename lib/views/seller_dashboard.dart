import 'package:flutter/material.dart';
import 'login_screen.dart';

class SellerDashboard extends StatelessWidget {
  final String name;

  const SellerDashboard({super.key, required this.name});

  // Fungsi untuk logout dan kembali ke halaman login
  void _logout(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false, // Hapus semua riwayat halaman
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard - $name"),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: () => _logout(context), // Memanggil fungsi logout
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: const Center(
        child: Text("Selamat datang di dashboard penjual!"),
      ),
    );
  }
}
