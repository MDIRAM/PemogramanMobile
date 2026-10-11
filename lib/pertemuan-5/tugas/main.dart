import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDark = false;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDark = prefs.getBool('isDark') ?? false;
    });
  }

  Future<void> _toggleTheme(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', val);
    setState(() {
      _isDark = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pencatat Pengeluaran',
      theme: ThemeData(
        brightness: _isDark ? Brightness.dark : Brightness.light,
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: HomePage(
        isDark: _isDark,
        onThemeChanged: _toggleTheme,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class Pengeluaran {
  final int? id;
  final String nama;
  final int jumlah;
  final String kategori;
  final String tanggal;

  const Pengeluaran({
    this.id,
    required this.nama,
    required this.jumlah,
    required this.kategori,
    required this.tanggal,
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'nama': nama,
    'jumlah': jumlah,
    'kategori': kategori,
    'tanggal': tanggal,
  };

  factory Pengeluaran.fromMap(Map<String, Object?> m) => Pengeluaran(
    id: m['id'] as int?,
    nama: m['nama'] as String,
    jumlah: m['jumlah'] as int,
    kategori: m['kategori'] as String,
    tanggal: m['tanggal'] as String,
  );
}

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final path = p.join(await getDatabasesPath(), 'pengeluaran.db');
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE pengeluaran('
              'id INTEGER PRIMARY KEY AUTOINCREMENT, '
              'nama TEXT NOT NULL, '
              'jumlah INTEGER NOT NULL, '
              'kategori TEXT NOT NULL, '
              'tanggal TEXT NOT NULL)',
        );
      },
    );
    return _db!;
  }

  static Future<int> tambah(Pengeluaran p) async {
    final db = await database;
    return db.insert('pengeluaran', p.toMap());
  }

  static Future<List<Pengeluaran>> semua() async {
    final db = await database;
    final rows = await db.query('pengeluaran', orderBy: 'id DESC');
    return rows.map(Pengeluaran.fromMap).toList();
  }

  static Future<int> ubah(Pengeluaran p) async {
    final db = await database;
    return db.update('pengeluaran', p.toMap(), where: 'id = ?', whereArgs: [p.id]);
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    return db.delete('pengeluaran', where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> hitungTotal() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(jumlah) as total FROM pengeluaran');
    return (result.first['total'] as int?) ?? 0;
  }
}

class HomePage extends StatefulWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeChanged;

  const HomePage({
    super.key,
    required this.isDark,
    required this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Pengeluaran>> _futureData;
  int _totalPengeluaran = 0;

  @override
  void initState() {
    super.initState();
    _muatData();
  }

  void _muatData() async {
    setState(() {
      _futureData = DbHelper.semua();
    });
    final total = await DbHelper.hitungTotal();
    if (!mounted) return;
    setState(() {
      _totalPengeluaran = total;
    });
  }

  Future<void> _bukaForm([Pengeluaran? item]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FormPengeluaranPage(item: item)),
    );
    if (!mounted) return;
    _muatData();
  }

  Future<void> _konfirmasiHapus(int id) async {
    final setuju = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Hapus catatan pengeluaran ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (setuju == true) {
      await DbHelper.hapus(id);
      _muatData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencatat Pengeluaran'),
        actions: [
          Row(
            children: [
              const Icon(Icons.dark_mode, size: 20),
              Switch(
                value: widget.isDark,
                onChanged: widget.onThemeChanged,
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Pengeluaran',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Rp $_totalPengeluaran',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Pengeluaran>>(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final data = snapshot.data ?? [];
                if (data.isEmpty) {
                  return const Center(child: Text('Belum ada data pengeluaran.'));
                }
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final p = data[i];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Icon(_getKategoriIcon(p.kategori)),
                        ),
                        title: Text(p.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('${p.kategori} • ${p.tanggal}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Rp ${p.jumlah}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => _konfirmasiHapus(p.id!),
                            ),
                          ],
                        ),
                        onTap: () => _bukaForm(p),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaForm(),
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getKategoriIcon(String kat) {
    switch (kat) {
      case 'Makanan':
        return Icons.fastfood;
      case 'Transportasi':
        return Icons.directions_car;
      case 'Hiburan':
        return Icons.movie;
      case 'Belanja':
        return Icons.shopping_bag;
      default:
        return Icons.receipt_long;
    }
  }
}

class FormPengeluaranPage extends StatefulWidget {
  final Pengeluaran? item;
  const FormPengeluaranPage({super.key, this.item});

  @override
  State<FormPengeluaranPage> createState() => _FormPengeluaranPageState();
}

class _FormPengeluaranPageState extends State<FormPengeluaranPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nama;
  late final TextEditingController _jumlah;

  final List<String> _kategoriList = [
    'Makanan',
    'Transportasi',
    'Hiburan',
    'Belanja',
    'Lainnya',
  ];
  String _kategoriTerpilih = 'Makanan';

  @override
  void initState() {
    super.initState();
    _nama = TextEditingController(text: widget.item?.nama ?? '');
    _jumlah = TextEditingController(text: widget.item?.jumlah.toString() ?? '');
    if (widget.item != null && _kategoriList.contains(widget.item!.kategori)) {
      _kategoriTerpilih = widget.item!.kategori;
    }
  }

  @override
  void dispose() {
    _nama.dispose();
    _jumlah.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final tanggal = widget.item?.tanggal ??
        DateTime.now().toString().split(' ')[0];

    final p = Pengeluaran(
      id: widget.item?.id,
      nama: _nama.text.trim(),
      jumlah: int.parse(_jumlah.text.trim()),
      kategori: _kategoriTerpilih,
      tanggal: tanggal,
    );

    if (widget.item == null) {
      await DbHelper.tambah(p);
    } else {
      await DbHelper.ubah(p);
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final baru = widget.item == null;
    return Scaffold(
      appBar: AppBar(title: Text(baru ? 'Tambah Pengeluaran' : 'Ubah Pengeluaran')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nama,
              decoration: const InputDecoration(
                labelText: 'Nama Pengeluaran',
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _jumlah,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Jumlah (Rp)',
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Jumlah wajib diisi';
                final n = int.tryParse(v.trim());
                if (n == null || n <= 0) return 'Jumlah harus berupa angka > 0';
                return null;
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kategoriTerpilih,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                border: OutlineInputBorder(),
              ),
              items: _kategoriList
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _kategoriTerpilih = val);
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _simpan,
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}