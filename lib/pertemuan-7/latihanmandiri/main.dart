import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:intl/intl.dart';

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
    this.kategori = 'Umum',
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

final versiData = ValueNotifier<int>(0);

class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = p.join(await getDatabasesPath(), 'tabungku_lm7.db');
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

  static Future<Map<String, int>> ringkasan(String tanggal) async {
    final db = await database;
    final res = await db.rawQuery('''
      SELECT 
        COALESCE(SUM(CASE WHEN tipe = 'pemasukan' THEN nominal END), 0) AS masuk,
        COALESCE(SUM(CASE WHEN tipe = 'pengeluaran' THEN nominal END), 0) AS keluar
      FROM kegiatan WHERE tanggal = ?
    ''', [tanggal]);

    final baris = res.first;
    return {
      'masuk': baris['masuk'] as int,
      'keluar': baris['keluar'] as int,
    };
  }
}

String formatRupiah(int nominal) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(nominal);
String formatTanggal(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ShellPageLM(),
  ));
}

class ShellPageLM extends StatefulWidget {
  const ShellPageLM({super.key});

  @override
  State<ShellPageLM> createState() => _ShellPageLMState();
}

class _ShellPageLMState extends State<ShellPageLM> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latihan Mandiri 7')),
      body: IndexedStack(
        index: _index,
        children: const [
          BerandaLM(),
          LaporanLM(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (idx) => setState(() => _index = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.today), label: 'Hari Ini'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Laporan Filter'),
        ],
      ),
    );
  }
}

class BerandaLM extends StatefulWidget {
  const BerandaLM({super.key});

  @override
  State<BerandaLM> createState() => _BerandaLMState();
}

class _BerandaLMState extends State<BerandaLM> {
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
        builder: (context, AsyncSnapshot<List<dynamic>> snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());

          final list = snap.data![0] as List<Kegiatan>;
          final ringkasan = snap.data![1] as Map<String, int>;
          final tabungan = ringkasan['masuk']! - ringkasan['keluar']!;

          return ListView(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text('Tabungan Hari Ini: ${formatRupiah(tabungan)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      if (tabungan < 0)
                        const Text('⚠️ Peringatan: Tabungan kamu minus!', style: TextStyle(color: Colors.red))
                      else if (tabungan >= 20000)
                        const Text('🎉 Hebat! Kamu berhasil mencapai target menabung Rp 20.000', style: TextStyle(color: Colors.green)),
                    ],
                  ),
                ),
              ),
              ...list.map((k) => ListTile(
                title: Text(k.judul),
                subtitle: Text('${k.tipe.name.toUpperCase()} - ${formatRupiah(k.nominal)}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Fitur Latihan Mandiri: Konfirmasi AlertDialog
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Kegiatan'),
                        content: const Text('Yakin mau menghapus kegiatan ini?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                          TextButton(
                            onPressed: () {
                              DbHelper.hapus(k.id!);
                              Navigator.pop(ctx);
                            },
                            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          DbHelper.tambah(Kegiatan(
            judul: 'Pengeluaran Contoh',
            tanggal: _today,
            tipe: Tipe.pengeluaran,
            nominal: 15000,
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class LaporanLM extends StatefulWidget {
  const LaporanLM({super.key});

  @override
  State<LaporanLM> createState() => _LaporanLMState();
}

class _LaporanLMState extends State<LaporanLM> {
  DateTime _tglFilter = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tglStr = formatTanggal(_tglFilter);

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Pilih Tanggal: $tglStr'),
            trailing: const Icon(Icons.calendar_month),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _tglFilter,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
              );
              if (picked != null) setState(() => _tglFilter = picked);
            },
          ),
          FutureBuilder(
            future: DbHelper.padaTanggal(tglStr),
            builder: (context, AsyncSnapshot<List<Kegiatan>> snap) {
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final list = snap.data!;
              if (list.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(16), child: Text('Tidak ada data pada tanggal ini')));

              return Column(
                children: list.map((k) => ListTile(
                  title: Text(k.judul),
                  subtitle: Text(formatRupiah(k.nominal)),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}