import 'package:better_nak_local/views/my_livestock_screen.dart';
import 'package:flutter/material.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({super.key});

  Widget buildFeatureItem(
      {required IconData icon,
      required String title,
      required Color color,
      required VoidCallback onTap}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: color.withOpacity(0.1),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildFeatureItem(
              icon: Icons.inventory_2,
              title: "Tambah Ternak",
              color: Colors.red,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyLivestockScreen(),
                  ),
                );
              },
            ),
            buildFeatureItem(
              icon: Icons.account_balance_wallet,
              title: "Keuangan",
              color: Colors.orange,
              onTap: () {
                // Tambahkan navigasi ke halaman keuangan jika ada
              },
            ),
            buildFeatureItem(
              icon: Icons.bar_chart,
              title: "Performa Toko",
              color: Colors.red,
              onTap: () {
                // Tambahkan navigasi ke halaman performa toko jika ada
              },
            ),
          ],
        ),
      ),
    );
  }
}
