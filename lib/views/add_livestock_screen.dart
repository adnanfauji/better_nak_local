import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddLivestockScreen extends StatefulWidget {
  const AddLivestockScreen({super.key});

  @override
  State<AddLivestockScreen> createState() => _AddLivestockScreenState();
}

class _AddLivestockScreenState extends State<AddLivestockScreen> {
  final _formKey = GlobalKey<FormState>();

  // State
  File? _selectedImage;
  String? _managementType;
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();
  String? _gender;
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final _managementOptions = ['Sapi', 'Kambing', 'Domba'];
  final _genderOptions = ['Jantan', 'Betina'];

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _weightController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _showPickOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ambil foto dari:"),
        actions: [
          TextButton(
            child: const Text("Kamera"),
            onPressed: () {
              Navigator.of(context).pop();
              _pickPhotoFrom(ImageSource.camera);
            },
          ),
          TextButton(
            child: const Text("Galeri"),
            onPressed: () {
              Navigator.of(context).pop();
              _pickPhotoFrom(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _pickPhotoFrom(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        // TAMPILKAN loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        );

        var uri = Uri.parse('http://10.0.2.2/api_local/add_livestock.php');
        var request = http.MultipartRequest('POST', uri);

        if (_selectedImage != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'photo',
            _selectedImage!.path,
          ));
        }

        request.fields['type'] = _managementType ?? '';
        request.fields['name'] = _nameController.text;
        request.fields['quantity'] = _quantityController.text;
        request.fields['weight'] = _weightController.text;
        request.fields['gender'] = _gender ?? '';
        request.fields['location'] = _locationController.text;
        request.fields['price'] = _priceController.text;

        var response = await request.send();
        var responseData = await response.stream.bytesToString();
        final data = jsonDecode(responseData);

        // TUTUP loading dialog
        Navigator.of(context).pop();

        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ternak berhasil ditambahkan')),
          );
          Navigator.pop(context, true); // Memberikan signal untuk reload data
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal tambah ternak: ${data['message']}')),
          );
        }
      } catch (e) {
        // TUTUP loading dialog jika error
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0),
      appBar: AppBar(
        title: const Text('Form Input'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildSectionTitle('Tambahkan Foto *'),
              OutlinedButton(
                onPressed: () => _showPickOptionsDialog(context),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: _selectedImage == null
                    ? Text('Pilih Foto...',
                        style: TextStyle(color: Colors.grey[700]))
                    : Image.file(_selectedImage!,
                        height: 100, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Jenis Ternak *'),
              _buildDropdown(
                value: _managementType,
                items: _managementOptions,
                onChanged: (val) => setState(() => _managementType = val),
                validatorMsg: 'Wajib memilih jenis ternak',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Nama Hewan *'),
              _buildTextField(_nameController, 'Masukkan nama',
                  validatorMsg: 'Nama wajib diisi'),
              const SizedBox(height: 16),
              _buildSectionTitle('Jumlah *'),
              _buildTextField(_quantityController, 'Misal: 40', isNumber: true),
              const SizedBox(height: 16),
              _buildSectionTitle('Berat *'),
              _buildTextField(_weightController, 'Misal: 100', isNumber: true),
              const SizedBox(height: 16),
              _buildSectionTitle('Jenis Kelamin *'),
              _buildDropdown(
                value: _gender,
                items: _genderOptions,
                onChanged: (val) => setState(() => _gender = val),
                validatorMsg: 'Wajib memilih jenis kelamin',
              ),
              const SizedBox(height: 16),
              _buildSectionTitle('Lokasi *'),
              _buildTextField(_locationController, 'Masukkan lokasi'),
              const SizedBox(height: 16),
              _buildSectionTitle('Harga *'),
              _buildTextField(_priceController, 'Misal: 40000000',
                  isNumber: true),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Tambahkan Ternak',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800]),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false, String? validatorMsg}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (v) {
        if (v == null || v.isEmpty) return validatorMsg ?? 'Wajib diisi';
        return null;
      },
    );
  }

  Widget _buildDropdown(
      {required String? value,
      required List<String> items,
      required Function(String?) onChanged,
      required String validatorMsg}) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      validator: (v) => v == null ? validatorMsg : null,
    );
  }
}
