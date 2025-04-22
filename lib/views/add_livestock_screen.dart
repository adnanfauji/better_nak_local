import 'package:flutter/material.dart';

class AddLivestockScreen extends StatefulWidget {
  const AddLivestockScreen({super.key});

  @override
  State<AddLivestockScreen> createState() => _AddLivestockScreenState();
}

class _AddLivestockScreenState extends State<AddLivestockScreen> {
  final _formKey = GlobalKey<FormState>();

  // State untuk masing‑masing field
  String? _photoFileName;
  String? _managementType;
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _weightController = TextEditingController();
  String? _gender;
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();

  // Opsi dropdown
  final _managementOptions = [
    'Sapi',
    'Kambing',
    'Domba',
  ];
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

  void _pickPhoto() {
    // TODO: implement file picker
    setState(() {
      _photoFileName = 'Sapi Limousin.png';
    });
  }

  void _saveForm() {
    if (_formKey.currentState!.validate()) {
      // TODO: kirim data ke backend
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ternak berhasil ditambahkan')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3E0), // merah muda lembut
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
              // Tambahkan Foto
              Text(
                'Tambahkan Foto *',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 6),
              OutlinedButton(
                onPressed: _pickPhoto,
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    _photoFileName ?? 'Pilih Foto...',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Dropdown Jenis Manajemen
              Text(
                'Jenis Ternak',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _managementType,
                items: _managementOptions
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (v) => setState(() => _managementType = v),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (v) => v == null ? 'Wajib memilih jenis' : null,
              ),
              const SizedBox(height: 16),

              // Nama Hewan/Pakan/Produksi
              Text(
                'Nama Hewan *',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Masukkan nama',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Jumlah
              Text(
                'Jumlah *',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(
                  hintText: 'Misal: 40 Ekor',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Berat
              Text(
                'Berat *',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _weightController,
                decoration: InputDecoration(
                  hintText: 'Misal: 100 kg',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Jenis Kelamin
              Text(
                'Jenis Kelamin *',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _gender,
                items: _genderOptions
                    .map((g) => DropdownMenuItem(
                          value: g,
                          child: Text(g),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _gender = v),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (v) =>
                    v == null ? 'Wajib memilih jenis kelamin' : null,
              ),
              const SizedBox(height: 16),

              // Lokasi
              Text(
                'Lokasi *',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  hintText: 'Masukkan lokasi',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 16),

              // Harga
              Text(
                'Harga *',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(
                  hintText: 'Misal: Rp 40.000.000',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // warna coklat
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Tambahkan Ternak',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
