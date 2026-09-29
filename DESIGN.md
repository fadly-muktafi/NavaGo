# NavaGo — Design System & UI Specification

> **Fleet & Driver Management** — *Mobile Operations for Fleet & Driver Control*
> Dokumen ini disusun dari mockup UI NavaGo (8 layar). Nilai warna, ukuran, dan spacing adalah **estimasi dari visual** dan sebaiknya dicocokkan ulang dengan file desain sumber (Figma) sebelum dijadikan token final.

---

## 1. Ringkasan Produk

| Item | Deskripsi |
|---|---|
| Nama | NavaGo |
| Platform | Mobile app (iOS/Android), portrait |
| Pengguna utama | Supervisor / Admin operasional armada |
| Tujuan | Memantau armada, mengelola driver, menugaskan trip, menjadwalkan maintenance, dan memonitor status secara live |
| Bahasa UI | Bahasa Indonesia |
| Nilai jual | Armada lebih produktif · Driver lebih terkelola · Operasional lebih efisien |

### Daftar Layar

1. Dashboard Operasional
2. Daftar Armada
3. Detail Armada
4. Jadwal Maintenance
5. Manajemen Driver
6. Detail Driver
7. Penugasan Driver & Kendaraan
8. Monitoring Status

---

## 2. Prinsip Desain

1. **Glanceable** — supervisor harus paham kondisi operasional dalam beberapa detik (angka besar, status berwarna).
2. **Status-first** — warna dipakai terutama untuk menyampaikan status (tersedia, on trip, maintenance, peringatan), bukan dekorasi.
3. **Bersih & ringan** — latar putih/mint sangat muda, kartu dengan sudut membulat, bayangan halus.
4. **Aksi jelas** — satu tombol utama (hijau solid) dan satu tombol sekunder (outline hijau) per konteks.
5. **Konsisten** — pola list-item, chip filter, badge status, dan bottom navigation dipakai ulang di semua layar.

---

## 3. Brand

### Logo
- Ikon aplikasi: kotak rounded dengan gradient teal → hijau, berisi simbol **"N"** dengan motif jalan/navigasi.
- Wordmark: **NavaGo** — "Nava" warna navy gelap, "Go" warna gradient hijau/teal.
- Di header layar: ikon kecil (±20px) + wordmark "NavaGo" bold.

### Tagline
- *Fleet & Driver Management*
- *Mobile Operations for Fleet & Driver Control*

---

## 4. Design Tokens

### 4.1 Warna

#### Brand / Primary
| Token | Hex (estimasi) | Penggunaan |
|---|---|---|
| `primary-600` | `#0B8F76` | Tombol utama, tab aktif, ikon aktif bottom nav, chip aktif |
| `primary-500` | `#12A98A` | Gradient logo, aksen, link "Lihat Semua" |
| `primary-100` | `#DDF4EC` | Background ikon kartu, badge "Tersedia" |
| `primary-50` | `#EEFAF6` | Background halaman/gradient dekoratif |
| `navy-900` | `#12324A` | Wordmark "Nava", teks judul penting |

#### Netral
| Token | Hex (estimasi) | Penggunaan |
|---|---|---|
| `neutral-900` | `#1B2430` | Teks judul, nama plat, angka besar |
| `neutral-600` | `#5C6675` | Teks sekunder (tipe kendaraan, lokasi) |
| `neutral-400` | `#9AA3AF` | Placeholder, label tab non-aktif, ikon non-aktif |
| `neutral-200` | `#E5E9EE` | Border kartu, divider |
| `neutral-100` | `#F3F5F8` | Background chip non-aktif, search field |
| `white` | `#FFFFFF` | Surface kartu, bottom nav, app bar |

#### Semantik / Status
| Status | Teks / Ikon | Background | Dipakai untuk |
|---|---|---|---|
| Tersedia / Aktif / Live | `#0B8F76` | `#DDF4EC` | Armada tersedia, driver aktif, indikator Live |
| On Trip / Dalam Perjalanan / Info | `#2F80ED` | `#E3EEFD` | Armada sedang trip, driver dalam perjalanan |
| Maintenance / Kritis | `#E5484D` | `#FDE7E8` | Armada maintenance, "3 hari lagi", alert kritis |
| Peringatan (Warning) | `#F2A11B` | `#FFF1D6` | "8 hari lagi", dokumen hampir habis |
| Off Duty / Nonaktif | `#6B7280` | `#EDEFF2` | Driver off duty |

