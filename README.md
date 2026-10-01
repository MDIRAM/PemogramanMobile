# Praktikum Flutter Fundamental

Kumpulan hasil praktikum **Flutter Fundamental** (Pertemuan 1–3) yang membahas dasar-dasar pengembangan aplikasi mobile dengan Flutter dan Dart, mulai dari widget dan layout, daftar data dan navigasi, hingga form dan state management dengan Provider.

| | |
|---|---|
| **Nama** | Muhamad Dika Ramadhan |
| **NIM** | 20240801045 |
| **Program Studi** | Teknik Informatika |
| **Mata Kuliah** | Praktikum Flutter Fundamental |

## Daftar Isi

- [Ringkasan Pertemuan](#ringkasan-pertemuan)
- [Pertemuan 1: Pengenalan Flutter dan Aplikasi Pertama](#pertemuan-1-pengenalan-flutter-dan-aplikasi-pertama)
- [Pertemuan 2: Layout, ListView, dan Navigasi](#pertemuan-2-layout-listview-dan-navigasi)
- [Pertemuan 3: Form Input dan State Management](#pertemuan-3-form-input-dan-state-management)
- [Teknologi](#teknologi)
- [Cara Menjalankan](#cara-menjalankan)
- [Struktur Repositori](#struktur-repositori)
- [Konsep yang Dipelajari](#konsep-yang-dipelajari)

## Ringkasan Pertemuan

| Pertemuan | Topik | Proyek | Aplikasi Tugas |
|:-:|---|---|---|
| 1 | Pengenalan Flutter, instalasi, widget dasar, `StatefulWidget` | `praktikum_1` | Kartu Perkenalan |
| 2 | Layout, `ListView.builder`, model data, `Navigator` | `praktikum_2` | Daftar Kontak |
| 3 | `TextField`, `Form` dan validasi, `Provider` | `praktikum_3` | Daftar Belanja |

---

## Pertemuan 1: Pengenalan Flutter dan Aplikasi Pertama

**Tujuan:** memasang Flutter SDK, membuat dan menjalankan proyek pertama, memahami struktur proyek dan widget tree, serta memakai hot reload.

**Yang dikerjakan**

- Instalasi dan verifikasi lingkungan dengan `flutter doctor`.
- Aplikasi "Hello Flutter" dengan `MaterialApp`, `Scaffold`, `AppBar`, `Center`, dan `Text`.
- Layout vertikal dengan `Column`, `Icon`, dan `SizedBox`.
- Counter interaktif dengan `StatefulWidget` dan `setState()`.
- **Latihan:** warna kustom, tombol kurang dan reset, serta pencegahan angka negatif.
- **Tugas:** aplikasi Kartu Perkenalan (ikon, nama, NIM, jurusan, hobi).

| Hello Flutter | Counter | Latihan Mandiri | Tugas: Kartu Perkenalan |
|:-:|:-:|:-:|:-:|
| <img src="screenshots/pertemuan-1/01-hello-column.png" width="180"> | <img src="screenshots/pertemuan-1/02-counter.png" width="180"> | <img src="screenshots/pertemuan-1/03-latihan-counter.png" width="180"> | <img src="screenshots/pertemuan-1/04-tugas-kartu-perkenalan.png" width="180"> |

---

## Pertemuan 2: Layout, ListView, dan Navigasi

**Tujuan:** menyusun layout dengan `Container`, `Padding`, `Row`, `Column`, dan `Expanded`; menampilkan daftar data; memodelkan data dengan class Dart; dan berpindah halaman sambil mengirim data.

**Yang dikerjakan**

- Kartu profil dengan `Container`, `BoxDecoration`, `CircleAvatar`, dan `Expanded`.
- Model data `Makanan` dan daftar menu dengan `ListView.builder`, `Card`, serta `ListTile`.
- Navigasi ke halaman detail dengan `Navigator.push` dan `Navigator.pop`, data dikirim lewat constructor.
- **Latihan:** 7 menu, properti deskripsi, `Container` pengganti `Card`, dan fungsi `formatRupiah()` buatan sendiri.
- **Tugas:** aplikasi Daftar Kontak (6 kontak, avatar huruf pertama, halaman detail).

| Profil dan Daftar Menu | Detail Menu | Latihan: Daftar | Latihan: Detail |
|:-:|:-:|:-:|:-:|
| <img src="screenshots/pertemuan-2/01-profil-daftar-menu.png" width="180"> | <img src="screenshots/pertemuan-2/02-detail-menu.png" width="180"> | <img src="screenshots/pertemuan-2/03-latihan-daftar-menu.png" width="180"> | <img src="screenshots/pertemuan-2/04-latihan-detail-menu.png" width="180"> |

| Tugas: Daftar Kontak | Tugas: Detail Kontak |
|:-:|:-:|
| <img src="screenshots/pertemuan-2/05-tugas-daftar-kontak.png" width="180"> | <img src="screenshots/pertemuan-2/06-tugas-detail-kontak.png" width="180"> |

---

## Pertemuan 3: Form Input dan State Management

**Tujuan:** mengambil input pengguna, membuat form dengan validasi, memahami keterbatasan `setState`, serta menerapkan `ChangeNotifier` dan `Provider`.

**Yang dikerjakan**

- Input dasar dengan `TextField` dan `TextEditingController` (termasuk `dispose()`).
- Form pendaftaran dengan `Form`, `GlobalKey<FormState>`, `TextFormField`, dropdown, dan checkbox.
- Aplikasi Daftar Tugas dengan `ChangeNotifier`, `ChangeNotifierProvider`, `context.watch`, dan `context.read`.
- **Latihan:** validasi judul minimal 3 karakter, `hapusSelesai()`, SnackBar, dan tampilan daftar kosong.
- **Tugas:** aplikasi Daftar Belanja dengan validasi (nama wajib, jumlah angka lebih dari 0, kategori dropdown) dan state bersama lewat Provider.

| Menu Utama | Input Dasar | Daftar Tugas Kosong | Tambah Tugas | Tugas Selesai |
|:-:|:-:|:-:|:-:|:-:|
| <img src="screenshots/pertemuan-3/01-menu-utama.png" width="150"> | <img src="screenshots/pertemuan-3/02-input-dasar.png" width="150"> | <img src="screenshots/pertemuan-3/03-tugas-kosong.png" width="150"> | <img src="screenshots/pertemuan-3/04-tambah-tugas.png" width="150"> | <img src="screenshots/pertemuan-3/05-tugas-selesai.png" width="150"> |

| Tugas: Belanja Kosong | Tugas: Form Tambah Barang | Tugas: Daftar Belanja |
|:-:|:-:|:-:|
| <img src="screenshots/pertemuan-3/06-belanja-kosong.png" width="180"> | <img src="screenshots/pertemuan-3/07-form-belanja.png" width="180"> | <img src="screenshots/pertemuan-3/08-daftar-belanja.png" width="180"> |

---

## Teknologi

- [Flutter](https://flutter.dev) (SDK stabil) dan bahasa [Dart](https://dart.dev)
- Material Design 3 (`useMaterial3: true`)
- Paket [`provider`](https://pub.dev/packages/provider) (khusus Pertemuan 3)
- Editor: Android Studio atau VS Code dengan ekstensi Flutter dan Dart
- Pengujian di emulator Android (Pixel)

## Cara Menjalankan

1. Pasang Flutter SDK dan pastikan lingkungan siap:

   ```bash
   flutter doctor
   ```

2. Masuk ke folder pertemuan yang ingin dijalankan, lalu unduh dependensi:

   ```bash
   cd praktikum_3
   flutter pub get
   ```

3. Jalankan di emulator atau perangkat yang terhubung:

   ```bash
   flutter run
   ```

> **Catatan:** Pertemuan 3 memakai paket `provider`. Bila paket belum ada, jalankan `flutter pub add provider`. Setelah menambah paket, lakukan *restart* penuh aplikasi (bukan hot reload). Ubahan pada `main()` atau data `const` juga membutuhkan *hot restart*.

## Struktur Repositori

Sesuaikan dengan susunan proyek Anda.

```text
flutter-praktikum/
├── praktikum_1/
│   └── lib/main.dart        # Hello Flutter, counter, Kartu Perkenalan
├── praktikum_2/
│   └── lib/main.dart        # Profil, Daftar Menu, Daftar Kontak
├── praktikum_3/
│   ├── lib/main.dart        # Input, Form, Daftar Tugas, Daftar Belanja
│   └── pubspec.yaml         # dependensi provider
├── screenshots/
│   ├── pertemuan-1/
│   ├── pertemuan-2/
│   └── pertemuan-3/
└── README.md
```

## Konsep yang Dipelajari

| Kategori | Konsep dan Widget |
|---|---|
| **Dasar** | Widget tree, `StatelessWidget`, `StatefulWidget`, `setState()`, hot reload |
| **Layout** | `Scaffold`, `AppBar`, `Center`, `Column`, `Row`, `Container`, `Padding`, `Expanded`, `SizedBox`, `Divider` |
| **Tampilan** | `Text`, `TextStyle`, `Icon`, `CircleAvatar`, `Card`, `ListTile`, `BoxDecoration` |
| **Daftar dan data** | Class model Dart, `ListView.builder`, `const` list |
| **Navigasi** | `Navigator.push`, `Navigator.pop`, `MaterialPageRoute`, kirim data lewat constructor |
| **Form** | `TextField`, `TextEditingController`, `Form`, `TextFormField`, `validator`, `DropdownButtonFormField`, `CheckboxListTile`, `SnackBar` |
| **State management** | `ChangeNotifier`, `notifyListeners()`, `ChangeNotifierProvider`, `context.watch`, `context.read` |

## Referensi

- [Dokumentasi Flutter](https://docs.flutter.dev)
- [Dart Language Tour](https://dart.dev/language)
- [Layout di Flutter](https://docs.flutter.dev/ui/layout)
- [Navigasi](https://docs.flutter.dev/cookbook/navigation)
- [Form dan validasi](https://docs.flutter.dev/cookbook/forms)
- [Pengantar state management](https://docs.flutter.dev/data-and-backend/state-mgmt)
- [Paket provider](https://pub.dev/packages/provider)
