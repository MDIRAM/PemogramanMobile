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
- [Referensi](#referensi)

## Ringkasan Pertemuan

| Pertemuan | Topik | Proyek | Aplikasi Tugas |
|:-:|---|---|---|
| 1 | Pengenalan Flutter, instalasi, widget dasar, `StatefulWidget` | `praktikum_1` | Kartu Perkenalan |
| 2 | Layout, `ListView.builder`, model data, `Navigator` | `praktikum_2` | Daftar Kontak |
| 3 | `TextField`, `Form` dan validasi, `Provider` | `praktikum_3` | Daftar Belanja |

---

## Pertemuan 1: Pengenalan Flutter dan Aplikasi Pertama

**Tujuan:** memasang Flutter SDK, membuat dan menjalankan proyek pertama, memahami struktur proyek dan widget tree, serta memakai hot reload.

**Praktikum**

- Instalasi dan verifikasi lingkungan dengan `flutter doctor`.
- Aplikasi "Hello Flutter" dengan `MaterialApp`, `Scaffold`, `AppBar`, `Center`, dan `Text`.
- Layout vertikal dengan `Column`, `Icon`, dan `SizedBox`.
- Counter interaktif dengan `StatefulWidget` dan `setState()`.

**Latihan mandiri**

- Mengubah warna `AppBar` dan teks.
- Menambah tombol kurang dan tombol reset.
- Mencegah angka counter menjadi negatif.

**Tugas:** aplikasi **Kartu Perkenalan** satu halaman yang menampilkan ikon, nama, NIM, jurusan, dan hobi.

---

## Pertemuan 2: Layout, ListView, dan Navigasi

**Tujuan:** menyusun layout dengan `Container`, `Padding`, `Row`, `Column`, dan `Expanded`; menampilkan daftar data; memodelkan data dengan class Dart; dan berpindah halaman sambil mengirim data.

**Praktikum**

- Kartu profil dengan `Container`, `BoxDecoration`, `CircleAvatar`, dan `Expanded`.
- Model data `Makanan` dan daftar menu dengan `ListView.builder`, `Card`, serta `ListTile`.
- Navigasi ke halaman detail dengan `Navigator.push` dan `Navigator.pop`; data dikirim lewat constructor.

**Latihan mandiri**

- Menambah menu hingga 7 item.
- Menambah properti deskripsi pada model dan menampilkannya di halaman detail.
- Mengganti `Card` dengan `Container` berlatar warna dan sudut membulat.
- Membuat fungsi `formatRupiah()` untuk format ribuan (contoh: `Rp 15.000`).

**Tugas:** aplikasi **Daftar Kontak** dengan 6 kontak (nama, telepon, email), avatar berisi huruf pertama nama, dan halaman detail dengan tombol kembali.

---

## Pertemuan 3: Form Input dan State Management

**Tujuan:** mengambil input pengguna, membuat form dengan validasi, memahami keterbatasan `setState`, serta menerapkan `ChangeNotifier` dan `Provider`.

**Praktikum**

- Input dasar dengan `TextField` dan `TextEditingController`, termasuk `dispose()`.
- Form pendaftaran dengan `Form`, `GlobalKey<FormState>`, `TextFormField`, dropdown, dan checkbox.
- Aplikasi **Daftar Tugas** dengan `ChangeNotifier`, `ChangeNotifierProvider`, `context.watch`, dan `context.read`.

**Latihan mandiri**

- Validasi judul tugas minimal 3 karakter.
- Method `hapusSelesai()` beserta tombol di `AppBar`.
- `SnackBar` "Tugas ditambahkan" setelah tugas disimpan.
- Teks "Belum ada tugas" saat daftar kosong.

**Tugas:** aplikasi **Daftar Belanja** dengan:

- Form tambah barang: nama (wajib), jumlah (wajib, angka lebih dari 0), dan kategori (dropdown), semuanya divalidasi.
- Halaman daftar: barang dapat dicentang sebagai "sudah dibeli" dan dihapus.
- State disimpan pada satu `ChangeNotifier` dan dibagikan dengan Provider; `AppBar` menampilkan jumlah barang yang belum dibeli.

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
