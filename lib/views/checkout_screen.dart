import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

import 'select_address_screen.dart';
import 'payment_method_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final String userId;
  final List<dynamic> cartItems;

  const CheckoutScreen(
      {super.key, required this.userId, required this.cartItems});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  // alamat
  Map<String, String> currentAddress = {
    'name': 'Sasandra Mobile Shohib',
    'phone': '(082) 3273-4589',
    'address':
        'Karawang, Jawa Barat, Indonesia\nKecamatan Klari, Karawang, Jawa Barat, 41361',
  };

  String currentPaymentMethod = 'Transfer Bank';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  // hitung subtotal produk
  int get subtotalProducts => widget.cartItems.fold(0, (sum, item) {
        final price = int.tryParse(item['price'].toString()) ?? 0;
        final qty = int.tryParse(item['quantity'].toString()) ?? 1;
        return sum + (price * qty);
      });

  // biaya kirim tetap, misalnya
  final int shippingCost = 50000;

  int get totalPayment => subtotalProducts + shippingCost;

  Future<void> _navigateToSelectAddress() async {
    final selected = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(builder: (_) => const SelectAddressScreen()),
    );
    if (selected != null) {
      setState(() => currentAddress = selected);
    }
  }

  Future<void> _navigateToPaymentMethod() async {
    final selected = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const PaymentMethodScreen()),
    );
    if (selected != null) {
      setState(() => currentPaymentMethod = selected);
    }
  }

  void _createOrder() {
    // TODO: panggil API buat pesanan dengan cartItems, currentAddress, currentPaymentMethod
    // lalu bersihkan keranjang atau navigasi ke halaman sukses
    print('Order: ${widget.cartItems}');
    print('Address: $currentAddress');
    print('Payment: $currentPaymentMethod');
    print('Total: $totalPayment');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout',
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Alamat
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.green),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${currentAddress['name']} • ${currentAddress['phone']}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    currentAddress['address']!,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _navigateToSelectAddress,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Ubah Alamat',
                            style: TextStyle(color: Colors.white)),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // List produk
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.cartItems.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final item = widget.cartItems[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item['photo'],
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                              'images/default.jpg',
                              width: 50,
                              height: 50),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['name'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Text('Rp${item['price']} × ${item['quantity']}'),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Metode Pembayaran
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Metode Pembayaran'),
                  InkWell(
                    onTap: _navigateToPaymentMethod,
                    child: Row(
                      children: [
                        Text(currentPaymentMethod,
                            style: const TextStyle(color: Colors.green)),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Rincian Harga
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailRow('Subtotal Produk', 'Rp$subtotalProducts'),
                  _buildDetailRow('Ongkos Kirim', 'Rp$shippingCost'),
                  _buildDetailRow('Biaya Layanan', 'Rp0'),
                  const Divider(),
                  _buildDetailRow('Total Pembayaran', 'Rp$totalPayment',
                      isBold: true),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Wrap Total dengan Expanded agar bisa menyesuaikan ruang
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total', style: TextStyle(color: Colors.grey)),
                    Text(
                      'Rp$totalPayment',
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      overflow: TextOverflow
                          .ellipsis, // Pastikan jika total terlalu panjang, teks akan memendek
                    ),
                  ],
                ),
              ),
              // Tombol Buat Pesanan dengan sedikit padding
              const SizedBox(width: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                onPressed: _createOrder,
                child: const Text('Buat Pesanan',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
