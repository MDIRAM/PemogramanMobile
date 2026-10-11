import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isDark = prefs.getBool('isDark') ?? false;
  final colorIndex = prefs.getInt('colorIndex') ?? 0;

  themeMode.value = isDark ? ThemeMode.dark : ThemeMode.light;
  if (colorIndex >= 0 && colorIndex < pilihanWarna.length) {
    seedColor.value = pilihanWarna[colorIndex];
  }

  runApp(const MyApp());
}

final themeMode = ValueNotifier<ThemeMode>(ThemeMode.light);
final seedColor = ValueNotifier<Color>(Colors.indigo);

const pilihanWarna = [
  Colors.indigo,
  Colors.teal,
  Colors.deepOrange,
  Colors.pink,
];

ThemeData buatTema(Color seed, Brightness brightness) {
  return ThemeData(
    useMaterial3: true,
    colorSchemeSeed: seed,
    brightness: brightness,
    appBarTheme: const AppBarTheme(centerTitle: true),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Katalog Wisata Interaktif',
          debugShowCheckedModeBanner: false,
          theme: buatTema(seedColor.value, Brightness.light),
          darkTheme: buatTema(seedColor.value, Brightness.dark),
          themeMode: themeMode.value,
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
                appBar: AppBar(title: const Text('404 - Tidak Ditemukan')),
                body: const Center(
                  child: Text('Halaman 404\nHalaman tidak ditemukan!', textAlign: TextAlign.center),
                ),
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

const daftarWisata = [
  Item('Candi Borobudur', Icons.landscape, Colors.amber, 'Candi Buddha terbesar di dunia yang terletak di Magelang, Jawa Tengah.'),
  Item('Pantai Kuta', Icons.beach_access, Colors.blue, 'Destinasi wisata pantai ikonik dengan pemandangan matahari terbenam di Bali.'),
  Item('Gunung Bromo', Icons.terrain, Colors.deepOrange, 'Gunung berapi aktif dengan keindahan pemandangan lautan pasir dan sunrise.'),
  Item('Raja Ampat', Icons.pool, Colors.teal, 'Kepulauan indah di Papua Barat yang terkenal dengan keanekaragaman hayati lautnya.'),
];

class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  static const _halaman = [
    KatalogTab(),
    DemoAnimasiTab(),
    PengaturanTab(),
  ];

  static const _judul = [
    'Katalog Wisata',
    'Demo Animasi',
    'Pengaturan Tema',
  ];

  void _pindahTab(int idx) {
    setState(() => _index = idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_judul[_index])),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
              child: Text(
                'Katalog Wisata',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.explore),
              title: const Text('Katalog'),
              selected: _index == 0,
              onTap: () {
                _pindahTab(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation),
              title: const Text('Animasi'),
              selected: _index == 1,
              onTap: () {
                _pindahTab(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              selected: _index == 2,
              onTap: () {
                _pindahTab(2);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: IndexedStack(index: _index, children: _halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _pindahTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Katalog',
          ),
          NavigationDestination(
            icon: Icon(Icons.animation),
            label: 'Animasi',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}

class KatalogTab extends StatelessWidget {
  const KatalogTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: daftarWisata.length,
      itemBuilder: (context, i) {
        final item = daftarWisata[i];
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
            title: Text(item.nama, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(item.deskripsi, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: const Icon(Icons.chevron_right),
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
    final tema = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(item.nama)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Hero(
                tag: 'ikon-${item.nama}',
                child: CircleAvatar(
                  radius: 64,
                  backgroundColor: item.warna,
                  child: Icon(item.ikon, size: 64, color: Colors.white),
                ),
              ),
              const SizedBox(height: 16),
              Text(item.nama, style: tema.textTheme.headlineMedium),
              const SizedBox(height: 8),
              Text(
                item.deskripsi,
                style: tema.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DemoAnimasiTab extends StatefulWidget {
  const DemoAnimasiTab({super.key});

  @override
  State<DemoAnimasiTab> createState() => _DemoAnimasiTabState();
}

class _DemoAnimasiTabState extends State<DemoAnimasiTab> with SingleTickerProviderStateMixin {
  bool _besar = false;
  int _hitung = 0;
  bool _visible = true;
  late final AnimationController _putar;

  @override
  void initState() {
    super.initState();
    _putar = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _putar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tema = Theme.of(context);
    final warna = tema.colorScheme;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('1. AnimatedContainer (Implisit)', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: _besar ? 200 : 100,
            height: 100,
            decoration: BoxDecoration(
              color: _besar ? warna.primary : warna.tertiary,
              borderRadius: BorderRadius.circular(_besar ? 50 : 8),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _besar = !_besar),
          child: const Text('Ubah Ukuran / Warna'),
        ),
        const Divider(),
        Text('2. AnimatedOpacity (Implisit)', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 500),
            child: Card(
              color: warna.secondaryContainer,
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('Kartu Opacity Interaktif'),
              ),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _visible = !_visible),
          child: Text(_visible ? 'Sembunyikan' : 'Tampilkan'),
        ),
        const Divider(),
        Text('3. AnimationController (Eksplisit)', style: tema.textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: Icon(Icons.refresh, size: 64, color: warna.primary),
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

  Future<void> _simpanWarna(Color color, int index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('colorIndex', index);
    seedColor.value = color;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([themeMode, seedColor]),
      builder: (context, _) {
        final isDark = themeMode.value == ThemeMode.dark;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              title: const Text('Mode Gelap'),
              value: isDark,
              onChanged: (v) => _simpanTema(v),
            ),
            const SizedBox(height: 8),
            Text(
              'Warna Utama Tema',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                for (int i = 0; i < pilihanWarna.length; i++)
                  GestureDetector(
                    onTap: () => _simpanWarna(pilihanWarna[i], i),
                    child: CircleAvatar(
                      backgroundColor: pilihanWarna[i],
                      child: seedColor.value == pilihanWarna[i]
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}