#### Warna Kartu KPI (Dashboard)
| Kartu | Ikon | Background ikon |
|---|---|---|
| Total Armada | Hijau | Mint |
| Armada Tersedia | Hijau | Mint |
| On Trip | Oranye | Peach/kuning muda |
| Maintenance | Merah | Pink muda |
| Driver Aktif | Hijau/teal | Mint |
| Dok. Jatuh Tempo | Merah | Pink muda |

#### Banner Status Operasional
- Gradient horizontal `primary-100` → `primary-50`, dengan ilustrasi grafik naik (hijau) di kanan.

### 4.2 Tipografi

Font: **sans-serif geometris modern** (rekomendasi: *Plus Jakarta Sans*, *Poppins*, atau *Inter*). Konfirmasi font asli dari file desain.

| Token | Ukuran / Weight | Contoh penggunaan |
|---|---|---|
| `display` | 24–28 / Bold | Angka KPI besar (48, 28, 15) |
| `title-lg` | 18–20 / Bold | Judul layar ("Daftar Armada", "Jadwal Maintenance") |
| `title-md` | 16 / Semibold | Plat nomor (B 1234 KLM), nama driver |
| `body` | 14 / Regular | Deskripsi, informasi trip |
| `body-strong` | 14 / Semibold | Nilai pada info (Rp 1.200.000 / hari) |
| `caption` | 12 / Regular | Tipe kendaraan, lokasi, label KPI, tanggal |
| `label` | 11 / Medium | Label bottom navigation, badge |

Aturan: sentence case, tanpa ALL CAPS pada UI (kecuali plat nomor dan singkatan seperti KIR, STNK, SIM).

### 4.3 Spacing

Skala basis **4px**: `4 · 8 · 12 · 16 · 20 · 24 · 32`

- Padding horizontal layar: `16px`
- Jarak antar kartu / list item: `12px`
- Padding dalam kartu: `12–16px`
- Jarak antar section: `20–24px`

### 4.4 Radius

| Token | Nilai | Penggunaan |
|---|---|---|
| `radius-sm` | 8px | Badge/tag status, input kecil |
| `radius-md` | 12px | Kartu, search field, tombol |
| `radius-lg` | 16px | Kartu besar, banner, gambar detail armada |
| `radius-full` | 999px | Chip filter, avatar, badge pill |

### 4.5 Elevasi

- Kartu: shadow lembut `0 2px 8px rgba(18, 50, 74, 0.06)` + border tipis `neutral-200`.
- Bottom nav: shadow ke atas `0 -2px 12px rgba(0,0,0,0.06)`.
- Tidak memakai shadow tebal atau gelap.

### 4.6 Ikon

- Gaya: **outline rounded**, stroke ±1.5–2px, sudut membulat.
- Ikon kartu KPI dan Menu Cepat ditempatkan di dalam **kotak rounded berwarna pastel** (±40–48px).
- Ikon bottom nav: 24px; aktif = `primary-600` (filled/tinted), non-aktif = `neutral-400`.

---

## 5. Komponen

### 5.1 App Bar
- Layar utama (tab): logo NavaGo di kiri, ikon **lonceng notifikasi** di kanan.
- Layar detail: tombol **kembali (‹)** di kiri, logo di sebelahnya, ikon **⋮ (more)** atau **☰** di kanan.
- Tinggi ±56px, background putih, tanpa border bawah yang tebal.

### 5.2 Bottom Navigation
5 tab tetap: **Beranda · Armada · Driver · Notifikasi · Lainnya**
- Aktif: ikon + label `primary-600`.
- Non-aktif: `neutral-400`.
- Layar detail (Detail Armada, Detail Driver, Penugasan) tetap menampilkan tab induk sebagai aktif (Armada / Driver).

### 5.3 Search Field
- Background `neutral-100`, radius 12px, ikon kaca pembesar di kiri.
- Placeholder contoh: *"Cari plat nomor, tipe, atau lokasi..."*, *"Cari nama, no. HP, atau kendaraan..."*.

