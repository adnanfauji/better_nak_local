// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'cart_screen.dart';
import 'message_screen.dart';
import 'notification_screen.dart';
import 'my_account_screen.dart';
import 'livestock_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  final String userId;
  const HomeScreen({super.key, required this.name, required this.userId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  List<dynamic> _ads = [];
  List<String> _categories = [];
  bool _adsLoading = true;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchAdvertised();
  }

  Future<void> fetchCategories() async {
    try {
      final uri = Uri.parse('${Config.BASE_URL}/get_advertised_livestock.php');
      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success']) {
          final data = body['data'];
          final types = data
              .map<String>((item) => item['type'] as String)
              .toSet()
              .toList();
          setState(() {
            _categories = types;
          });
        }
      }
    } catch (e) {
      print('Error fetch categories: $e');
    }
  }

  Future<void> fetchAdvertised({String? category}) async {
    setState(() => _adsLoading = true);
    try {
      final uri = category == null
          ? Uri.parse('${Config.BASE_URL}/get_advertised_livestock.php')
          : Uri.parse(
              '${Config.BASE_URL}/get_advertised_livestock.php?type=${Uri.encodeComponent(category)}');

      final res = await http.get(uri);
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success']) {
          setState(() {
            _ads = body['data'];
            _selectedCategory = category;
          });
        }
      }
    } catch (e) {
      print('Error fetch ads: $e');
    } finally {
      setState(() => _adsLoading = false);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const MessageScreen()),
      );
    }

    if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const NotificationScreen()),
      );
    }

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MyAccountScreen(userId: widget.userId)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Better-Nak',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.shoppingBag, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CartScreen(userId: widget.userId)),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Akun',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kategori
            const Text('Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ..._categories.map((category) {
                  final isSelected = _selectedCategory == category;
                  return OutlinedButton(
                    onPressed: () => fetchAdvertised(category: category),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.green : Colors.white,
                      side: BorderSide(
                          color: isSelected ? Colors.green : Colors.amber,
                          width: 1.5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.green),
                    ),
                  );
                }),
                if (_selectedCategory != null)
                  OutlinedButton(
                    onPressed: () => fetchAdvertised(category: null),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.red[50],
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Reset Filter',
                        style: TextStyle(color: Colors.red)),
                  ),
              ],
            ),

            const SizedBox(height: 20),

            // Ternak Terkini (Iklan Terkini)
            const Text('Ternak Terkini',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 180,
              child: _adsLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _ads.isEmpty
                      ? const Center(
                          child: Text('Belum ada ternak yang di iklankan!'))
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _ads.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 12),
                          itemBuilder: (context, i) {
                            final ad = _ads[i];
                            return SizedBox(
                              width: 140,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          LivestockDetailScreen(
                                        data: ad,
                                        userId: widget.userId,
                                      ),
                                    ),
                                  );
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        ad['photo'],
                                        height: 100,
                                        width: 140,
                                        fit: BoxFit.cover,
                                        errorBuilder: (_, __, ___) =>
                                            Image.asset(
                                          'images/default.jpg',
                                          height: 100,
                                          width: 140,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      ad['name'] ?? '',
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Rp${ad['price'] ?? '0'}',
                                      style:
                                          const TextStyle(color: Colors.green),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      ad['location'] ?? '',
                                      style:
                                          const TextStyle(color: Colors.grey),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
