import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

// --- MODELS ---
enum Tipe { tanpa, pemasukan, pengeluaran }

class Kegiatan {
  final int? id;
  final String judul;
  final String tanggal;
  final bool selesai;
  final Tipe tipe;
  final int nominal;
  final String kategori;

  Kegiatan({
    this.id,
    required this.judul,
    required this.tanggal,
    this.selesai = false,
    required this.tipe,
    this.nominal = 0,
    this.kategori = '-',
  });

  Map<String, Object?> toMap() => {
    'id': id,
    'judul': judul,
    'tanggal': tanggal,
    'selesai': selesai ? 1 : 0,
    'tipe': tipe.name,
    'nominal': nominal,
    'kategori': kategori,
  };

  factory Kegiatan.fromMap(Map<String, Object?> m) => Kegiatan(
    id: m['id'] as int?,
    judul: m['judul'] as String,
    tanggal: m['tanggal'] as String,
    selesai: (m['selesai'] as int) == 1,
    tipe: Tipe.values.byName(m['tipe'] as String),
    nominal: m['nominal'] as int,
    kategori: m['kategori'] as String,
  );
}

class Ringkasan {
  final int jumlahKegiatan;
  final int selesai;
  final int pemasukan;
  final int pengeluaran;

  Ringkasan({
    required this.jumlahKegiatan,
    required this.selesai,
    required this.pemasukan,
    required this.pengeluaran,
  });

  int get tabungan => pemasukan - pengeluaran;
}

// --- DATABASE HELPER ---
final versiData = ValueNotifier<int>(0);

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = p.join(await getDatabasesPath(), 'tabungku_p7.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kegiatan (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            judul TEXT NOT NULL,
            tanggal TEXT NOT NULL,
            selesai INTEGER NOT NULL,
            tipe TEXT NOT NULL,
            nominal INTEGER NOT NULL,
            kategori TEXT NOT NULL
          )
        ''');
      },
    );
  }

  static Future<int> tambah(Kegiatan k) async {
    final db = await database;
    final res = await db.insert('kegiatan', k.toMap());
    versiData.value++;
    return res;
  }

  static Future<int> ubah(Kegiatan k) async {
    final db = await database;
    final res = await db.update('kegiatan', k.toMap(), where: 'id = ?', whereArgs: [k.id]);
    versiData.value++;
    return res;
  }

  static Future<int> hapus(int id) async {
    final db = await database;
    final res = await db.delete('kegiatan', where: 'id = ?', whereArgs: [id]);
    versiData.value++;
    return res;
  }

  static Future<List<Kegiatan>> padaTanggal(String tanggal) async {
    final db = await database;
    final res = await db.query('kegiatan', where: 'tanggal = ?', whereArgs: [tanggal]);
    return res.map((m) => Kegiatan.fromMap(m)).toList();
  }

  static Future<Ringkasan> ringkasan(String tanggal) async {
    final db = await database;
    final hasil = await db.rawQuery('''
      SELECT COUNT(*) AS jumlah,
             COALESCE(SUM(selesai), 0) AS selesai,
             COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal END), 0) AS masuk,
             COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal END), 0) AS keluar
      FROM kegiatan
      WHERE tanggal = ?
    ''', [tanggal]);

    final baris = hasil.first;
    return Ringkasan(
      jumlahKegiatan: baris['jumlah'] as int,
      selesai: baris['selesai'] as int,
      pemasukan: baris['masuk'] as int,
      pengeluaran: baris['keluar'] as int,
    );
  }
}

// --- UTILS ---
String formatRupiah(int nominal) {
  return NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(nominal);
}

String formatTanggal(DateTime dt) {
  return DateFormat('yyyy-MM-dd').format(dt);
}

// --- MAIN APP ---
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ShellPage(),
  ));
}

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const BerandaPage(),
      const LaporanPage(),
      const PengaturanPage(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Praktikum 7 - TabungKu')),
      body: IndexedStack(index: _index, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (idx) => setState(() => _index = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Hari Ini'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Laporan'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}

class BerandaPage extends StatefulWidget {
  const BerandaPage({super.key});

  @override
  State<BerandaPage> createState() => _BerandaPageState();
}

class _BerandaPageState extends State<BerandaPage> {
  final String _today = formatTanggal(DateTime.now());

  @override
  void initState() {
    super.initState();
    versiData.addListener(_update);
  }

  @override
  void dispose() {
    versiData.removeListener(_update);
    super.dispose();
  }

  void _update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: Future.wait([
          DbHelper.padaTanggal(_today),
          DbHelper.ringkasan(_today),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final list = snapshot.data![0] as List<Kegiatan>;
          final ringkasan = snapshot.data![1] as Ringkasan;

          return ListView(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Selesai: ${ringkasan.selesai}/${ringkasan.jumlahKegiatan}'),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Masuk', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(
                                  formatRupiah(ringkasan.pemasukan),
                                  style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Keluar', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(
                                  formatRupiah(ringkasan.pengeluaran),
                                  style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                const Text('Tabungan', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(
                                  formatRupiah(ringkasan.tabungan),
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              ...list.map((k) => ListTile(
                leading: Checkbox(
                  value: k.selesai,
                  onChanged: (v) => DbHelper.ubah(Kegiatan(
                    id: k.id,
                    judul: k.judul,
                    tanggal: k.tanggal,
                    selesai: v ?? false,
                    tipe: k.tipe,
                    nominal: k.nominal,
                    kategori: k.kategori,
                  )),
                ),
                title: Text(k.judul, style: TextStyle(decoration: k.selesai ? TextDecoration.lineThrough : null)),
                subtitle: Text('${k.tipe.name.toUpperCase()} - ${k.kategori}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => DbHelper.hapus(k.id!),
                ),
              )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _nominalCtrl = TextEditingController();
  Tipe _tipe = Tipe.tanpa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kegiatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(labelText: 'Judul Kegiatan'),
              validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
            ),
            DropdownButtonFormField<Tipe>(
              initialValue: _tipe,
              items: Tipe.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()))).toList(),
              onChanged: (v) => setState(() => _tipe = v!),
            ),
            if (_tipe != Tipe.tanpa)
              TextFormField(
                controller: _nominalCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal (Rp)'),
                validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Nominal tidak valid' : null,
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  DbHelper.tambah(Kegiatan(
                    judul: _judulCtrl.text,
                    tanggal: formatTanggal(DateTime.now()),
                    tipe: _tipe,
                    nominal: _tipe == Tipe.tanpa ? 0 : int.parse(_nominalCtrl.text),
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Halaman Laporan (Praktikum)'));
  }
}

class PengaturanPage extends StatelessWidget {
  const PengaturanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Halaman Pengaturan (Praktikum)'));
  }
}