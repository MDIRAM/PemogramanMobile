import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Latihan Mandiri 2',
      theme: ThemeData(colorSchemeSeed: Colors.orange, useMaterial3: true),
      home: const MenuPage(),
    );
  }
}


class Makanan {
  final String nama;
  final int harga;
  final String deskripsi;
  const Makanan(this.nama, this.harga, this.deskripsi);
}


String formatRupiah(int harga) {
  String str = harga.toString();
  String result = '';
  int count = 0;
  for (int i = str.length - 1; i >= 0; i--) {
    result = str[i] + result;
    count++;
    if (count % 3 == 0 && i != 0) {
      result = '.$result';
    }
  }
  return 'Rp $result';
}


const daftarMenu = [
  Makanan('Nasi Goreng', 15000, 'Nasi goreng khas dengan telur dan ayam suwir.'),
  Makanan('Mie Ayam', 12000, 'Mie kenyal dengan toping ayam manis gurih.'),
  Makanan('Es Teh', 4000, 'Es teh manis segar pelepas dahaga.'),
  Makanan('Ayam Bakar', 20000, 'Ayam bakar dengan bumbu kecap meresap.'),
  Makanan('Soto Ayam', 18000, 'Soto ayam kuah kuning gurih segar.'),
  Makanan('Bakso Sapi', 16000, 'Bakso sapi kenyal dengan kuah kaldu sapi.'),
  Makanan('Es Jeruk', 5000, 'Es jeruk peras asli kaya vitamin C.'),
];

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Menu (Latihan Mandiri)')),
      body: ListView.builder(
        itemCount: daftarMenu.length,
        itemBuilder: (context, index) {
          final item = daftarMenu[index];

          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: ListTile(
              leading: const Icon(Icons.restaurant, color: Colors.orange),
              title: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(formatRupiah(item.harga)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPage(makanan: item),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  final Makanan makanan;
  const DetailPage({super.key, required this.makanan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(makanan.nama)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.restaurant_menu, size: 80, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                makanan.nama,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                formatRupiah(makanan.harga),
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 16),

              Text(
                makanan.deskripsi,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}