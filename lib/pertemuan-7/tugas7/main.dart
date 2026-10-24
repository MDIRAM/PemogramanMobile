import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';
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

// --- STATE MANAGEMENT & SETTINGS ---
final themeModeState = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColorState = ValueNotifier<Color>(Colors.teal);
final targetState = ValueNotifier<int>(20000);
final versiData = ValueNotifier<int>(0);

class PengaturanState {
  static const listWarna = [Colors.teal, Colors.indigo, Colors.deepOrange, Colors.purple];

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    final colorIdx = prefs.getInt('colorIndex') ?? 0;
    targetState.value = prefs.getInt('target') ?? 20000;

    themeModeState.value = isDark ? ThemeMode.dark : ThemeMode.light;
    if (colorIdx >= 0 && colorIdx < listWarna.length) {
      seedColorState.value = listWarna[colorIdx];
    }
  }

  static Future<void> setDark(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
    themeModeState.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  static Future<void> setWarna(int idx) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('colorIndex', idx);
    seedColorState.value = listWarna[idx];
  }

  static Future<void> setTarget(int target) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('target', target);
    targetState.value = target;
  }
}

// --- DATABASE HELPER ---
class DbHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = p.join(await getDatabasesPath(), 'tabungku_tugas.db');
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

  static Future<Map<String, int>> pengeluaranPerKategori(String tanggal) async {
    final db = await database;
    final hasil = await db.rawQuery('''
      SELECT kategori, SUM(nominal) as total
      FROM kegiatan
      WHERE tanggal = ? AND tipe = 'pengeluaran'
      GROUP BY kategori
    ''', [tanggal]);

    return {
      for (var row in hasil) row['kategori'] as String: row['total'] as int
    };
  }
}

// --- UTILS ---
String formatRupiah(int nominal) => NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(nominal);
String formatTanggal(DateTime dt) => DateFormat('yyyy-MM-dd').format(dt);

// --- ENTRY POINT ---
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PengaturanState.init();
  runApp(const TabungKuFinalApp());
}

class TabungKuFinalApp extends StatelessWidget {
  const TabungKuFinalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeModeState, seedColorState]),
      builder: (context, _) {
        return MaterialApp(
          title: 'TabungKu Final',
          debugShowCheckedModeBanner: false,
          themeMode: themeModeState.value,
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: seedColorState.value, brightness: Brightness.light),
          darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: seedColorState.value, brightness: Brightness.dark),
          home: const ShellPageFinal(),
        );
      },
    );
  }
}

class ShellPageFinal extends StatefulWidget {
  const ShellPageFinal({super.key});

  @override
  State<ShellPageFinal> createState() => _ShellPageFinalState();
}

class _ShellPageFinalState extends State<ShellPageFinal> {
  int _index = 0;

  final _pages = const [BerandaFinal(), LaporanFinal(), PengaturanFinal()];
  final _titles = const ['TabungKu - Hari Ini', 'Laporan Keuangan', 'Pengaturan Aplikasi'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_index])),
      body: IndexedStack(index: _index, children: _pages),
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

class BerandaFinal extends StatefulWidget {
  const BerandaFinal({super.key});

  @override
  State<BerandaFinal> createState() => _BerandaFinalState();
}

class _BerandaFinalState extends State<BerandaFinal> {
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
          final target = targetState.value;
          final progress = (ringkasan.tabungan / (target == 0 ? 1 : target)).clamp(0.0, 1.0);

          return ListView(
            children: [
              Card(
                margin: const EdgeInsets.all(12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Selesai: ${ringkasan.selesai}/${ringkasan.jumlahKegiatan}'),
                          Text('Target: ${formatRupiah(target)}'),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(value: progress),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(children: [
                            const Text('Masuk'),
                            Text(formatRupiah(ringkasan.pemasukan), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          ]),
                          Column(children: [
                            const Text('Keluar'),
                            Text(formatRupiah(ringkasan.pengeluaran), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ]),
                          Column(children: [
                            const Text('Tabungan'),
                            Text(formatRupiah(ringkasan.tabungan), style: TextStyle(color: ringkasan.tabungan < 0 ? Colors.red : Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
                          ]),
                        ],
                      ),
                      if (ringkasan.tabungan < 0) ...[
                        const SizedBox(height: 8),
                        const Text('⚠️ Tabungan hari ini negatif!', style: TextStyle(color: Colors.red, fontSize: 12)),
                      ] else if (ringkasan.tabungan >= target && target > 0) ...[
                        const SizedBox(height: 8),
                        const Text('🎉 Target menabung harian tercapai!', style: TextStyle(color: Colors.green, fontSize: 12)),
                      ],
                    ],
                  ),
                ),
              ),
              if (list.isEmpty)
                const Padding(padding: EdgeInsets.all(32), child: Center(child: Text('Belum ada kegiatan hari ini.')))
              else
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
                  subtitle: k.tipe != Tipe.tanpa ? Text('${k.tipe.name.toUpperCase()} - ${k.kategori}') : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (k.tipe != Tipe.tanpa)
                        Text(
                          '${k.tipe == Tipe.pemasukan ? '+' : '-'}${formatRupiah(k.nominal)}',
                          style: TextStyle(color: k.tipe == Tipe.pemasukan ? Colors.green : Colors.red, fontWeight: FontWeight.bold),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.grey),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Hapus Kegiatan'),
                              content: const Text('Apakah Anda yakin ingin menghapus kegiatan ini?'),
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
                    ],
                  ),
                )),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FormFinalPage())),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class FormFinalPage extends StatefulWidget {
  const FormFinalPage({super.key});

  @override
  State<FormFinalPage> createState() => _FormFinalPageState();
}