### 5.4 Chip Filter / Segmented Tabs
- Bentuk pill, tinggi ±32px.
- Aktif: background `primary-600`, teks putih.
- Non-aktif: background `neutral-100`, teks `neutral-600`.
- Dipakai pada: Daftar Armada (Semua, Tersedia, On Trip, Maintenance), Manajemen Driver (Semua, Aktif, Dalam Perjalanan, Off Duty), Jadwal Maintenance (Semua, Service, Dokumen, Lainnya), Monitoring (Peta, Armada, Driver, Peringatan).
- Tab detail driver (Informasi, Dokumen, Riwayat Trip) memakai bentuk segmented dalam satu kontainer.

### 5.5 KPI Card (Dashboard)
- Grid **2 kolom × 3 baris**.
- Isi: ikon pastel (kiri), label kecil di atas, angka besar di bawah.
- Warna angka mengikuti semantik (Maintenance & Dok. Jatuh Tempo = merah).

### 5.6 Menu Cepat
- 4 tile: **Armada, Driver, Penugasan, Maintenance**.
- Tile persegi rounded dengan ikon pastel (hijau, biru, biru muda, merah muda) dan label di bawah.

### 5.7 Vehicle List Item
- Thumbnail kendaraan (kiri, ±64×48px, radius 8px).
- Baris 1: **plat nomor** (bold) + badge status di kanan.
- Baris 2: tipe kendaraan (Toyota Hiace) + kapasitas (12 Kursi / 8 Ton).
- Baris 3: ikon pin + lokasi (Jakarta Pusat, Surabaya, Bekasi, Depok, Tangerang).
- Chevron (›) di kanan sebagai penanda dapat dibuka.

### 5.8 Driver List Item
- Avatar bulat (kiri, ±48px).
- Nama (bold) + ikon bintang kuning + rating (4.8).
- No. HP, lalu plat kendaraan + tipe.
- Badge status di kanan: Aktif (hijau), Dalam Perjalanan (biru), Off Duty (abu).

### 5.9 Status Badge
- Bentuk pill / radius-sm, tinggi ±22px, teks 11–12px medium.
- Kombinasi warna teks + background sesuai tabel semantik (bagian 4.1).
- Badge hitung mundur pada maintenance: `3 hari lagi` (merah), `8 hari lagi` (kuning/oranye), `16 hari lagi` & `27 hari lagi` & `32 hari lagi` (biru muda/hijau muda).

### 5.10 Tombol
| Varian | Gaya | Contoh |
|---|---|---|
| Primary | Background `primary-600`, teks putih, radius 12px, tinggi 44–48px | "Jadwalkan Maintenance", "Ubah Data", "Konfirmasi Penugasan →" |
| Secondary | Outline `primary-600` 1.5px, teks `primary-600`, background putih | "Ubah Data" (detail armada), "Hubungi" (dengan ikon telepon) |
| Small / Inline | Outline kecil, tinggi ±28px | "Ganti" pada pilihan driver/kendaraan |
| Text link | Teks `primary-600`, tanpa border | "Lihat Semua" |

Pasangan tombol ditampilkan berdampingan dengan lebar sama (50:50).

### 5.11 Info Tile (Detail Armada)
- Grid 2×2 dalam satu kartu: Lokasi Saat Ini, Tarif Sewa, Kilometer, Tahun.
- Ikon di kiri, label kecil abu, nilai bold.

### 5.12 Spec Chips (Detail Armada)
- Chip kecil berikon: `12 Kursi`, `Diesel`, `AT`. Background `neutral-100`, radius-full.

### 5.13 Stepper (Penugasan)
- 4 langkah horizontal: **Detail Trip → Pilih Driver → Pilih Armada → Konfirmasi**.
- Langkah aktif: lingkaran `primary-600` dengan angka putih; langkah berikutnya: lingkaran abu.
- Label kecil di bawah tiap lingkaran, dihubungkan garis tipis.

### 5.14 Maintenance Timeline Item
- Ikon kotak pastel di kiri (oli = merah, service = kuning, KIR = biru, STNK = biru, asuransi = biru).
- Judul (bold) + subjudul: `plat • tipe kendaraan`.
- Kanan: tanggal + badge sisa hari.

### 5.15 Kalender Mingguan
- Header bulan (`Mei 2024`) dengan panah kiri/kanan.
- Baris hari (Min–Sab) + baris tanggal; tanggal terpilih = lingkaran `primary-600` teks putih.

