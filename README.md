# 📋 SIMAGANG — Sistem Informasi Absensi Magang
### BPS Kota Palu, Sulawesi Tengah

---

## 🗂️ Struktur File

```
absensi-bps/
├── index.html          ← Halaman login
├── schema.sql          ← SQL untuk Supabase (jalankan sekali)
├── js/
│   └── supabase.js     ← Konfigurasi & helper Supabase
└── pages/
    ├── magang.html     ← Halaman absensi peserta magang
    └── admin.html      ← Dashboard admin (kelola peserta + rekap)
```

---

## 🚀 Cara Setup (Ikuti Urutan Ini)

### LANGKAH 1 — Buat Project Supabase

1. Buka [supabase.com](https://supabase.com) → Sign up gratis
2. Klik **"New Project"**
3. Isi nama project: `simagang-bps-palu`
4. Set password database (simpan baik-baik!)
5. Pilih region: **Southeast Asia (Singapore)**
6. Klik **Create New Project** → tunggu ~2 menit

---

### LANGKAH 2 — Jalankan SQL Schema

1. Di dashboard Supabase → klik **SQL Editor** (ikon database di sidebar)
2. Klik **"New query"**
3. Copy semua isi file `schema.sql`
4. Paste ke editor, lalu klik **Run** (▶️)
5. Pastikan muncul "Success" tanpa error

---

### LANGKAH 3 — Ambil API Keys

1. Di dashboard Supabase → **Project Settings** (ikon gear)
2. Klik tab **API**
3. Catat dua nilai ini:
   - **Project URL** → contoh: `https://abcxyz123.supabase.co`
   - **anon / public key** → string panjang

---

### LANGKAH 4 — Isi Konfigurasi

Buka file `js/supabase.js`, ganti baris ini:

```javascript
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY';
```

Ganti dengan nilai yang kamu catat di langkah 3.

---

### LANGKAH 5 — Buat Akun Admin

1. Di Supabase → **Authentication** → **Users** → klik **"Add user"**
2. Masukkan email dan password admin (contoh: `admin@bpspalu.go.id`)
3. Centang **"Auto Confirm User"**
4. Klik **Create User**

Kemudian buka **SQL Editor** lagi, jalankan:

```sql
UPDATE profiles 
SET role = 'admin' 
WHERE email = 'admin@bpspalu.go.id';  -- ganti dengan email admin
```

✅ Sekarang akun tersebut bisa login sebagai admin!

---

### LANGKAH 6 — Upload ke GitHub Pages (Hosting Gratis)

1. Buat akun di [github.com](https://github.com) (gratis)
2. Klik **"New repository"** → nama: `simagang-bps`
3. Upload semua file project ini
4. Pergi ke **Settings** → **Pages**
5. Source: pilih **"main branch"** → Save
6. Tunggu ~1 menit → website aktif di:
   ```
   https://username-github-kamu.github.io/simagang-bps/
   ```

---

## 👤 Cara Tambah Peserta Magang

Login sebagai admin → tab **"Peserta Magang"** → klik **"Tambah Peserta"**

Isi form:
- Nama lengkap
- Email (dipakai untuk login)
- Password awal
- Institusi (universitas/sekolah)
- Divisi magang
- Periode mulai & selesai

Peserta bisa langsung login dengan email + password tersebut.

---

## 📱 Cara Absen (Peserta Magang)

1. Buka website → login dengan email & password
2. Klik **"Check-In Sekarang"** saat tiba
3. Isi catatan (opsional)
4. Klik **"Check-Out Sekarang"** saat pulang

---

## 📊 Fitur Admin

| Fitur | Keterangan |
|-------|-----------|
| Dashboard | Statistik harian & bulanan real-time |
| Kehadiran hari ini | Siapa saja yang sudah/belum absen |
| Filter absensi | Cari by nama, tanggal, status |
| Export Excel | Download rekap `.xlsx` |
| Kelola peserta | Tambah & hapus peserta magang |

---

## ❓ FAQ

**Q: Apakah Supabase free plan cukup?**  
A: Ya! Free plan Supabase mencukupi untuk ratusan peserta dan ribuan record absensi.

**Q: Apakah bisa diakses dari HP?**  
A: Ya, tampilan sudah responsif untuk mobile.

**Q: Data aman tidak?**  
A: Ya, menggunakan Row Level Security (RLS) — setiap user hanya bisa lihat datanya sendiri.

---

## 🛠️ Teknologi

- **Frontend**: HTML, CSS, JavaScript murni (tanpa framework)
- **Database & Auth**: Supabase (PostgreSQL + GoTrue)
- **Hosting**: GitHub Pages (gratis)
- **Export**: SheetJS (xlsx)

---

*Dibuat untuk BPS Kota Palu · Sulawesi Tengah*
