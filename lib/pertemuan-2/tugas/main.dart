import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas - Daftar Kontak',
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      home: const KontakPage(),
    );
  }
}


class Kontak {
  final String nama;
  final String telepon;
  final String email;

  const Kontak({
    required this.nama,
    required this.telepon,
    required this.email,
  });
}


const daftarKontak = [

  Kontak(nama: 'Muhamad Dika Ramadhan', telepon: '0812352260', email: 'dikaga.gmail.com'),
  Kontak(nama: 'Budi Santoso', telepon: '082198765432', email: 'budi@gmail.com'),
  Kontak(nama: 'Citra Dewi', telepon: '083811223344', email: 'citra@gmail.com'),
  Kontak(nama: 'Deni Kurniawan', telepon: '085755667788', email: 'deni@gmail.com'),
  Kontak(nama: 'Eka Putra', telepon: '087899001122', email: 'eka@gmail.com'),
  Kontak(nama: 'Fani Rahmawati', telepon: '089633445566', email: 'fani@gmail.com'),
];


class KontakPage extends StatelessWidget {
  const KontakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Kontak')),
      body: ListView.builder(
        itemCount: daftarKontak.length,
        itemBuilder: (context, index) {
          final kontak = daftarKontak[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(

              leading: CircleAvatar(
                backgroundColor: Colors.teal,
                child: Text(
                  kontak.nama[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(kontak.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(kontak.telepon),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailKontakPage(kontak: kontak),
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


class DetailKontakPage extends StatelessWidget {
  final Kontak kontak;
  const DetailKontakPage({super.key, required this.kontak});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Kontak')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                child: Text(
                  kontak.nama[0].toUpperCase(),
                  style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                kontak.nama,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.phone, color: Colors.teal),
                        title: const Text('Nomor Telepon'),
                        subtitle: Text(kontak.telepon),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.email, color: Colors.teal),
                        title: const Text('Email'),
                        subtitle: Text(kontak.email),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Kembali'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}