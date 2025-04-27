import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_livestock_screen.dart';
import 'edit_livestock_screen.dart';

class LivestockListCompact extends StatefulWidget {
  const LivestockListCompact({super.key});

  @override
  State<LivestockListCompact> createState() => _LivestockListCompactState();
}

class _LivestockListCompactState extends State<LivestockListCompact> {
  List<dynamic> livestockData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLivestock();
  }

  Future<void> fetchLivestock() async {
    setState(() => isLoading = true);
    try {
      final response = await http
          .get(Uri.parse('http://10.0.2.2/api_local/get_livestock.php'));

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success']) {
          setState(() {
            livestockData = body['data'];
          });
        } else {
          throw Exception('Gagal fetch data');
        }
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : livestockData.isEmpty
              ? const Center(child: Text('Belum ada data ternak'))
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 80),
                  itemCount: livestockData.length,
                  itemBuilder: (context, index) {
                    final item = livestockData[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    item['photo'] as String, // URL dari API
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    // kalau gagal load network image, fallback pakai asset default:
                                    errorBuilder: (context, error, stackTrace) {
                                      return Image.asset(
                                        'images/default.jpg',
                                        width: 70,
                                        height: 70,
                                        fit: BoxFit.cover,
                                      );
                                    },
                                    // optional: loading indicator
                                    loadingBuilder: (context, child, progress) {
                                      if (progress == null) return child;
                                      return SizedBox(
                                        width: 70,
                                        height: 70,
                                        child: Center(
                                          child: CircularProgressIndicator(
                                            value: progress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? progress
                                                        .cumulativeBytesLoaded /
                                                    progress.expectedTotalBytes!
                                                : null,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item['name'] ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rp${item['price'] ?? '0'}',
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _iconText(Icons.store,
                                    'Stok ${item['quantity'] ?? 0}'),
                                _iconText(Icons.shopping_cart, 'Terjual 0'),
                                _iconText(Icons.favorite_border, 'Favorit 0'),
                                _iconText(
                                    Icons.remove_red_eye_outlined, 'Dilihat 0'),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    final response = await http.post(
                                      Uri.parse(
                                          'http://10.0.2.2/api_local/advertise_livestock.php'),
                                      body: {
                                        'id': item['id'].toString(),
                                      },
                                    );

                                    final data = jsonDecode(response.body);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(data['message'])),
                                    );

                                    if (data['success'] == true) {
                                      fetchLivestock(); // Reload data setelah berhasil iklankan
                                    }
                                  },
                                  child: const Text("Iklankan"),
                                ),
                                OutlinedButton(
                                  onPressed: () {},
                                  child: const Text("Arsipkan"),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            EditLivestockScreen(item: item),
                                      ),
                                    ).then((edited) {
                                      if (edited == true) fetchLivestock();
                                    });
                                  },
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => const AddLivestockScreen(),
              ),
            ).then((added) {
              if (added == true) {
                fetchLivestock();
              }
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child:
              const Text('Tambah Ternak Baru', style: TextStyle(fontSize: 16)),
        ),
      ),
    );
  }

  Widget _iconText(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