### 5.16 Peta & Monitoring
- Peta ringkas dengan rute (garis biru), marker armada (bulatan hijau dengan ikon kendaraan), marker tujuan (pin merah).
- Popup marker: plat nomor, kecepatan (70 km/jam), arah ("Menuju Bandung").
- Indikator **Live** di kanan atas (titik hijau + teks).
- Di bawah peta: 2 kartu ringkasan (Armada Aktif 15 dari 48, Driver Aktif 42 dari 50).

### 5.17 Alert Card (Peringatan Penting)
- Daftar 3 item, masing-masing dengan ikon berwarna dalam kotak rounded:
  - Merah — armada perlu maintenance
  - Kuning — dokumen hampir habis
  - Biru — driver tidak tersedia
- Judul bold + deskripsi satu baris abu. Link "Lihat Semua" di header section.

### 5.19 Profile Header (Detail Driver)
- Foto besar rounded di kiri, badge status di atas nama, nama bold, rating bintang + jumlah ulasan (`4.8 (128 ulasan)`).
- Baris kontak: No. HP dan Email dalam 2 kolom dengan ikon.
- Data terstruktur berikutnya: SIM, Berlaku hingga, Kendaraan Ditugaskan, Total Trip, Rating.

---

## 6. Pola Layar

### 6.1 Dashboard Operasional
```
[Logo]                          [🔔]
Halo, Supervisor       Selasa, 14 Mei 2024
┌─ Banner: Operasional Hari Ini ──────┐
│  Berjalan dengan Baik!        📈    │
└─────────────────────────────────────┘
[Total Armada 48]   [Armada Tersedia 28]
[On Trip 15]        [Maintenance 5]
[Driver Aktif 42]   [Dok. Jatuh Tempo 7]
Menu Cepat
[Armada][Driver][Penugasan][Maintenance]
────────── Bottom Nav ──────────────────
```

### 6.2 Daftar Armada
- Judul + jumlah total di kanan ("48 Armada") → Search → Chip filter → List kendaraan.

### 6.3 Detail Armada
- Foto hero besar (indikator `1/5`) → Plat + badge status → Tipe → Spec chips → Info tile 2×2 → Deskripsi → Tombol [Ubah Data] [Jadwalkan Maintenance].

### 6.4 Jadwal Maintenance
- Chip kategori → Kalender mingguan → List jadwal berurutan dengan badge sisa hari.

### 6.5 Manajemen Driver
- Judul + jumlah total ("42 Driver") → Search → Chip filter → List driver.

### 6.6 Detail Driver
- Profile header → Tab (Informasi | Dokumen | Riwayat Trip) → Data → Tombol [Hubungi] [Ubah Data].

### 6.7 Penugasan Driver & Kendaraan
- Stepper → Informasi Trip (ID trip, rute, tanggal, waktu, jumlah penumpang, badge tipe "Reguler") → Pilih Driver (+Ganti) → Pilih Kendaraan (+Ganti) → Tombol utama penuh lebar **Konfirmasi Penugasan →**.

### 6.8 Monitoring Status
- Chip tab → Peta live → Ringkasan Armada/Driver aktif → Peringatan Penting.

---

## 7. Konten & Bahasa (UX Writing)

- Bahasa Indonesia, sentence case, singkat dan langsung.
- Label aksi memakai kata kerja: *Ubah Data, Jadwalkan Maintenance, Konfirmasi Penugasan, Hubungi, Ganti, Lihat Semua*.
- Istilah status konsisten di seluruh layar: **Tersedia · On Trip · Maintenance · Aktif · Dalam Perjalanan · Off Duty**.
- Format:
  - Tanggal: `14 Mei 2024`, `15 Mei 2024`; header dashboard memakai hari (`Selasa, 14 Mei 2024`).
  - Mata uang: `Rp 1.200.000 / hari` (titik sebagai pemisah ribuan).
  - Jarak: `125.430 km`; kecepatan: `70 km/jam`.
  - Plat nomor: huruf kapital (`B 1234 KLM`).
  - Sisa waktu: `3 hari lagi`.
  - Rating: `4.8 (128 ulasan)`.

---

## 8. Interaksi & State

