import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Praktikum Modul 6',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => ShellPage(
          themeMode: _themeMode,
          onThemeChanged: _toggleTheme,
        ),
        '/detail': (context) {
          final item = ModalRoute.of(context)!.settings.arguments as Item;
          return DetailPage(item: item);
        },
      },
    );
  }
}

class ShellPage extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeChanged;

  const ShellPage({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

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
      PengaturanTab(
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Praktikum Modul 6')),
      body: IndexedStack(index: _index, children: halaman),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (idx) => setState(() => _index = idx),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
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
              color: _besar ? Colors.indigo : Colors.amber,
              borderRadius: BorderRadius.circular(_besar ? 40 : 8),
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _besar = !_besar),
          child: const Text('Ubah Bentuk'),
        ),
        const Divider(),
        const Text('2. AnimatedSwitcher'),
        Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Text(
              '$_hitung',
              key: ValueKey(_hitung),
              style: Theme.of(context).textTheme.displayMedium,
            ),
          ),
        ),
        TextButton(
          onPressed: () => setState(() => _hitung++),
          child: const Text('Tambah'),
        ),
        const Divider(),
        const Text('3. AnimationController (Eksplisit)'),
        Center(
          child: RotationTransition(
            turns: _putar,
            child: const Icon(Icons.settings, size: 60, color: Colors.indigo),
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
  final ThemeMode themeMode;
  final ValueChanged<bool> onThemeChanged;

  const PengaturanTab({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Mode Gelap'),
          value: themeMode == ThemeMode.dark,
          onChanged: onThemeChanged,
        ),
      ],
    );
  }
}