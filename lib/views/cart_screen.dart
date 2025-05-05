// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import 'checkout_screen.dart';

class CartScreen extends StatefulWidget {
  final String userId;
  const CartScreen({super.key, required this.userId});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<dynamic> _cartItems = [];
  List<bool> _selected = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  Future<void> fetchCart() async {
    setState(() => _loading = true);
    try {
      final res = await http.get(Uri.parse(
          '${Config.BASE_URL}/get_cart.php?user_id=${widget.userId}'));
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        if (body['success']) {
          _cartItems = body['data'];
          _selected = List<bool>.filled(_cartItems.length, false);
        }
      }
    } catch (e) {
      print('Error fetching cart: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  int get totalItems => _cartItems.asMap().entries.fold(0, (sum, e) {
        if (!_selected[e.key]) return sum;
        final qty = int.tryParse(e.value['quantity'].toString()) ?? 1;
        return sum + qty;
      });

  int get totalPrice => _cartItems.asMap().entries.fold(0, (sum, e) {
        if (!_selected[e.key]) return sum;
        final qty = int.tryParse(e.value['quantity'].toString()) ?? 1;
        final price = int.tryParse(e.value['price'].toString()) ?? 0;
        return sum + (price * qty);
      });

  void _showActionModal() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment:
                CrossAxisAlignment.stretch, // ⬅️ untuk stretch anak Column
            children: [
              const Text(
                'Pilih Aksi',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text('Hapus Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _deleteSelectedItems();
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.favorite),
                  label: const Text('Paforitkan Item'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    _favoriteSelectedItems();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteSelectedItems() async {
    final selectedIds = <String>[];
    for (var i = 0; i < _cartItems.length; i++) {
      if (_selected[i]) selectedIds.add(_cartItems[i]['id'].toString());
    }

    for (final id in selectedIds) {
      await http.post(
        Uri.parse('${Config.BASE_URL}/delete_cart_item.php'),
        body: {'cart_id': id},
      );
    }

    await fetchCart();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item berhasil dihapus')),
    );
  }

  Future<void> _favoriteSelectedItems() async {
    final selectedIds = <String>[];
    for (var i = 0; i < _cartItems.length; i++) {
      if (_selected[i]) selectedIds.add(_cartItems[i]['id'].toString());
    }

    for (final id in selectedIds) {
      try {
        final response = await http.post(
          Uri.parse('${Config.BASE_URL}/favorite_item.php'),
          body: {'cart_id': id},
        );

        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Berhasil')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(data['message'] ?? 'Gagal menyimpan favorit')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Keranjang Saya',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        actions: _cartItems.isEmpty
            ? null // Tidak menampilkan tombol "Ubah" jika keranjang kosong
            : [
                TextButton(
                  onPressed: () {
                    final hasSelected = _selected.contains(true);
                    if (!hasSelected) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Pilih item terlebih dahulu')),
                      );
                      return;
                    }
                    _showActionModal();
                  },
                  child: const Text(
                    'Ubah',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _cartItems.isEmpty
              ? const Center(child: Text('Keranjang kamu kosong'))
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: _cartItems.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final item = _cartItems[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.amber),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: CheckboxListTile(
                                value: _selected[index],
                                onChanged: (v) {
                                  setState(() {
                                    _selected[index] = v ?? false;
                                  });
                                },
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text(item['name'] ?? '',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(
                                    '${item['quantity']} item • Rp${item['price']}'),
                                secondary: Image.network(
                                  item['photo'],
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Image.asset(
                                      'images/default.jpg',
                                      width: 60,
                                      height: 60),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 12.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total ($totalItems)',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text('Rp$totalPrice',
                              style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: totalItems > 0
                                ? () {
                                    final selectedItems = <dynamic>[];
                                    for (var i = 0;
                                        i < _cartItems.length;
                                        i++) {
                                      if (_selected[i]) {
                                        selectedItems.add(_cartItems[i]);
                                      }
                                    }
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CheckoutScreen(
                                          userId: widget.userId,
                                          cartItems: selectedItems,
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            child: const Text('Checkout',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
