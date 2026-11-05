# 🎂 Sweet Bliss – Cake & Bakery Catalog

> Aplikasi Flutter untuk menjelajahi resep kue, menyimpan favorit, dan berbagi komentar.

---

## 👩‍🎓 Identitas Mahasiswa

| Field     | Detail                        |
|-----------|-------------------------------|
| Nama      | Theresia Darius               |
| NIM       | 2415051116                    |
| Kelas     | PTI 5 A                       |
| Mata Kuliah | Pemrograman Mobile – UTS    |

---

## 📖 Deskripsi Aplikasi

**Sweet Bliss** adalah aplikasi katalog resep kue berbasis Flutter yang terhubung ke:
- **TheMealDB API** – sumber data resep kue/dessert (hanya GET, gratis, tanpa autentikasi)
- **Supabase** – backend untuk menyimpan komentar dan favorit per pengguna anonim

Pengguna dapat:
- Menjelajahi puluhan resep kue dari TheMealDB
- Mencari resep dengan fitur debounce search
- Melihat detail resep lengkap (bahan + instruksi)
- Menyimpan/menghapus favorit (tersimpan di cloud)
- Membaca, menulis, mengedit, dan menghapus komentar per resep

---

## ✨ Daftar Fitur

### 🏠 Home Screen
- Banner hero "Life is Better with Cake"
- Bar manfaat (Premium Ingredients, Freshly Baked, Made With Love)
- Kategori Birthday / Anniversary / Theme / Cupcakes
- Daftar **Best Sellers** (6 featured dessert dari API)
- Pull-to-refresh pada semua halaman

### 🍰 Recipes Screen
- Grid resep responsif: **2 kolom** (ponsel) · **3 kolom** (tablet) · **4 kolom** (web)
- Search bar dengan **debounce 500ms** agar tidak spam API
- Tombol clear search + counter hasil pencarian
- Pull-to-refresh untuk reload data

### 📋 Detail Screen
- Hero image dari TheMealDB
- Tombol **♥ favorit** di AppBar (merah = sudah difavoritkan)
- Chip kategori, area, dan tags
- Daftar bahan dengan takaran
- Instruksi langkah demi langkah bernomor
- Seksi **komentar** real-time dari Supabase
- FAB **"Add Comment"** – form dengan validasi

### 💬 Komentar (CRUD Lengkap)
- **Create**: form bottom sheet (nama + isi, validasi ketat)
- **Read**: daftar komentar diurutkan terbaru dulu
- **Update**: edit isi komentar (hanya pemilik)
- **Delete**: hapus dengan confirmation dialog (hanya pemilik)
- Kepemilikan diidentifikasi via `user_id` dari Supabase Auth anonim

### ❤️ Favorites Screen
- Grid favorit yang disimpan di Supabase
- Data tersimpan sebagai snapshot (mealName + mealThumb) → tampil offline
- Toggle favorit dengan SnackBar feedback
- Pull-to-refresh

### ⚡ UX Details
- **Loading state** dengan spinner di semua screen
- **Error state** dengan ikon jaringan / umum + tombol Retry
- **Empty state** dengan pesan kontekstual
- **SnackBar** untuk semua operasi (tambah/hapus favorit, tambah/edit/hapus komentar)
- Pesan error ramah (network, server, validasi)

---

## 🛠️ Tech Stack

| Teknologi | Versi | Fungsi |
|-----------|-------|--------|
| Flutter   | 3.x   | Framework UI |
| Dart      | 3.x   | Bahasa pemrograman (null safety) |
| Provider  | ^6.x  | State management (ChangeNotifier) |
| Supabase Flutter | ^2.x | Backend database + Auth anonim |
| HTTP      | ^1.x  | HTTP client untuk TheMealDB |
| cached_network_image | ^3.x | Cache gambar dari URL |
| flutter_dotenv | ^5.x | Membaca file .env |
| google_fonts | ^6.x | Font Poppins & Playfair Display |

---

## 🌐 REST API – TheMealDB

Base URL: `https://www.themealdb.com/api/json/v1/1`

