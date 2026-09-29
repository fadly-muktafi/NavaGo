# PRD — NavaGo Driver App

| | |
|---|---|
| **Produk** | NavaGo — Fleet & Driver Management |
| **Modul** | Aplikasi mobile role **Driver** |
| **Versi dokumen** | Draft 0.9 |
| **Tanggal** | 29 September 2026 |
| **Platform** | Android + iOS |
| **Model** | Internal satu perusahaan |
| **Status** | Draft — menunggu konfirmasi pada Bagian 8 |

> Item bertanda **TBD** belum diputuskan. Item bertanda **[Usulan]** adalah interpretasi saya dari mockup dan perlu dikonfirmasi.

---

## 1. Executive Summary

**Problem Statement**
Koordinasi antara perusahaan dan driver (penugasan trip, informasi armada, jadwal maintenance, pemantauan operasional) membutuhkan satu aplikasi terpadu agar informasi tidak tersebar dan mudah dilacak.

**Proposed Solution**
Aplikasi mobile NavaGo untuk Driver yang terhubung dengan data operasional seluruh role: dashboard operasional, daftar dan detail armada (read-only), jadwal maintenance dengan pengajuan (perlu persetujuan admin), profil driver, konfirmasi penugasan, dan monitoring status.

**Success Criteria** *(usulan angka — perlu konfirmasi)*

| # | KPI | Usulan target | Cara ukur |
|---|---|---|---|
| 1 | Penugasan dikonfirmasi driver dalam batas waktu | ≥ 90% dalam 5 menit | Timestamp penugasan vs konfirmasi |
| 2 | Pengajuan maintenance dibuat lewat aplikasi | ≥ 80% dari maintenance non-rutin | Log pengajuan |
| 3 | Driver aktif mingguan / driver terdaftar | ≥ 80% dalam 3 bulan | Analitik |
| 4 | Crash-free sessions | ≥ 99% | Crash reporting |
| 5 | Layar utama termuat | ≤ 2 detik (4G) | Monitoring performa |

---

## 2. User Experience & Functionality

### 2.1 Persona

**Driver** — pengemudi armada internal perusahaan (Toyota Hiace, Isuzu Elf, Hino Dutro, Mitsubishi Fuso, dll.). Memakai ponsel sambil bekerja dan bergerak; butuh layar sederhana dan tombol besar.

Aktor lain (di luar scope): **Admin** (membuat penugasan, menyetujui pengajuan maintenance) dan **Customer**.

### 2.2 Inventaris Layar (7 layar valid)

| # | Layar | Peran di aplikasi Driver | Penyesuaian dari mockup |
|---|---|---|---|
| 1 | Dashboard Operasional | Home: ringkasan operasional (data terhubung ke seluruh role) | Sapaan "Halo, Supervisor" → nama driver; **Menu Cepat dihapus** |
| 2 | Armada | Daftar **seluruh armada** (read-only) | Sesuai mockup |
| 3 | Detail Armada | Informasi armada (read-only) + **section Maintenance** (jadwal & pengajuan) per kendaraan | **Ubah Data dihapus**; Tarif Sewa **tampil**; "Jadwalkan Maintenance" → pengajuan; ditambah section Maintenance |
| 4 | Maintenance | **Section di dalam Detail Armada** (bukan tab/layar tersendiri): jadwal maintenance & pengajuan per kendaraan | Digabung ke Detail Armada |
| 5 | Detail Driver → **Profile** | Profil driver sendiri: Informasi, Dokumen, Riwayat Trip, rating | Hanya tombol **Ubah Data**; **Hubungi dihapus** |
| 6 | Penugasan | Detail trip + **Konfirmasi Penugasan** (= menerima trip) | Langkah **Pilih Driver** dan **Pilih Kendaraan dihapus**; **tanpa opsi tolak** |
| 7 | Monitoring | Peta **perjalanan driver sendiri** + ringkasan operasional global | Kartu global tetap dipakai; peta hanya untuk trip driver |

**Tidak dipakai:** layar **Driver** (Manajemen Driver), serta tab **Notifikasi** dan **Lainnya** pada bottom navigation.

**Bottom navigation (5 tab):** Beranda · Armada · Penugasan · Monitoring · Profile.

