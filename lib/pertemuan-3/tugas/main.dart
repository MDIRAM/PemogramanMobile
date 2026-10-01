import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class Barang {
  String nama;
  int jumlah;
  String kategori;
  bool dibeli;

  Barang({
    required this.nama,
    required this.jumlah,
    required this.kategori,
    this.dibeli = false,
  });
}


class BelanjaModel extends ChangeNotifier {
  final List<Barang> _items = [];

  List<Barang> get items => List.unmodifiable(_items);


  int get belumDibeliCount => _items.where((item) => !item.dibeli).length;

  void tambahBarang(String nama, int jumlah, String kategori) {
    _items.add(Barang(nama: nama, jumlah: jumlah, kategori: kategori));
    notifyListeners();
  }

  void toggleStatus(int index) {
    _items[index].dibeli = !_items[index].dibeli;
    notifyListeners();
  }

  void hapusBarang(int index) {
    _items.removeAt(index);
    notifyListeners();
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BelanjaModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas - Daftar Belanja',
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const DaftarBelanjaPage(),
    );
  }
}


class DaftarBelanjaPage extends StatelessWidget {
  const DaftarBelanjaPage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BelanjaModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Belanja (${model.belumDibeliCount} Belum Dibeli)'),
        backgroundColor: Colors.teal.shade100,
      ),
      body: model.items.isEmpty
          ? const Center(
        child: Text(
          'Daftar belanja masih kosong',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: model.items.length,
        itemBuilder: (context, index) {
          final item = model.items[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: Checkbox(
                value: item.dibeli,
                onChanged: (_) => context.read<BelanjaModel>().toggleStatus(index),
              ),
              title: Text(
                item.nama,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  decoration: item.dibeli ? TextDecoration.lineThrough : null,
                ),
              ),
              subtitle: Text('Jumlah: ${item.jumlah} | Kategori: ${item.kategori}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.redAccent),
                onPressed: () => context.read<BelanjaModel>().hapusBarang(index),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const TambahBarangPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}


class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _jumlahController = TextEditingController();
  String? _kategoriTerpilih;

  final List<String> _kategoriList = [
    'Makanan',
    'Minuman',
    'Bumbu & Dapur',
    'Kebutuhan Rumah',
    'Lainnya',
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _jumlahController.dispose();
    super.dispose();
  }

  void _simpanBarang() {
    if (_formKey.currentState!.validate()) {
      final nama = _namaController.text.trim();
      final jumlah = int.parse(_jumlahController.text.trim());
      final kategori = _kategoriTerpilih!;

      context.read<BelanjaModel>().tambahBarang(nama, jumlah, kategori);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barang berhasil ditambahkan!')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang Belanjaan')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Validasi Nama Barang (Wajib)
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Barang',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama barang wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              TextFormField(
                controller: _jumlahController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Jumlah wajib diisi';
                  }
                  final parsed = int.tryParse(value.trim());
                  if (parsed == null || parsed <= 0) {
                    return 'Jumlah harus berupa angka lebih dari 0';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),


              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Kategori',
                  border: OutlineInputBorder(),
                ),
                items: _kategoriList
                    .map((kat) => DropdownMenuItem(value: kat, child: Text(kat)))
                    .toList(),
                onChanged: (val) => setState(() => _kategoriTerpilih = val),
                validator: (val) => val == null ? 'Pilih kategori barang' : null,
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _simpanBarang,
                icon: const Icon(Icons.save),
                label: const Text('Simpan Ke Daftar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}