| Endpoint | Method | Fungsi |
|----------|--------|--------|
| `/filter.php?c=Dessert` | GET | Semua resep kategori Dessert |
| `/search.php?s={query}` | GET | Cari resep berdasarkan nama |
| `/lookup.php?i={id}` | GET | Detail lengkap satu resep by ID |

> Tidak membutuhkan API key. Data dikembalikan dalam format JSON.

---

## 🗄️ Database – Supabase

### Tabel `comments`

| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | uuid (PK) | Auto-generated |
| `meal_id` | text | ID resep dari TheMealDB |
| `user_id` | uuid | ID pengguna anonim dari Supabase Auth |
| `author_name` | text | Nama yang diisi pengguna |
| `content` | text | Isi komentar |
| `created_at` | timestamptz | Timestamp otomatis |

### Tabel `favorites`

| Kolom | Tipe | Keterangan |
|-------|------|------------|
| `id` | uuid (PK) | Auto-generated |
| `user_id` | uuid | ID pengguna anonim |
| `meal_id` | text | ID resep dari TheMealDB |
| `meal_name` | text | Snapshot nama resep |
| `meal_thumb` | text | Snapshot URL thumbnail |
| `created_at` | timestamptz | Timestamp otomatis |

> **RLS aktif**: pengguna hanya bisa baca/ubah/hapus data milik `user_id` sendiri.

---

## 🏗️ Arsitektur

Aplikasi mengikuti pola **Screen → Provider → Repository → Service → API/Supabase**.

```
Screen
  │  (read state via Consumer/context.watch)
  ▼
Provider (ChangeNotifier)
  │  (call methods, never directly call API)
  ▼
Repository
  │  (business logic: filter, mapping JSON → Dart model)
  ▼
Service
  │  (raw HTTP / Supabase queries)
  ▼
API (TheMealDB) / Supabase
```

**Aturan ketat:**
- ❌ Screen **dilarang** memanggil HTTP atau Supabase langsung
- ❌ Screen **dilarang** menggunakan `setState()` untuk shared state
- ✅ Semua shared state dikelola Provider

---

## 📁 Struktur Proyek

```
lib/
├── main.dart                     # Entry point, MultiProvider, Supabase init
├── models/
│   ├── meal.dart                 # Model Meal + Ingredient (TheMealDB)
│   ├── comment.dart              # Model Comment (Supabase)
│   └── favorite.dart             # Model Favorite (Supabase)
├── services/
│   ├── meal_api_service.dart     # HTTP client TheMealDB
│   └── supabase_service.dart     # Supabase init + anonymous auth
├── repositories/
│   ├── meal_repository.dart      # Filter + mapping resep
│   ├── comment_repository.dart   # CRUD komentar Supabase
│   └── favorite_repository.dart  # CRUD favorit Supabase
├── providers/
│   ├── meal_provider.dart        # State resep (list + detail + featured)
│   ├── comment_provider.dart     # State komentar (CRUD)
│   └── favorite_provider.dart    # State favorit (toggle + isFavorite)
├── screens/
│   ├── main_screen.dart          # NavigationBar 3 tab (Home, Recipes, Favorites)
│   ├── home_screen.dart          # Halaman utama
│   ├── recipe_list_screen.dart   # Grid resep + search
│   ├── recipe_detail_screen.dart # Detail resep + komentar + favorit
│   └── favorite_screen.dart      # Daftar favorit
├── widgets/
│   ├── recipe_card.dart          # Kartu resep reusable
│   ├── comment_card.dart         # Kartu komentar dengan aksi edit/delete
│   ├── category_card.dart        # Kartu kategori di HomeScreen
│   ├── section_heading.dart      # Judul seksi dengan subtitle
│   └── state_view.dart           # Loading / Error / Empty state
└── theme/
    └── app_theme.dart            # Warna, tipografi, tema Material 3
```

---

## ⚙️ Cara Menjalankan

