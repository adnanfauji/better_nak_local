// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../config/config.dart';
import 'cart_screen.dart';
import 'account_settings_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io';

Future<Map<String, dynamic>> fetchUserData(String userId) async {
  final response = await http
      .get(Uri.parse('${Config.BASE_URL}/get_users.php?userId=$userId'));

  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    if (body['success']) {
      return body['data'];
    } else {
      throw Exception('User not found');
    }
  } else {
    throw Exception('Failed to load user data');
  }
}

class MyAccountScreen extends StatefulWidget {
  final String userId;

  const MyAccountScreen({super.key, required this.userId});

  @override
  State<MyAccountScreen> createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  String? userName;
  String? userRole;
  String? userProfilePicture;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      print('Fetching data for userId: ${widget.userId}');
      final userData = await fetchUserData(widget.userId);

      setState(() {
        userName = userData['name'];
        userRole = userData['role'];
        userProfilePicture = userData['profile_picture'];
      });
    } catch (e) {
      print('Error loading user data: $e');
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Crop image
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio4x3,
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop Foto Profil',
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: false,
          ),
          IOSUiSettings(
            title: 'Crop Foto Profil',
          ),
        ],
      );

      if (croppedFile != null) {
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('${Config.BASE_URL}/upload_profile_picture.php'),
        );
        request.fields['userId'] = widget.userId;
        request.files.add(await http.MultipartFile.fromPath(
            'profile_picture', File(croppedFile.path).path));

        var response = await request.send();
        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final result = json.decode(responseBody);

          if (result['success']) {
            setState(() {
              userProfilePicture = result['filename'];
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Foto profil berhasil diunggah')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Upload gagal: ${result['message']}')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal upload foto profil')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Akun Saya',
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.green),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.settings, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AccountSettingsScreen(
                          userId: widget.userId,
                          currentUsername: userName ?? 'Loading...',
                        )),
              );
            },
          ),
          IconButton(
            icon: const Icon(LucideIcons.shoppingBag, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartScreen(userId: widget.userId),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Profil
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Colors.green,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: userProfilePicture != null
                        ? NetworkImage(
                            '${Config.BASE_URL}/${userProfilePicture}')
                        : const AssetImage('images/user.png'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            userName ?? 'Loading...',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Chip(
                            label: Text(
                              userRole ?? 'Loading...',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.white,
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Row(
                        children: [
                          Text(
                            '42 Pengikut',
                            style: TextStyle(color: Colors.white70),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '48 Mengikuti',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Pesanan Saya
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Pesanan Saya',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/orderHistory');
                  },
                  child: const Text(
                    'Lihat Riwayat Pesanan >',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Menu Status Pesanan
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _orderStatusItem('Belum Bayar', Icons.payment),
              _orderStatusItem('Dikemas', Icons.inventory),
              _orderStatusItem('Dikirim', Icons.local_shipping),
              _orderStatusItem('Beri Penilaian', Icons.star_border),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderStatusItem(String title, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 32, color: Colors.black54),
        const SizedBox(height: 8),
        Text(title, style: const TextStyle(fontSize: 14)),
      ],
    );
  }
}
