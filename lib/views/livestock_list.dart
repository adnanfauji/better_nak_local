import 'package:flutter/material.dart';

class LivestockListCompact extends StatelessWidget {
  const LivestockListCompact({super.key});

  @override
  Widget build(BuildContext context) {
    final dummyData = [
      {
        'name': 'Sapi Limousin',
        'price': 'Rp40.000.000',
        'stock': 12,
        'sold': 5,
        'favorite': 3,
        'views': 25,
        'image': 'images/cow.jpg',
      },
      {
        'name': 'Kambing Etawa',
        'price': 'Rp5.000.000',
        'stock': 7,
        'sold': 2,
        'favorite': 1,
        'views': 10,
        'image': 'images/kambing.jpeg',
      }
    ];

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: dummyData.length,
        itemBuilder: (context, index) {
          final item = dummyData[index];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: Image & Title
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          item['image']! as String,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name']! as String,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['price']! as String,
                              style: const TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Middle row: Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _iconText(Icons.store, 'Stok ${item['stock']}'),
                      _iconText(Icons.shopping_cart, 'Terjual ${item['sold']}'),
                      _iconText(
                          Icons.favorite_border, 'Favorit ${item['favorite']}'),
                      _iconText(Icons.remove_red_eye_outlined,
                          'Dilihat ${item['views']}'),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Bottom row: Actions
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("Iklankan"),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("Arsipkan"),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                        ),
                        child: const Text("Ubah"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
