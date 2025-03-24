import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Data Notifikasi Contoh (bisa diganti dengan API atau database)
    final List<Map<String, String>> notifications = [
      {
        'title': 'Pesanan Selesai',
        'message': 'Pesanan dengan kode 276xxxxxxxxxxx sudah selesai.',
        'date': '08-03-2025 10:37',
        'image': 'images/cow.jpg',
      },
      {
        'title': 'Pesanan Selesai',
        'message': 'Pesanan dengan kode 276xxxxxxxxxxx sudah selesai.',
        'date': '08-03-2025 10:37',
        'image': 'images/kambing.jpeg',
      },
      {
        'title': 'Pesanan Selesai',
        'message': 'Pesanan dengan kode 276xxxxxxxxxxx sudah selesai.',
        'date': '08-03-2025 10:37',
        'image': 'images/kambing2.jpg',
      },
      {
        'title': 'Pesanan Selesai',
        'message': 'Pesanan dengan kode 276xxxxxxxxxxx sudah selesai.',
        'date': '08-03-2025 10:37',
        'image': 'images/cow.jpg',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifikasi',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                // Gambar Notifikasi
                Image.asset(
                  notification['image']!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 12),
                // Detail Notifikasi
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification['title']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['message']!,
                        style: const TextStyle(color: Colors.black87),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification['date']!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
