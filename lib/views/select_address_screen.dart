import 'package:flutter/material.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  State<SelectAddressScreen> createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  // Contoh data alamat (bisa diambil dari API atau database)
  final List<Map<String, String>> addresses = [
    {
      'name': 'Bapak Tato',
      'phone': '(+62) 857-7884-3907',
      'address':
          'Babakan Sampeu RT/RW:03/03 No.6, TIRTAMULYA, KAB. KARAWANG, JAWA BARAT, ID 41372',
    },
    {
      'name': 'balqisfashionstore',
      'phone': '(+62) 898-8924-241',
      'address':
          'Jl. Buni Asih Komplek Kidang Mas Permai No.C-3, Lembang, KAB. BANDUNG BARAT, JAWA BARAT, ID 40391',
    },
    {
      'name': 'BALQIS Fash',
      'phone': '(+62) 895-3530-86063',
      'address':
          'Perum Purwasari Regency Blok J No.3, RT/RW:01/14, PURWASARI, KAB. KARAWANG, JAWA BARAT, ID 41376',
    },
    {
      'name': 'Ibu Yani',
      'phone': '(+62) 831-6786-5414',
      'address':
          'Kecamatan Panguragan Desa Panguragan Kulon RT/RW:01/01 (Blok 1 Karanganyar), ARAJAWINANGUN, KAB. CIREBON, JAWA BARAT, ID 45162',
    },
  ];

  int selectedAddressIndex = 0; // Alamat yang dipilih

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pilih Alamat',
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
            Expanded(
              child: ListView.builder(
                itemCount: addresses.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedAddressIndex = index; // Pilih alamat
                      });

                      // Kembalikan data alamat ke halaman sebelumnya (checkout_screen)
                      Navigator.pop(context, addresses[index]);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedAddressIndex == index
                              ? Colors.green
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Radio Button
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Icon(
                              selectedAddressIndex == index
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_off,
                              color: Colors.green,
                            ),
                          ),
                          // Informasi Alamat
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${address['name']} - ${address['phone']}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  address['address'] ?? '',
                                  style: TextStyle(color: Colors.grey.shade700),
                                ),
                              ],
                            ),
                          ),
                          // Tombol Ubah
                          TextButton(
                            onPressed: () {
                              // Tambahkan navigasi untuk ubah alamat di sini
                            },
                            child: const Text(
                              'Ubah',
                              style: TextStyle(color: Colors.green),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  // Navigasi ke halaman Tambah Alamat Baru
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddNewAddressScreen()),
                  );
                },
                child: const Text(
                  'Tambah Alamat Baru',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tambah Alamat Baru',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Center(
        child: Text('Form Tambah Alamat Baru'),
      ),
    );
  }
}
