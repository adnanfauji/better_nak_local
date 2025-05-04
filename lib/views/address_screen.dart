import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alamat Saya',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Daftar Alamat
          Expanded(
            child: ListView(
              children: [
                _addressItem(
                  name: 'BALQIS Fash...',
                  phone: '(+62) 895-3530-86063',
                  address:
                      'Perum Purwasari Regency Blok J No. 3, RT/RW: 01/14, PURWASARI, KAB. KARAWANG, JAWA BARAT, ID 41376',
                  tags: ['Utama', 'Alamat Toko', 'Alamat Pengembalian'],
                ),
              ],
            ),
          ),
          // Tombol Tambah Alamat Baru
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Navigasi ke halaman tambah alamat
              },
              icon: const Icon(Icons.add),
              label: const Text('Tambah Alamat Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget Item Alamat
  Widget _addressItem({
    required String name,
    required String phone,
    required String address,
    List<String>? tags,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nama & No Telepon
            Text(
              '$name   $phone',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Alamat Lengkap
            Text(
              address,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
            const SizedBox(height: 8),

            // Tag (Utama, Alamat Toko, Alamat Pengembalian)
            if (tags != null) ...tags.map((tag) => _buildTag(tag)),

            // Tombol Ubah
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  // Navigasi ke halaman edit alamat
                },
                child: const Text(
                  'Ubah',
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Tag
  Widget _buildTag(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8, bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.orange, fontSize: 12),
      ),
    );
  }
}
