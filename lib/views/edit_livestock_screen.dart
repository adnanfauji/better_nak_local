import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditLivestockScreen extends StatefulWidget {
  final Map<String, dynamic> item;
  const EditLivestockScreen({super.key, required this.item});

  @override
  State<EditLivestockScreen> createState() => _EditLivestockScreenState();
}

class _EditLivestockScreenState extends State<EditLivestockScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedImage;
  late String _managementType;
  late TextEditingController _nameCtrl;
  late TextEditingController _qtyCtrl;
  late TextEditingController _weightCtrl;
  late String _gender;
  late TextEditingController _locCtrl;
  late TextEditingController _priceCtrl;
  final _picker = ImagePicker();

  final _types = ['Sapi', 'Kambing', 'Domba'];
  final _genders = ['Jantan', 'Betina'];

  @override
  void initState() {
    super.initState();
    final i = widget.item;
    _managementType = i['type'];
    _nameCtrl = TextEditingController(text: i['name']);
    _qtyCtrl = TextEditingController(text: i['quantity'].toString());
    _weightCtrl = TextEditingController(text: i['weight']);
    _gender = i['gender'];
    _locCtrl = TextEditingController(text: i['location']);
    _priceCtrl = TextEditingController(text: i['price'].toString());
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _qtyCtrl.dispose();
    _weightCtrl.dispose();
    _locCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final p = await showDialog<ImageSource>(
        context: context,
        builder: (c) => AlertDialog(
              title: const Text('Ambil foto dari'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(c, ImageSource.camera),
                    child: const Text('Kamera')),
                TextButton(
                    onPressed: () => Navigator.pop(c, ImageSource.gallery),
                    child: const Text('Galeri')),
              ],
            ));
    if (p != null) {
      final f = await _picker.pickImage(source: p);
      if (f != null) setState(() => _selectedImage = File(f.path));
    }
  }

  Future<void> _saveEdits() async {
    if (!_formKey.currentState!.validate()) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()));
    var req = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2/api_local/update_livestock.php'));
    req.fields['id'] = widget.item['id'].toString();
    req.fields['type'] = _managementType;
    req.fields['name'] = _nameCtrl.text;
    req.fields['quantity'] = _qtyCtrl.text;
    req.fields['weight'] = _weightCtrl.text;
    req.fields['gender'] = _gender;
    req.fields['location'] = _locCtrl.text;
    req.fields['price'] = _priceCtrl.text;
    if (_selectedImage != null) {
      req.files.add(
          await http.MultipartFile.fromPath('photo', _selectedImage!.path));
    }
    var res = await req.send();
    var body = await http.Response.fromStream(res);
    Navigator.pop(context); // tutup loading
    final data = jsonDecode(body.body);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(data['message'])));
    if (data['success'] == true) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext c) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Edit Ternak'), backgroundColor: Colors.green),
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
                key: _formKey,
                child: ListView(children: [
                  Text('Foto', style: Theme.of(c).textTheme.titleMedium),
                  const SizedBox(height: 6),
                  OutlinedButton(
                    onPressed: _pickImage,
                    child: _selectedImage == null
                        ? Text('Ganti Foto (opsional)')
                        : Image.file(_selectedImage!,
                            height: 100, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    value: _managementType,
                    decoration:
                        const InputDecoration(labelText: 'Jenis Ternak'),
                    items: _types
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => _managementType = v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nama Hewan'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _qtyCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Jumlah'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _weightCtrl,
                    decoration: const InputDecoration(labelText: 'Berat'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField(
                    value: _gender,
                    decoration:
                        const InputDecoration(labelText: 'Jenis Kelamin'),
                    items: _genders
                        .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                        .toList(),
                    onChanged: (v) => setState(() => _gender = v!),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _locCtrl,
                    decoration: const InputDecoration(labelText: 'Lokasi'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _priceCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Harga'),
                    validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                      onPressed: _saveEdits,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green),
                      child: const Text('Simpan Perubahan',
                          style: TextStyle(color: Colors.white)))
                ]))));
  }
}
