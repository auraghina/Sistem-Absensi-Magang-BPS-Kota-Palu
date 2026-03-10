// =============================================
// KONFIGURASI SUPABASE
// Ganti dengan URL dan ANON KEY dari project Supabase kamu
// =============================================
const SUPABASE_URL = 'https://YOUR_PROJECT_ID.supabase.co';
const SUPABASE_ANON_KEY = 'YOUR_ANON_KEY';

const { createClient } = supabase;
const db = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// Helper: get current user
async function getCurrentUser() {
  const { data: { user } } = await db.auth.getUser();
  return user;
}

// Helper: get user profile (role, nama, dll)
async function getUserProfile(userId) {
  const { data, error } = await db
    .from('profiles')
    .select('*')
    .eq('id', userId)
    .single();
  if (error) return null;
  return data;
}

// Helper: redirect kalau belum login
async function requireAuth(redirectTo = '/index.html') {
  const user = await getCurrentUser();
  if (!user) {
    window.location.href = redirectTo;
    return null;
  }
  return user;
}

// Helper: redirect kalau sudah login
async function redirectIfLoggedIn(redirectAdmin = '/pages/admin.html', redirectMagang = '/pages/magang.html') {
  const user = await getCurrentUser();
  if (user) {
    const profile = await getUserProfile(user.id);
    if (profile?.role === 'admin') {
      window.location.href = redirectAdmin;
    } else {
      window.location.href = redirectMagang;
    }
  }
}
