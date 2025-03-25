import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'cart_screen.dart';
import 'account_settings_screen.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Akun Saya',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AccountSettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.shoppingBag, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Profil
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.green,
              // borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: const Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto Profil
                CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('images/user.png'),
                ),
                SizedBox(width: 12),

                // Info Akun
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'balqisfashionstore',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          SizedBox(width: 4),
                          Chip(
                            label: Text(
                              'Silver',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '42 Pengikut',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '48 Mengikuti',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Bagian "Pesanan Saya"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pesanan Saya',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman riwayat pesanan
                    Navigator.pushNamed(context, '/orderHistory');
                  },
                  child: const Text(
                    'Lihat Riwayat Pesanan >',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Menu Status Pesanan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _orderStatusItem('Belum Bayar', Icons.payment),
              _orderStatusItem('Dikemas', Icons.inventory),
              _orderStatusItem('Dikirim', Icons.local_shipping),
              _orderStatusItem('Beri Penilaian', Icons.star_border),
            ],
          ),
        ],
      ),
    );
  }

  // Widget Item Status Pesanan
  Widget _orderStatusItem(String title, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.black54),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