Layar **Maintenance** tidak lagi menjadi tab/layar tersendiri; menjadi **section di dalam Detail Armada** (per kendaraan). **Notifikasi** diakses lewat **ikon lonceng di app bar**.

**Ditunda (tidak masuk MVP, belum ada layar):** checklist kendaraan sebelum jalan, update status trip (mulai/selesai), lapor masalah/kerusakan.

### 2.3 Alur Pengguna Utama

```
Login → Dashboard Operasional
   │
   ├─ Notifikasi penugasan baru → Penugasan (Detail Trip) → Konfirmasi Penugasan
   │
   ├─ Armada → Detail Armada → Ajukan Maintenance → (menunggu persetujuan admin)
   │     └─ Section Maintenance (jadwal & pengajuan per kendaraan, di dalam Detail Armada)
   ├─ Monitoring (peta & ringkasan)
   └─ Profile → Informasi / Dokumen / Riwayat Trip → Ubah Data
```

### 2.4 User Stories & Acceptance Criteria

**US-01 — Dashboard Operasional**
*Sebagai driver, saya ingin melihat ringkasan operasional agar tahu kondisi armada dan tugas terkini.*
- Menampilkan sapaan dengan nama driver dan tanggal.
- Menampilkan banner status operasional.
- Menampilkan kartu ringkasan operasional seperti pada mockup: Total Armada, Armada Tersedia, On Trip, Maintenance, Driver Aktif, Dok. Jatuh Tempo — data berasal dari sistem yang sama dengan role lain.
- Tidak ada Menu Cepat (dihapus); navigasi lewat bottom navigation.
- Termuat ≤ 2 detik pada 4G.

**US-02 — Daftar Armada**
*Sebagai driver, saya ingin melihat daftar armada.*
- Tiap item: foto, plat nomor, tipe, kapasitas, lokasi, badge status (Tersedia / On Trip / Maintenance).
- Pencarian (plat, tipe, lokasi) dan chip filter (Semua, Tersedia, On Trip, Maintenance).
- Read-only. Menampilkan **seluruh armada** (sama seperti Dashboard).

**US-03 — Detail Armada**
*Sebagai driver, saya ingin melihat detail armada dan mengajukan maintenance bila perlu.*
- Menampilkan foto (galeri), plat, tipe, spesifikasi (kursi, bahan bakar, transmisi), lokasi saat ini, **tarif sewa**, kilometer, tahun, dan deskripsi.
- Seluruh data read-only; tombol "Ubah Data" tidak ada.
- Berisi **section Maintenance** (jadwal maintenance kendaraan tersebut, lihat US-04) dengan tombol **Ajukan Maintenance** yang membuka form pengajuan.

**US-04 — Maintenance & Pengajuan (section di Detail Armada)**
*Sebagai driver, saya ingin melihat jadwal maintenance dan mengajukan maintenance.*
- Berupa **section di dalam Detail Armada**, menampilkan jadwal untuk kendaraan yang sedang dibuka.
- Daftar jadwal maintenance kendaraan (mis. ganti oli, service berkala, KIR, perpanjangan STNK, asuransi) dengan badge sisa hari. **Tanpa kalender mingguan.**
- Filter kategori: Semua, Service, Dokumen, Lainnya.
- Pengajuan dibuat dari Detail Armada kendaraan yang dibuka; apakah boleh untuk armada mana pun atau hanya kendaraan yang ditugaskan **TBD**.
- Form pengajuan: armada, jenis maintenance, tanggal yang diinginkan, catatan, foto opsional.
- Status pengajuan **[Usulan]**: Menunggu Persetujuan → Disetujui / Ditolak → Selesai.
- **Pengajuan wajib disetujui admin** sebelum masuk jadwal; driver mendapat notifikasi atas keputusan admin.
- Driver tidak dapat mengubah/menghapus jadwal yang sudah ada.

