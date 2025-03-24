import 'package:flutter/material.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String? selectedPayment; // Menyimpan metode pembayaran yang dipilih

  // Data metode pembayaran
  final Map<String, List<Map<String, dynamic>>> paymentMethods = {
    'Transfer Bank': [
      {'name': 'Bank BCA', 'logo': 'images/bca.png'},
      {'name': 'Bank Mandiri', 'logo': 'images/mandiri.png'},
      {'name': 'Bank BNI', 'logo': 'images/bni.png'},
      {'name': 'Bank BRI', 'logo': 'images/bri.png'},
    ],
    'E-Wallet': [
      {'name': 'Dana', 'logo': 'images/dana.png'},
      {'name': 'Ovo', 'logo': 'images/ovo.jpg'},
    ],
  };

  // Status ekspansi kategori pembayaran
  Map<String, bool> isExpanded = {
    'Transfer Bank': true,
    'E-Wallet': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Metode Pembayaran',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List metode pembayaran
            Expanded(
              child: ListView(
                children: paymentMethods.entries.map((entry) {
                  return _buildPaymentSection(entry.key, entry.value);
                }).toList(),
              ),
            ),
            // Tombol Konfirmasi
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: selectedPayment != null
                    ? () {
                        Navigator.pop(context, selectedPayment);
                      }
                    : null,
                child: const Text(
                  'Konfirmasi',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk bagian metode pembayaran
  Widget _buildPaymentSection(
      String category, List<Map<String, dynamic>> items) {
    return Column(
      children: [
        // Header kategori (Transfer Bank / E-Wallet)
        InkWell(
          onTap: () {
            setState(() {
              isExpanded[category] = !(isExpanded[category] ?? false);
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    category == 'Transfer Bank'
                        ? Icons.account_balance
                        : Icons.account_balance_wallet,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Icon(
                isExpanded[category] ?? false
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down,
                color: Colors.green,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // List item dalam kategori (Bank BCA, Dana, dll.)
        if (isExpanded[category] ?? false)
          Column(
            children: items.map((item) {
              return RadioListTile<String>(
                title: Row(
                  children: [
                    Image.asset(item['logo'], width: 40, height: 40),
                    const SizedBox(width: 10),
                    Text(item['name']),
                  ],
                ),
                value: item['name'],
                groupValue: selectedPayment,
                activeColor: Colors.green,
                onChanged: (value) {
                  setState(() {
                    selectedPayment = value;
                  });
                },
              );
            }).toList(),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
