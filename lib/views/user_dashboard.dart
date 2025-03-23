import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'profil_screen.dart';
import 'cart_screen.dart';

class HomeScreen extends StatefulWidget {
  final String name;
  const HomeScreen({super.key, required this.name});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? lastPressed;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Better-Nak',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.shoppingBag, color: Colors.green),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartScreen()),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Notifikasi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Akun',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.amber, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Kategori',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 3,
              children: [
                _categoryCard('Sapi', LucideIcons.search),
                _categoryCard('Kambing', LucideIcons.search),
              ],
            ),
            const SizedBox(height: 20),
            _sectionTitle('Ternak Terpopuler'),
            _popularItem('Sapi Limousin', '40 Bulan', '100 kg',
                '45 Ekor Hewan Ternak', 'images/cow.jpg'),
            const SizedBox(height: 20),
            _sectionTitle('Ternak Terlaris'),
            Row(
              children: [
                Expanded(
                  child: _feedItem('Kambing', '30 kg', 'images/kambing.jpeg'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _feedItem('Kambing', '35 kg', 'images/kambing2.jpg'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _categoryCard(String title, IconData icon) {
    return OutlinedButton.icon(
      onPressed: () {},
      icon: Icon(icon, color: Colors.green),
      label: Text(title, style: const TextStyle(color: Colors.green)),
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.amber, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _popularItem(
      String title, String age, String weight, String stock, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(imagePath,
                fit: BoxFit.cover, height: 150, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('$age • $weight'),
                const SizedBox(height: 4),
                Text(stock),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feedItem(String title, String stock, String imagePath) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.asset(imagePath,
                fit: BoxFit.cover, height: 100, width: double.infinity),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(stock),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
