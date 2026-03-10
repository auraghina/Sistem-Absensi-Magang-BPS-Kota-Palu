-- =============================================
-- SIMAGANG BPS KOTA PALU
-- SQL Schema untuk Supabase
-- Jalankan di: Supabase Dashboard > SQL Editor
-- =============================================

-- 1. Tabel profiles (data user)
CREATE TABLE IF NOT EXISTS profiles (
  id          UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email       TEXT,
  nama_lengkap TEXT NOT NULL,
  institusi   TEXT,
  divisi      TEXT,
  tgl_mulai   DATE,
  tgl_selesai DATE,
  role        TEXT NOT NULL DEFAULT 'magang' CHECK (role IN ('admin', 'magang')),
  created_at  TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Tabel absensi
CREATE TABLE IF NOT EXISTS absensi (
  id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  tanggal       DATE NOT NULL,
  checkin_time  TIME,
  checkout_time TIME,
  status        TEXT NOT NULL DEFAULT 'hadir' CHECK (status IN ('hadir', 'izin', 'alpha')),
  catatan       TEXT,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE (user_id, tanggal)  -- satu record per orang per hari
);

-- =============================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE absensi  ENABLE ROW LEVEL SECURITY;

-- PROFILES policies
CREATE POLICY "Users bisa lihat profil sendiri"
  ON profiles FOR SELECT
  USING (auth.uid() = id);

CREATE POLICY "Admin bisa lihat semua profil"
  ON profiles FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Users bisa update profil sendiri"
  ON profiles FOR UPDATE
  USING (auth.uid() = id);

CREATE POLICY "Admin bisa insert profil"
  ON profiles FOR INSERT
  WITH CHECK (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Admin bisa hapus profil magang"
  ON profiles FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- ABSENSI policies
CREATE POLICY "Users bisa lihat absensi sendiri"
  ON absensi FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Admin bisa lihat semua absensi"
  ON absensi FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

CREATE POLICY "Users bisa insert absensi sendiri"
  ON absensi FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users bisa update absensi sendiri (checkout)"
  ON absensi FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Admin bisa update semua absensi"
  ON absensi FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM profiles
      WHERE id = auth.uid() AND role = 'admin'
    )
  );

-- =============================================
-- AUTO-CREATE PROFILE SAAT USER REGISTER
-- =============================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, nama_lengkap, role)
  VALUES (
    NEW.id,
    NEW.email,
    COALESCE(NEW.raw_user_meta_data->>'nama_lengkap', NEW.email),
    COALESCE(NEW.raw_user_meta_data->>'role', 'magang')
  );
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE OR REPLACE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- =============================================
-- CONTOH: Buat akun admin pertama (jalankan manual)
-- Ganti dengan email & password admin BPS Anda
-- =============================================
-- Setelah buat user lewat Supabase Auth > Users, 
-- update role-nya jadi admin:
--
-- UPDATE profiles SET role = 'admin' 
-- WHERE email = 'admin@bps-palu.go.id';
