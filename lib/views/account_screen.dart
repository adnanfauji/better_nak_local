import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool isFingerprintEnabled = true; // Status toggle sidik jari

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Akun',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        children: [
          // Header Akun
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.grey[200],
            child: const Text(
              'Akun',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
          buildSettingItem(
            title: 'Profil Saya',
            value: '',
            onTap: () {
              // Navigasi ke halaman profil
            },
          ),
          buildSettingItem(
            title: 'Username',
            value: 'Adnan Fauji',
            onTap: () {
              // Navigasi ke halaman ubah username
            },
          ),
          buildSettingItem(
            title: 'No. Handphone',
            value: '*****41',
            onTap: () {
              // Navigasi ke halaman ubah nomor handphone
            },
          ),
          buildSettingItem(
            title: 'Email',
            value: 'a********8@gmail.com',
            onTap: () {
              // Navigasi ke halaman ubah email
            },
          ),
          buildSettingItem(
            title: 'Akun Media Sosial',
            value: '',
            onTap: () {
              // Navigasi ke halaman media sosial
            },
          ),
          buildSettingItem(
            title: 'Ganti Password',
            value: '',
            onTap: () {
              // Navigasi ke halaman ganti password
            },
          ),

          // Verifikasi Sidik Jari
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Verifikasi Sidik Jari',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Better_nak tidak menyimpan data Sidik Jari, \nkarena data hanya tersimpan \ndi dalam perangkatmu.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Switch(
                  value: isFingerprintEnabled,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      isFingerprintEnabled = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget Item Pengaturan
  Widget buildSettingItem({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 16)),
                if (value.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      value,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
              ],
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
