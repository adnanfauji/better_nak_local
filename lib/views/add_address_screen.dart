import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/config.dart';

class AddAddressScreen extends StatefulWidget {
  final String userId;

  const AddAddressScreen({super.key, required this.userId});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController countryController = TextEditingController();

  bool isLoading = false;

  Future<void> addAddress() async {
    final addressLine1 = addressLine1Controller.text.trim();
    final addressLine2 = addressLine2Controller.text.trim();
    final city = cityController.text.trim();
    final state = stateController.text.trim();
    final postalCode = postalCodeController.text.trim();
    final country = countryController.text.trim();

    if (addressLine1.isEmpty || city.isEmpty || country.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Semua field wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('${Config.BASE_URL}/add_address.php'),
        body: {
          'user_id': widget.userId,
          'address_line_1': addressLine1,
          'address_line_2': addressLine2,
          'city': city,
          'state': state,
          'postal_code': postalCode,
          'country': country,
        },
      );

      final body = json.decode(response.body);
      if (body['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'])),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(body['message'])),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Alamat'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: addressLine1Controller,
              decoration: const InputDecoration(labelText: 'Alamat Baris 1'),
            ),
            TextField(
              controller: addressLine2Controller,
              decoration: const InputDecoration(labelText: 'Alamat Baris 2'),
            ),
            TextField(
              controller: cityController,
              decoration: const InputDecoration(labelText: 'Kota'),
            ),
            TextField(
              controller: stateController,
              decoration: const InputDecoration(labelText: 'Provinsi'),
            ),
            TextField(
              controller: postalCodeController,
              decoration: const InputDecoration(labelText: 'Kode Pos'),
            ),
            TextField(
              controller: countryController,
              decoration: const InputDecoration(labelText: 'Negara'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : addAddress,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
