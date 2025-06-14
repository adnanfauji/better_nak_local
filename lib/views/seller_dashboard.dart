import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'order_status_card.dart';
import 'feature_card.dart';

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
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            onPressed: () => _logout(context), // Memanggil fungsi logout
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: const [
            OrderStatusCard(),
            FeatureCard(),
            // tambahkan widget lainnya di sini
          ],
        ),
      ),
    );
  }
}