**US-05 — Profile (Detail Driver)**
*Sebagai driver, saya ingin melihat dan memperbarui profil saya, serta melihat riwayat trip dan rating.*
- Tab **Informasi**: nama, no. HP, email, jenis SIM, masa berlaku SIM, kendaraan ditugaskan, total trip, rating (mis. 4.8 dari 128 ulasan).
- Tab **Dokumen**: dokumen driver dan masa berlakunya (rincian **TBD**).
- Tab **Riwayat Trip**: daftar trip selesai (tanggal, rute, kendaraan, status), filter rentang tanggal.
- Tombol **Ubah Data** tersedia; tombol "Hubungi" tidak dipakai.
- Semua field yang dapat diubah **langsung tersimpan** tanpa persetujuan admin.
- Field hasil sistem (**rating, total trip, kendaraan ditugaskan**) tetap read-only; field lain bebas diubah.

**US-06 — Penugasan (Konfirmasi Trip)**
*Sebagai driver, saya ingin melihat detail penugasan dan mengonfirmasinya.*
- Driver menerima push notification saat ada penugasan baru.
- Layar menampilkan: ID trip, rute (asal → tujuan), tanggal, waktu, jumlah penumpang, tipe trip (mis. Reguler), driver dan kendaraan yang ditugaskan (informasi saja, bukan pilihan).
- Stepper: **Detail Trip → Konfirmasi** (jumlah langkah final **TBD**).
- **Konfirmasi Penugasan** = menerima trip; tercatat dengan timestamp.
- Tidak ada opsi menolak. Batas waktu konfirmasi dan penanganan driver yang berhalangan **TBD**.

**US-07 — Monitoring Status**
*Sebagai driver, saya ingin memantau status operasional.*
- Tab: Peta, Armada, Driver, Peringatan (sesuai mockup).
- Peta menampilkan **perjalanan driver sendiri**: rute, marker kendaraan (plat, kecepatan, arah), marker tujuan, dan indikator **Live**.
- Ringkasan global: Armada Aktif (15 dari 48) dan Driver Aktif (42 dari 50).
- Peringatan Penting: armada perlu maintenance, dokumen hampir habis, driver tidak tersedia.
- Isi tab "Armada" dan "Driver" pada Monitoring **TBD**.
- Lokasi berasal dari **ponsel driver** dan dikirim **mulai 30 menit sebelum waktu mulai trip sampai waktu trip berakhir** (mengikuti jadwal trip).

**US-08 — Notifikasi & Akun** *(pendukung — perlu konfirmasi)*
- Notifikasi: penugasan baru, keputusan pengajuan maintenance, pengingat jadwal/dokumen jatuh tempo. Tab Notifikasi dihapus; akses melalui **ikon lonceng di app bar**.
- Login dengan **username + password**, logout, dan pengelolaan sesi. Pembuatan akun, kebijakan password, dan reset password **TBD**.

### 2.5 Non-Goals

- Aplikasi/role **Admin** dan **Customer**.
- Layar **Manajemen Driver**, tab **Notifikasi** dan **Lainnya** pada bottom navigation, **Menu Cepat** pada Dashboard, serta Maintenance sebagai tab/layar tersendiri.
- Mengubah data armada.
- Memilih driver/kendaraan untuk penugasan.
- Menolak penugasan di dalam aplikasi.
- **Ditunda:** checklist kendaraan, update status trip, lapor masalah/kerusakan.
- Multi-tenant/SaaS, penggajian, absensi/shift, pembayaran.

### 2.6 Kebutuhan Non-Fungsional

| Area | Kebutuhan |
|---|---|
| Performa | Layar utama ≤ 2 detik (4G); konfirmasi penugasan terkonfirmasi ≤ 3 detik |
| Offline | Aksi tulis (konfirmasi, pengajuan, ubah profil) diantrekan dan tersinkron otomatis; tampilan terakhir tersimpan (cache) |
| Kompatibilitas | Android + iOS; versi OS minimum **TBD** |
| Aksesibilitas | Target sentuh ≥ 44×44 px; kontras ≥ 4.5:1; status tidak hanya dengan warna |
| Lokalisasi | Bahasa Indonesia (konfirmasi **TBD**) |
| UI | Mengikuti `DESIGN.md` |

---

## 3. AI System Requirements

**Tidak berlaku.** Tidak ada komponen AI pada scope ini.

---

## 4. Technical Specifications

### 4.1 Arsitektur (Gambaran Umum)

