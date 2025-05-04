// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../config/config.dart';
import 'cart_screen.dart';

class LivestockDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;
  final String userId;

  const LivestockDetailScreen({
    super.key,
    required this.data,
    required this.userId,
  });

  @override
  State<LivestockDetailScreen> createState() => _LivestockDetailScreenState();
}

class _LivestockDetailScreenState extends State<LivestockDetailScreen> {
  bool _isFavorite = false;

  void openWhatsApp(String phoneNumber, String message) async {
    final url =
        'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
    if (await url_launcher.canLaunchUrl(Uri.parse(url))) {
      await url_launcher.launchUrl(
        Uri.parse(url),
        mode: url_launcher.LaunchMode.externalApplication,
      );
    } else {
      throw 'Tidak dapat membuka WhatsApp.';
    }
  }

  Future<void> addToCart(
      BuildContext context, String userId, String livestockId) async {
    final url = Uri.parse('${Config.BASE_URL}/add_to_cart.php');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': userId,
          'livestock_id': livestockId,
          'quantity': 1,
        }),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(body['message'] ?? 'Ditambahkan ke keranjang')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('HTTP Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkFavorite();
  }

  Future<void> _checkFavorite() async {
    final url = Uri.parse('${Config.BASE_URL}/check_favorite.php');
    try {
      final response = await http.post(
        url,
        body: {
          'user_id': widget.userId,
          'livestock_id': widget.data['id'].toString(),
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        setState(() {
          _isFavorite = body['favorite'] ?? false;
        });
      }
    } catch (e) {
      // optional: bisa log error di debug console
      print('Error checking favorite: $e');
    }
  }

  Future<void> toggleFavorite(String userId, String livestockId) async {
    final url = Uri.parse('${Config.BASE_URL}/toggle_favorite.php');

    try {
      final response = await http.post(
        url,
        body: {
          'user_id': userId,
          'livestock_id': livestockId,
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        setState(() {
          _isFavorite = body['favorite'] ?? false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('HTTP Error: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.data;
    final userId = widget.userId;
    final livestockId = data['id'].toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(data['name'] ?? 'Detail Ternak'),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.shoppingBag, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CartScreen(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Gambar
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                data['photo'],
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset('images/default.jpg',
                    height: 240, fit: BoxFit.cover),
              ),
            ),

            const SizedBox(height: 16),
            // Judul, Harga, dan Tombol Favorit
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Judul & Harga
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['name'] ?? '',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp${data['price'] ?? '0'}',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.green,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  // Tombol Favorite
                  IconButton(
                    icon: Icon(
                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                      size: 28,
                    ),
                    onPressed: () => toggleFavorite(userId, livestockId),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),
            // Lokasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      data['location'] ?? '-',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),
            // Bar tombol bawah
            Container(
              color: Colors.grey.shade100,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  // Chat
                  SizedBox(
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () {
                        final phone = data['phone'];
                        if (phone != null && phone.toString().isNotEmpty) {
                          openWhatsApp(
                            phone.toString(),
                            'Halo, saya tertarik dengan ternak ${data['name']} di BetterNak!',
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Nomor WhatsApp tidak tersedia.')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(),
                      ),
                      child:
                          const Icon(Icons.chat, size: 28, color: Colors.green),
                    ),
                  ),

                  Container(width: 4, color: Colors.grey.shade300),

                  // Tambah ke Keranjang
                  SizedBox(
                    width: 60,
                    child: ElevatedButton(
                      onPressed: () => addToCart(context, userId, livestockId),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.zero,
                        shape: const RoundedRectangleBorder(),
                      ),
                      child: const Icon(Icons.add_shopping_cart,
                          size: 28, color: Colors.orange),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Beli Sekarang
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: logika beli sekarang
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Beli Sekarang',
                          style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