| State | Perilaku |
|---|---|
| Pressed | Kartu/list item sedikit menggelap (overlay 4–6%), tombol primary → `primary-700` |
| Focus | Outline 2px `primary-500` (aksesibilitas keyboard/switch) |
| Disabled | Opacity 40%, tanpa shadow |
| Loading | Skeleton abu pada kartu KPI dan list; spinner kecil pada tombol |
| Empty | Ilustrasi sederhana + teks arahan + tombol aksi (mis. "Belum ada armada. Tambah armada") |
| Error | Pesan jelas + cara memperbaiki; warna `danger` hanya untuk ikon/teks pendek |
| Live | Titik hijau berdenyut halus pada label "Live" (satu-satunya animasi otomatis) |

Transisi: perpindahan layar standar platform; expand/collapse 200–250ms ease-out. Hormati pengaturan *reduce motion*.

---

## 9. Aksesibilitas

- Kontras teks minimal **4.5:1**; periksa khusus teks hijau di atas mint (`primary-600` di `primary-100`) dan teks kuning di atas kuning muda.
- Status **tidak hanya dengan warna** — selalu sertakan teks badge ("Maintenance", "Tersedia") dan ikon.
- Target sentuh minimal **44×44px** (chip, tombol "Ganti", ikon bottom nav).
- Ukuran teks mengikuti pengaturan font sistem (Dynamic Type / font scale) — layout tidak boleh terpotong pada skala 130%.
- Tambahkan label aksesibilitas pada ikon tanpa teks (lonceng, ⋮, kembali, marker peta).

---

## 10. Responsivitas

- Target utama: layar ponsel 360–430px lebar (portrait).
- Grid KPI tetap 2 kolom; Menu Cepat tetap 4 kolom pada ≥360px, turun ke 2×2 jika lebih sempit.
- Tablet (opsional fase lanjut): master–detail (daftar di kiri, detail di kanan).
- Safe area (notch, home indicator) dihormati pada app bar dan bottom nav.

---

## 11. Panduan Implementasi

Contoh token (CSS variables / dapat dipetakan ke Flutter `ThemeData`, Compose, atau Tailwind):

```css
:root {
  /* Brand */
  --color-primary-600: #0B8F76;
  --color-primary-500: #12A98A;
  --color-primary-100: #DDF4EC;
  --color-primary-50:  #EEFAF6;
  --color-navy-900:    #12324A;

  /* Neutral */
  --color-neutral-900: #1B2430;
  --color-neutral-600: #5C6675;
  --color-neutral-400: #9AA3AF;
  --color-neutral-200: #E5E9EE;
  --color-neutral-100: #F3F5F8;

  /* Status */
  --color-success: #0B8F76;  --color-success-bg: #DDF4EC;
  --color-info:    #2F80ED;  --color-info-bg:    #E3EEFD;
  --color-danger:  #E5484D;  --color-danger-bg:  #FDE7E8;
  --color-warning: #F2A11B;  --color-warning-bg: #FFF1D6;
  --color-muted:   #6B7280;  --color-muted-bg:   #EDEFF2;

  /* Shape & spacing */
  --radius-sm: 8px;  --radius-md: 12px;  --radius-lg: 16px;  --radius-full: 999px;
  --space-1: 4px; --space-2: 8px; --space-3: 12px; --space-4: 16px; --space-5: 20px; --space-6: 24px;

  /* Elevation */
  --shadow-card: 0 2px 8px rgba(18, 50, 74, 0.06);
}
```

### Struktur komponen yang disarankan
```
components/
├─ AppBar
├─ BottomNav
├─ SearchField
├─ FilterChips
├─ KpiCard
├─ QuickMenuTile
├─ VehicleListItem
├─ DriverListItem
├─ StatusBadge
├─ Button (primary / secondary / small / text)
├─ InfoTile
├─ Stepper
├─ WeekCalendar
├─ MaintenanceItem
├─ MapPreview
└─ AlertItem
```

---

## 12. Catatan & Hal yang Perlu Dikonfirmasi

- Hex, ukuran font, dan spacing di dokumen ini **estimasi visual** — ambil nilai pasti dari Figma.
- Font asli belum teridentifikasi; sesuaikan bagian 4.2.
- Belum ada mockup untuk: state kosong, error, loading, mode gelap, layar "Notifikasi" dan "Lainnya", serta form Ubah Data / Tambah Armada / Tambah Driver.
- Beberapa data pada mockup bersifat contoh (mis. nama driver, plat nomor, tanggal Mei 2024).
