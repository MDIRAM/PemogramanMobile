import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDark') ?? false;

  themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  runApp(const MyApp());
}

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return MaterialApp(
          title: 'Latihan Mandiri 6',
          debugShowCheckedModeBanner: false,
          themeMode: mode,
          theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo, brightness: Brightness.light),
          darkTheme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.indigo, brightness: Brightness.dark),
          initialRoute: '/',
          routes: {
            '/': (_) => const ShellPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detail') {
              final item = settings.arguments as Item;
              return PageRouteBuilder(
                settings: settings,
                pageBuilder: (_, animation, __) => DetailPage(item: item),
                transitionsBuilder: (_, animation, __, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              );
            }
            return null;
          },
          onUnknownRoute: (settings) {
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('404')),
                body: const Center(child: Text('404 - Halaman tidak ditemukan')),
              ),
            );
          },
        );
      },
    );
  }
}

class Item {
  final String nama;
  final IconData ikon;
  final Color warna;
  final String deskripsi;

  const Item(this.nama, this.ikon, this.warna, this.deskripsi);
}

const daftarItem = [
  Item('Flutter', Icons.flutter_dash, Colors.blue, 'Framework UI buatan Google.'),
  Item('Musik', Icons.music_note, Colors.pink, 'Aplikasi pemutar musik favorit.'),
  Item('Kamera', Icons.camera_alt, Colors.orange, 'Fitur fotografi resolusi tinggi.'),
  Item('Peta', Icons.map, Colors.green, 'Sistem navigasi peta dan lokasi.'),
];

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final halaman = [
      const BerandaTab(),
      const AnimasiTab(),
      const PengaturanTab(),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Latihan Mandiri 6')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
              child: Text('Menu Navigasi', style: Theme.of(context).textTheme.headlineMedium),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Beranda'),
              selected: _index == 0,
              onTap: () {
                setState(() => _index = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('Animasi'),
              selected: _index == 1,
              onTap: () {
                setState(() => _index = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              selected: _index == 2,
              onTap: () {
                setState(() => _index = 2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _index, children: halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (idx) => setState(() => _index = idx),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Beranda'),
          NavigationDestination(icon: Icon(Icons.animation), label: 'Animasi'),
          NavigationDestination(icon: Icon(Icons.settings_outlined), selectedIcon: Icon(Icons.settings), label: 'Pengaturan'),
        ],
      ),
    );
  }
}

class BerandaTab extends StatelessWidget {
  const BerandaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: daftarItem.length,
      itemBuilder: (context, i) {
        final item = daftarItem[i];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                backgroundColor: item.warna,
                child: Icon(item.ikon, color: Colors.white),
              ),
            ),
            title: Text(item.nama),
            subtitle: Text(item.deskripsi),
            onTap: () {
              Navigator.pushNamed(context, '/detail', arguments: item);
            },
          ),
        );
      },
    );
  }
}

class DetailPage extends StatelessWidget {
  final Item item;
  const DetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.nama)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: 'ikon-${item.nama}',
              child: CircleAvatar(
                radius: 60,
                backgroundColor: item.warna,
                child: Icon(item.ikon, size: 60, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(item.nama, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(item.deskripsi),
          ],
        ),
      ),
    );
  }
}

class AnimasiTab extends StatefulWidget {
  const AnimasiTab({super.key});

  @override
  State<AnimasiTab> createState() => _AnimasiTabState();
}

class _AnimasiTabState extends State<AnimasiTab> with SingleTickerProviderStateMixin {
  bool _besar = false;
  int _hitung = 0;
  bool _visible = true;
  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();
    _putar = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('1. AnimatedContainer'),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: _besar ? 150 : 80,
            height: 80,
            decoration: BoxDecoration(
              color: _besar ? tema.colorScheme.primary : tema.colorScheme.tertiary,
              borderRadius: BorderRadius.circular(_besar ? 40 : 8),
            ),
          ),
        ),
        TextButton(onPressed: () => setState(() => _besar = !_besar), child: const Text('Ubah Bentuk')),
        const Divider(),
        const Text('2. AnimatedSwitcher'),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text('$_hitung', key: ValueKey(_hitung), style: tema.textTheme.displayMedium),
          ),
        ),
        TextButton(onPressed: () => setState(() => _hitung++), child: const Text('Tambah')),
        const Divider(),
        const Text('3. AnimationController'),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(Icons.settings, size: 60, color: tema.colorScheme.primary),
          ),
        ),
        TextButton(
          onPressed: () {
            if (_putar.isAnimating) {
              _putar.stop();
            } else {
              _putar.repeat();
            }
            setState(() {});
          },
          child: Text(_putar.isAnimating ? 'Berhenti' : 'Putar'),
        ),
        const Divider(),
        const Text('4. AnimatedOpacity (Latihan Mandiri 5)'),
        Center(
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Card(
              color: tema.colorScheme.secondaryContainer,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Kartu Opacity (Fade In/Out)'),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _visible = !_visible),
          child: Text(_visible ? 'Sembunyikan' : 'Tampilkan'),
        ),
      ],
    );
  }
}

class PengaturanTab extends StatelessWidget {
  const PengaturanTab({super.key});

  Future<void> _simpanTema(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', isDark);
    themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeMode,
      builder: (context, mode, _) {
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode Gelap'),
              value: mode == ThemeMode.dark,
              onChanged: (v) => _simpanTema(v),
            ),
          ],
        );
      },
    );
  }
}