class _FormFinalPageState extends State<FormFinalPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _nominalCtrl = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  Tipe _selectedTipe = Tipe.tanpa;
  String _selectedKategori = 'Makan';
  final _listKategori = ['Makan', 'Transport', 'Belajar', 'Hiburan', 'Lainnya'];

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
              decoration: const InputDecoration(labelText: 'Nama Kegiatan'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Nama wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text('Tanggal: ${formatTanggal(_selectedDate)}'),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
                if (picked != null) setState(() => _selectedDate = picked);
              },
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<Tipe>(
              value: _selectedTipe,
              decoration: const InputDecoration(labelText: 'Jenis Keuangan'),
              items: Tipe.values.map((t) => DropdownMenuItem(value: t, child: Text(t.name.toUpperCase()))).toList(),
              onChanged: (val) => setState(() => _selectedTipe = val!),
            ),
            if (_selectedTipe != Tipe.tanpa) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _nominalCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Nominal (Rp)'),
                validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Nominal harus angka > 0' : null,
              ),
            ],
            if (_selectedTipe == Tipe.pengeluaran) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedKategori,
                decoration: const InputDecoration(labelText: 'Kategori Pengeluaran'),
                items: _listKategori.map((k) => DropdownMenuItem(value: k, child: Text(k))).toList(),
                onChanged: (val) => setState(() => _selectedKategori = val!),
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  DbHelper.tambah(Kegiatan(
                    judul: _judulCtrl.text.trim(),
                    tanggal: formatTanggal(_selectedDate),
                    tipe: _selectedTipe,
                    nominal: _selectedTipe == Tipe.tanpa ? 0 : int.parse(_nominalCtrl.text),
                    kategori: _selectedTipe == Tipe.pengeluaran ? _selectedKategori : '-',
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class LaporanFinal extends StatefulWidget {
  const LaporanFinal({super.key});

  @override
  State<LaporanFinal> createState() => _LaporanFinalState();
}

class _LaporanFinalState extends State<LaporanFinal> {
  DateTime _filterDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tglStr = formatTanggal(_filterDate);

    return Scaffold(
      body: ListView(
        children: [
          ListTile(
            title: Text('Filter Tanggal: $tglStr'),
            trailing: const Icon(Icons.date_range),
            onTap: () async {
              final picked = await showDatePicker(context: context, initialDate: _filterDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
              if (picked != null) setState(() => _filterDate = picked);
            },
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Pengeluaran per Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          FutureBuilder<Map<String, int>>(
            future: DbHelper.pengeluaranPerKategori(tglStr),
            builder: (ctx, snap) {
              if (!snap.hasData || snap.data!.isEmpty) return const Padding(padding: EdgeInsets.all(16), child: Text('Tidak ada pengeluaran pada tanggal ini.'));
              return Column(
                children: snap.data!.entries.map((e) => ListTile(
                  title: Text(e.key),
                  trailing: Text(formatRupiah(e.value), style: const TextStyle(fontWeight: FontWeight.bold)),
                )).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class PengaturanFinal extends StatelessWidget {
  const PengaturanFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ValueListenableBuilder<ThemeMode>(
          valueListenable: themeModeState,
          builder: (ctx, mode, _) => SwitchListTile(
            title: const Text('Mode Gelap'),
            value: mode == ThemeMode.dark,
            onChanged: (v) => PengaturanState.setDark(v),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Target Tabungan Harian', style: TextStyle(fontWeight: FontWeight.bold)),
        ValueListenableBuilder<int>(
          valueListenable: targetState,
          builder: (ctx, target, _) => Column(
            children: [
              Slider(
                value: target.toDouble(),
                min: 0,
                max: 100000,
                divisions: 20,
                label: 'Rp $target',
                onChanged: (v) => PengaturanState.setTarget(v.toInt()),
              ),
              Text(formatRupiah(target), style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
        ),
      ],
    );
  }
}