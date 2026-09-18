```markdown
# 📱 Healthcare Digital App

Panduan instalasi dan cara menjalankan proyek ini di komputer lokal Anda.

---

## 🚀 Langkah-langkah Instalasi

### 1. Clone Repository
Clone repository ini ke direktori lokal komputer Anda melalui terminal atau command prompt:
```bash
git clone https://github.com/username/Healthcare_Digital.git
cd Healthcare_Digital

```

### 2. Buat Database di PostgreSQL

Buat database baru di PostgreSQL, lalu jalankan query SQL berikut untuk membuat tabel yang dibutuhkan:

```sql
CREATE TABLE members (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    age TEXT NOT NULL,
    dob TEXT NOT NULL,
    gender TEXT NOT NULL,
    nik TEXT NOT NULL,
    blood TEXT NOT NULL,
    isElderly INTEGER NOT NULL,
    avatarIcon INTEGER NOT NULL
);

CREATE TABLE health_history (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    date TEXT NOT NULL,
    location TEXT NOT NULL,
    category TEXT NOT NULL,
    note TEXT NOT NULL
);

```

### 3. Konfigurasi Password Database

Sesuaikan konfigurasi koneksi database Anda (terutama password) di dalam file `.env` agar terhubung dengan PostgreSQL lokal Anda.

``DB_CONNECTION=pgsql
DB_HOST=127.0.0.1
DB_PORT=5432
DB_DATABASE=sekolah_robotik
DB_USERNAME=postgres
DB_PASSWORD=isi_password_postgresql_anda

```

### 4. Install Dependencies Flutter

Buka terminal pada direktori proyek, lalu jalankan perintah berikut untuk mengunduh package Flutter:

```bash
flutter pub get

```

### 5. Install Dependencies Backend (Node.js)

Masuk ke direktori server/backend, lalu install package Node.js dengan perintah:

```bash
npm install

```

### 6. Menjalankan Server

Setelah semua konfigurasi selesai, jalankan server backend menggunakan Node.js:

```bash
node index.js

```

