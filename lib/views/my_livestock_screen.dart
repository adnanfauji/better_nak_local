import 'package:flutter/material.dart';
import 'add_livestock_screen.dart';
import 'livestock_list.dart';

class MyLivestockScreen extends StatelessWidget {
  const MyLivestockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5, // Live, Habis, Sedang Diperiksa, Perlu Tindakan, Arsip
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Ternak Saya',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 1,
          bottom: const TabBar(
            labelColor: Colors.green,
            unselectedLabelColor: Colors.grey,
            isScrollable: true,
            indicatorColor: Colors.green,
            tabs: [
              Tab(text: 'Live'),
              Tab(text: 'Habis'),
              Tab(text: 'Sedang Diperiksa'),
              Tab(text: 'Perlu Tindakan'),
              Tab(text: 'Arsip'),
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(
              children: [
                LivestockListCompact(), // Tab "Live"
                Center(child: Text('Kosong')),
                Center(child: Text('Kosong')),
                Center(child: Text('Kosong')),
                Center(child: Text('Kosong')),
              ],
            ),
            Positioned(
              bottom: 10,
              left: 16,
              right: 16,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddLivestockScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tambah Produk Baru',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
