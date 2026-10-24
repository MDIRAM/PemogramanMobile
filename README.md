# Praktikum Pemrograman Mobile

Kumpulan hasil praktikum **Pemrograman Mobile** (Pertemuan 1–7) yang membahas pengembangan aplikasi mobile dari tingkat dasar hingga penerapan proyek terpadu dengan Flutter dan Dart.

| | |
|---|---|
| **Nama** | Muhamad Dika Ramadhan |
| **NIM** | 20240801045 |
| **Program Studi** | Teknik Informatika |
| **Mata Kuliah** | Pemrograman Mobile |

## Daftar Isi

- [Ringkasan Pertemuan](#ringkasan-pertemuan)
- [Pertemuan 1: Pengenalan Flutter dan Aplikasi Pertama](#pertemuan-1-pengenalan-flutter-dan-aplikasi-pertama)
- [Pertemuan 2: Layout, ListView, dan Navigasi](#pertemuan-2-layout-listview-dan-navigasi)
- [Pertemuan 3: Form Input dan State Management](#pertemuan-3-form-input-dan-state-management)
- [Pertemuan 4: REST API, Async, dan FutureBuilder](#pertemuan-4-rest-api-async-dan-futurebuilder)
- [Pertemuan 5: Penyimpanan Lokal (SharedPreferences & SQLite)](#pertemuan-5-penyimpanan-lokal-sharedpreferences--sqlite)
- [Pertemuan 6: Tema, Routing, Navigasi Tab, dan Animasi](#pertemuan-6-tema-routing-navigasi-tab-dan-animasi)
- [Pertemuan 7: Mini Proyek Terpadu (TabungKu)](#pertemuan-7-mini-proyek-terpadu-tabungku)
- [Teknologi](#teknologi)
- [Cara Menjalankan](#cara-menjalankan)
- [Struktur Repositori](#struktur-repositori)
- [Referensi](#referensi)

---

## Ringkasan Pertemuan

| Pertemuan | Topik | Proyek | Aplikasi / Fokus Utama |
|:-:|---|---|---|
| 1 | Pengenalan Flutter, Widget dasar, `StatefulWidget` | `praktikum_1` | Kartu Perkenalan |
| 2 | Layout, `ListView.builder`, Model Data, Navigasi | `praktikum_2` | Daftar Kontak |
| 3 | Input Teks, Validasi Form, Provider | `praktikum_3` | Daftar Belanja |
| 4 | Asinkron, REST API, JSON, `FutureBuilder` | `praktikum_4` | Daftar Postingan & Komentar |
| 5 | Storage Lokal: `SharedPreferences` & `SQLite` | `praktikum_5` | Pencatat Pengeluaran |
| 6 | Theme Material 3, Named Routes, Tab, Animasi | `praktikum_6` | Katalog Interaktif |
| 7 | Mini Proyek Terpadu (Integrasi Modul 1–6) | `TabungKu` | To-Do List + Keuangan Harian |

---

## Pertemuan 1: Pengenalan Flutter dan Aplikasi Pertama

**Tujuan:** Memasang Flutter SDK, verifikasi lingkungan, memahami struktur proyek dan *widget tree*, serta menerapkan interaktivitas dasar.

- **Praktikum:**
    - Verifikasi sistem via `flutter doctor`.
    - Aplikasi "Hello Flutter" (`MaterialApp`, `Scaffold`, `AppBar`, `Center`, `Text`).
    - Layout vertikal dengan `Column`, `Icon`, dan `SizedBox`.
    - Counter interaktif menggunakan `StatefulWidget` dan `setState()`.
- **Tugas:** Aplikasi **Kartu Perkenalan** satu halaman berisi foto/ikon, Nama, NIM, Jurusan, dan Hobi.

---

## Pertemuan 2: Layout, ListView, dan Navigasi

**Tujuan:** Menyusun tata letak responsif, menampilkan daftar data efisien, serta berpindah halaman sambil mengirimkan data.

- **Praktikum:**
    - Kartu profil (`Container`, `BoxDecoration`, `CircleAvatar`, `Expanded`).
    - Model data `Makanan` dan daftar menu via `ListView.builder`, `Card`, dan `ListTile`.
    - Navigasi halaman detail via `Navigator.push` & `Navigator.pop`.
- **Tugas:** Aplikasi **Daftar Kontak** (minimal 6 kontak) dengan avatar huruf pertama, halaman detail, dan tombol kembali.

---

## Pertemuan 3: Form Input dan State Management

**Tujuan:** Pengolahan input pengguna, validasi formulir, serta penerapan state management global dengan `Provider`.

- **Praktikum:**
    - Input teks dengan `TextField` & `TextEditingController` (serta fungsi `dispose()`).
    - Validasi form dengan `Form`, `GlobalKey<FormState>`, `TextFormField`, dropdown, dan checkbox.
    - State Management menggunakan `ChangeNotifierProvider`, `context.watch`, dan `context.read`.
- **Tugas:** Aplikasi **Daftar Belanja** dengan form validasi (nama, jumlah > 0, kategori) dan indikator barang belum dibeli pada `AppBar`.

---

## Pertemuan 4: REST API, Async, dan FutureBuilder

**Tujuan:** Memahami pemrograman asinkron (`Future`, `async`, `await`), melakukan HTTP request, parsing JSON ke Model, dan menangani state UI.

- **Praktikum:**
    - Simulasi masa tunggu asinkron (`Future.delayed`).
    - Integrasi REST API JSONPlaceholder dengan paket `http`.
    - Data model dengan factory `fromJson`.
    - Pengolahan status UI (loading, error, data) menggunakan `FutureBuilder`.
- **Tugas:** Aplikasi **Daftar Postingan** dengan endpoint `/posts` dan `/comments`, lengkap dengan penanganan *error retry*.

---

## Pertemuan 5: Penyimpanan Lokal (SharedPreferences & SQLite)

**Tujuan:** Menyimpan data secara permanen (*persistence*) menggunakan pasangan *key-value* dan database relasional lokal.

- **Praktikum:**
    - Simpan pengaturan ringan (nama, mode gelap, hitungan buka app) via `shared_preferences`.
    - Database `sqflite`: Membuat tabel, model `toMap()`/`fromMap()`, dan query parametrik.
    - Operasi CRUD lengkap (Create, Read, Update, Delete).
- **Tugas:** Aplikasi **Pencatat Pengeluaran** berbasis SQLite dengan kalkulasi total pengeluaran dan simpan filter terakhir.

---

## Pertemuan 6: Tema, Routing, Navigasi Tab, dan Animasi

**Tujuan:** Kustomisasi tema terpusat, pengorganisasian rute aplikasi, navigasi tab bawah, dan penerapan berbagai animasi UI.

- **Praktikum:**
    - Dynamic Theme (Material 3) dengan `ThemeData`, `ColorScheme.fromSeed`, dan `ThemeMode`.
    - *Named Routes* (`routes`, `onGenerateRoute`, parameter argument).
    - Structuring halaman dengan `NavigationBar` & `IndexedStack`.
    - Implementasi Animasi Implisit (`AnimatedContainer`), Transisi `Hero`, dan Animasi Eksplisit (`AnimationController`).
- **Tugas:** Aplikasi **Katalog Interaktif** dengan 3 tab, transisi `Hero`, animasi interaktif, dan pengaturan warna tema tersimpan.

---

## Pertemuan 7: Mini Proyek Terpadu (TabungKu)

**Tujuan:** Mengintegrasikan seluruh materi Pertemuan 1–6 dalam satu aplikasi utuh berorientasi kebutuhan nyata.

- **Deskripsi:** Aplikasi To-Do List terintegrasi pencatatan keuangan dan target tabungan harian.
- **Fitur Utama:**
    - **Daftar & Form Kegiatan:** Input nama, tanggal (*DatePicker*), jenis (Tanpa Uang / Pemasukan / Pengeluaran), nominal, dan kategori.
    - **Penyimpanan SQLite:** Seluruh transaksi dan daftar kegiatan tersimpan di database lokal.
    - **Laporan & Agregasi SQL:** Perhitungan ringkasan (`SUM`, `CASE WHEN`, `COALESCE`) untuk pemasukan, pengeluaran, dan saldo harian.
    - **Target Tabungan & Animasi:** Progress bar target tabungan harian beranimasi.
    - **Theme & Shell Navigation:** 3 Tab Navigasi (`NavigationBar`), *Named Routes*, dan Sinkronisasi State (*Observer Pattern*).

---

## Teknologi

- **Framework:** [Flutter](https://flutter.dev) (SDK Stable)
- **Bahasa Pemrograman:** [Dart](https://dart.dev)
- **Penyimpanan & State:** `provider`, `shared_preferences`, `sqflite`, `path`
- **Jaringan:** `http`
- **OS Environment:** Linux Mint
- **Editor:** Android Studio / VS Code

---

## Cara Menjalankan

1. **Verifikasi lingkungan Flutter:**
   ```bash
   flutter doctor