### Prasyarat
- Flutter SDK ≥ 3.0
- Dart SDK ≥ 3.0
- Android Emulator / iOS Simulator / perangkat fisik
- Akun Supabase (gratis di [supabase.com](https://supabase.com))

### 1. Clone Repository

```bash
git clone https://github.com/theresiadarius-byte/UTS_2415051116_TheresiaDarius.git
cd UTS_2415051116_TheresiaDarius
```

### 2. Buat File `.env`

```bash
cp .env.example .env
```

Buka file `.env` dan isi dengan nilai dari Supabase dashboard:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_KEY=your-anon-public-key
```

> Dapatkan nilai ini dari: **Supabase Dashboard → Settings → API**

### 3. Buat Tabel di Supabase

Jalankan SQL berikut di **Supabase SQL Editor**:

```sql
-- Tabel komentar
CREATE TABLE comments (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  meal_id     text NOT NULL,
  user_id     uuid NOT NULL,
  author_name text NOT NULL,
  content     text NOT NULL,
  created_at  timestamptz DEFAULT now()
);

-- Tabel favorit
CREATE TABLE favorites (
  id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id     uuid NOT NULL,
  meal_id     text NOT NULL,
  meal_name   text NOT NULL,
  meal_thumb  text NOT NULL,
  created_at  timestamptz DEFAULT now()
);

-- Aktifkan RLS
ALTER TABLE comments  ENABLE ROW LEVEL SECURITY;
ALTER TABLE favorites ENABLE ROW LEVEL SECURITY;

-- Policy: pengguna hanya bisa akses data milik sendiri
CREATE POLICY "comments_own" ON comments  USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
CREATE POLICY "favorites_own" ON favorites USING (auth.uid() = user_id) WITH CHECK (auth.uid() = user_id);
```

### 4. Install Dependencies & Jalankan

```bash
flutter pub get
flutter run
```

---

## 📸 Screenshots

| Home Screen | Recipes Grid | Recipe Detail |
|:-----------:|:------------:|:-------------:|
| ![Home](screenshots/home.png) | ![Recipes](screenshots/recipes.png) | ![Detail](screenshots/detail.png) |

| Favorites | Comments | Add Comment |
|:---------:|:--------:|:-----------:|
| ![Favorites](screenshots/favorites.png) | ![Comments](screenshots/comments.png) | ![Add](screenshots/add_comment.png) |

> 📌 *Screenshot akan ditambahkan setelah build final.*

---

## 📝 Commit History

| Commit | Deskripsi |
|--------|-----------|
| `Initialize Flutter UTS project` | Setup pubspec, .gitignore, .env.example |
| `Setup project architecture and folders` | Struktur folder models/services/repositories/providers/screens/widgets |
| `Build initial application UI` | AppTheme, RecipeCard, HomeScreen, RecipeListScreen, RecipeDetailScreen |
| `Implement responsive layouts` | LayoutBuilder grid 2/3/4 kolom, MediaQuery |
| `Add application navigation` | MainScreen NavigationBar 3 tab, IndexedStack |
| `Add application data models` | Model Meal, Comment, Favorite |
| `Implement application state management` | MealProvider, CommentProvider, FavoriteProvider |
| `Integrate TheMealDB REST API` | MealApiService, MealRepository, wire ke screens |
| `Connect Supabase auth, read favorites and comments` | SupabaseService, repos, CommentCard, FavoriteScreen |
| `Add comment with validation form` | Form validasi nama + isi min 5 karakter |
| `Implement edit comment for comment owner` | Edit komentar hanya pemilik |
| `Implement delete comment with confirmation dialog` | Dialog konfirmasi hapus |
| `Fix Supabase env key name and add crash guard in main` | Bugfix: SUPABASE_KEY, try-catch |
| `Clean up unused stub files from initial architecture` | Hapus file placeholder Stage 2 |
| `Add SnackBar feedback and pull-to-refresh` | SnackBar favorit/refresh, RefreshIndicator |
| `Improve API and Supabase error handling and messages` | Timeout, pesan error ramah, StateView upgrade |
| `Polish UI and fix responsive overflow on widgets` | Flexible, maxLines, ellipsis semua widget |
| `Add README and final project documentation` | README.md lengkap |

---

## 📄 Lisensi

Proyek ini dibuat untuk keperluan akademis – UTS Pemrograman Mobile, Universitas Teknokrat Indonesia.

---

*Made with ♥ and lots of cake 🎂 by Theresia Darius*