```
┌────────────────────┐   HTTPS/REST (+ realtime TBD)   ┌──────────────────┐
│  NavaGo Driver App │ ───────────────────────────────►│   Backend API    │
│  (Android + iOS)   │ ◄─────────────────────────────── │  (stack TBD)     │
└─────────┬──────────┘   Push notification             └────────┬─────────┘
          │                                                     │
  Peta & lokasi (TBD)                          Database bersama seluruh role (TBD)
```

Data operasional dibagi dengan role Admin dan Customer melalui backend yang sama.

### 4.2 Aturan Akses

| Data | Driver |
|---|---|
| Ringkasan operasional (Dashboard, Monitoring) | Baca |
| Armada & detail armada (termasuk tarif sewa) | Baca (tidak dapat ubah) |
| Jadwal maintenance | Baca |
| Pengajuan maintenance | Buat & lihat status; persetujuan oleh Admin |
| Penugasan | Baca milik sendiri; konfirmasi (terima) |
| Profil & riwayat trip sendiri | Baca; ubah data (langsung tersimpan) |

Aturan wajib ditegakkan di **backend**, bukan hanya di UI.

### 4.3 Entitas Data (konseptual)

`Driver` · `Vehicle` · `Trip` · `TripAssignment` · `MaintenanceSchedule` · `MaintenanceRequest` (status persetujuan) · `LocationPoint` · `Rating` · `Notification` · `DriverDocument`

### 4.4 Integration Points

| Kebutuhan | Status |
|---|---|
| API Backend (REST) | Kontrak API **TBD** |
| Push notification | Penyedia **TBD** |
| Peta & navigasi | Penyedia **TBD** |
| Sumber lokasi real-time | GPS ponsel driver (mulai 30 menit sebelum waktu mulai trip sampai trip berakhir); GPS tracker kendaraan opsional di v2.0 |
| Penyimpanan foto | **TBD** |
| Autentikasi | **Username + password** (pembuatan akun, kebijakan password, reset password **TBD**) |
| Analitik & crash reporting | **TBD** |

Framework mobile: **Flutter** (Android + iOS). Backend, database, dan infrastruktur: **TBD**.

### 4.5 Security & Privacy

- Pertimbangkan bahwa seluruh driver dapat melihat data operasional bersama (jumlah armada/driver, lokasi armada, tarif sewa). Konfirmasi bahwa ini memang disengaja (Bagian 8).
- TLS untuk semua komunikasi; token sesi di Keychain/Keystore.
- Password tidak disimpan di perangkat; di backend disimpan sebagai hash (algoritma **TBD**).
- Otorisasi per role dan per driver di backend.
- Lokasi dikumpulkan dari ponsel driver: izin eksplisit dan pemberitahuan jelas; retensi data **TBD**; tinjau kepatuhan UU PDP bersama pihak legal.

---

## 5. Risks & Roadmap

### 5.1 Phased Rollout

| Fase | Cakupan |
|---|---|
| **MVP** | Login, 5 tab (Beranda, Armada, Penugasan/Konfirmasi, Monitoring, Profile) beserta Detail Armada [termasuk section Maintenance + pengajuan], notifikasi (ikon lonceng) |
| **v1.1** | Checklist kendaraan, update status trip (mulai/selesai), lapor masalah/kerusakan, penyempurnaan offline |
| **v2.0** | Integrasi GPS tracker kendaraan (jika dipilih), analitik kinerja driver |

Timeline: **TBD** (belum ada deadline).

### 5.2 Risiko

