import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Latihan Mandiri 1',
      home: LatihanPage(),
    );
  }
}

class LatihanPage extends StatefulWidget {
  const LatihanPage({super.key});

  @override
  State<LatihanPage> createState() => _LatihanPageState();
}

class _LatihanPageState extends State<LatihanPage> {
  int _count = 0;


  void _decrement() {
    setState(() {
      if (_count > 0) {
        _count--;
      }
    });
  }

  // 2. Fungsi untuk mereset angka ke 0
  void _reset() {
    setState(() {
      _count = 0;
    });
  }

  // 3. Fungsi untuk menambah angka
  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Latihan Mandiri - Counter',
          style: TextStyle(color: Colors.white), // Mengubah warna teks AppBar
        ),
        backgroundColor: Colors.indigo, // Mengubah warna AppBar
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.flutter_dash, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Halo, nama saya Muhamad Dika Ramadhan!',
              style: TextStyle(fontSize: 20, color: Colors.indigo),
            ),
            const Text(
              'NIM: 20240801045',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 32),
            Text(
              '$_count',
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: _count == 0 ? Colors.grey : Colors.indigo,
              ),
            ),
            const SizedBox(height: 24),
            // Baris tombol (Kurang, Reset, Tambah)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Tombol Kurang (-)
                FloatingActionButton(
                  onPressed: _decrement,
                  backgroundColor: Colors.redAccent,
                  child: const Icon(Icons.remove, color: Colors.white),
                ),
                const SizedBox(width: 16),
                // Tombol Reset (0)
                FloatingActionButton(
                  onPressed: _reset,
                  backgroundColor: Colors.orangeAccent,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
                const SizedBox(width: 16),
                // Tombol Tambah (+)
                FloatingActionButton(
                  onPressed: _increment,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}