| Risiko | Mitigasi |
|---|---|
| Tanpa opsi tolak, driver yang berhalangan tidak punya jalur di aplikasi | Proses di luar aplikasi via admin, atau tambahkan opsi di fase berikutnya |
| Update status trip ditunda: tidak ada penanda mulai/selesai trip di aplikasi | Tentukan pemicu alternatif (mis. oleh admin) atau percepat ke v1.1 |
| Pelacakan aktif dalam jendela trip: konsumsi baterai/data, privasi driver, dan trip yang molor melewati waktu berakhir | Tampilkan indikator pelacakan aktif di aplikasi; tetapkan aturan bila trip molor melewati waktu berakhir |
| Perbedaan perilaku pelacakan background Android vs iOS (di Flutter bergantung pada plugin/kode native) | Pilih plugin lokasi background yang terpelihara; uji di perangkat nyata kedua OS sejak awal; pisahkan lapisan lokasi agar mudah diganti |
| Semua driver melihat data operasional bersama | Konfirmasi kebijakan; batasi field sensitif di backend bila perlu |
| Persetujuan admin memperlambat maintenance | Notifikasi ke admin, SLA persetujuan **TBD** |
| Ketergantungan pada sisi Admin (persetujuan, penugasan) di luar scope | Sepakati kontrak API, gunakan mock |
| Driver dapat mengubah semua field profil tanpa persetujuan (mis. masa berlaku SIM) | Simpan riwayat perubahan (audit log); field hasil sistem tetap read-only |
| Konektivitas buruk | Cache + antrian offline |

---

## 6. Perubahan

**Draft 0.9 (dari 0.8)**
- Pelacakan lokasi mulai **30 menit** sebelum waktu mulai trip.
- Metode login: **username + password**.
- Status backend/API: belum diputuskan.

**Draft 0.8 (dari 0.7)**
- Section Maintenance di Detail Armada: daftar jadwal + filter kategori, **tanpa kalender**.
- Pelacakan lokasi: mulai dari waktu mulai trip (atau X jam sebelumnya) sampai trip berakhir (sebelumnya sejak konfirmasi).
- Framework mobile: **Flutter**.

**Draft 0.7 (dari 0.6)**
- Maintenance menjadi **section di dalam Detail Armada** per kendaraan (bukan bagian layar Armada secara umum).
- Notifikasi diakses lewat ikon lonceng di app bar.
- **Menu Cepat** pada Dashboard dihapus.

**Draft 0.6 (dari 0.5)**
- Bottom navigation menjadi: Beranda · Armada · Penugasan · Monitoring · Profile (tab Notifikasi dan Lainnya dihapus).
- Layar Maintenance dipindahkan menjadi bagian dari layar Armada.

**Draft 0.5 (dari 0.4)**
- Layar Armada, Detail Armada, dan Maintenance menampilkan **seluruh armada**.
- Rating, total trip, dan kendaraan ditugaskan **read-only** pada Profile.
- Sumber lokasi = ponsel driver, aktif sejak konfirmasi penugasan sampai trip berakhir.

**Draft 0.4 (dari 0.3)**
- Peta Monitoring = perjalanan driver sendiri + ringkasan global.
- Ubah Data pada Profile: semua field langsung tersimpan tanpa persetujuan admin.

**Draft 0.3 (dari 0.2)**

- Checklist, update status trip, dan lapor masalah **ditunda** (dipindah ke v1.1).
- Dashboard & Monitoring memakai **data operasional bersama seluruh role** (bukan hanya milik driver).
- Tarif Sewa di Detail Armada **tampil**.
- Pengajuan maintenance **perlu persetujuan admin**.
- Detail Driver → **Profile**; hanya tombol **Ubah Data**; tab "Driver" → **Profile**.

---

## 7. Referensi Desain

Mockup UI NavaGo (7 layar valid) dan `DESIGN.md`. Catatan: `DESIGN.md` v1 masih menjelaskan layar Manajemen Driver dan konteks Supervisor; perlu disesuaikan dengan scope ini.

---

## 8. Pertanyaan Terbuka

1. **Pengajuan maintenance:** boleh untuk armada mana pun yang tampil, atau hanya kendaraan yang ditugaskan ke driver?
2. **Ubah Data profil:** karena langsung tersimpan, apakah perubahan masa berlaku SIM/dokumen perlu diverifikasi admin?
3. **Monitoring:** apa isi tab "Armada" dan "Driver" (bukan peta) untuk driver?
4. **Trip molor:** bagaimana pelacakan jika trip melewati waktu berakhir yang dijadwalkan?
5. **Data bersama:** apakah memang disengaja semua driver melihat data operasional dan lokasi armada lain?
6. **Batas waktu konfirmasi** penugasan dan penanganan driver yang berhalangan.
7. **Backend** (stack, dan apakah sudah ada atau perlu dibangun — belum diputuskan), pembuatan akun & reset password, target KPI, deadline, dan bahasa aplikasi.
