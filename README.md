# Maison Market

Katalog produk dengan tautan ke website eksternal, desain putih-luxury dengan aksen ungu, dan admin studio privat.

## Fitur
- Katalog publik dengan grid dua kolom di ponsel.
- Foto produk banyak dengan slider.
- Nama, kategori, harga opsional, deskripsi, dan tautan produk.
- Admin login khusus `adamradit01@gmail.com` di URL `/atelier-console` (bukan `/admin`).
- Admin dapat menambah, mengedit, menerbitkan/draft, dan menghapus produk.
- Supabase Auth, PostgreSQL, Storage, dan Row Level Security.
- File gambar dibagikan melalui storage, bukan hanya tersimpan di browser.

## 1. Siapkan Supabase
1. Buat project di Supabase.
2. Buka **SQL Editor**, jalankan seluruh isi `supabase-setup.sql`.
3. Buka **Authentication → Users** lalu buat user admin dengan email `adamradit01@gmail.com` dan password pilihanmu. Jangan aktifkan pendaftaran publik.
4. Salin **Project URL** dan **publishable/anon key** dari Project Settings → API (atau Connect).
5. Di `index.html`, ganti `GANTI_DENGAN_SUPABASE_PROJECT_URL` dan `GANTI_DENGAN_SUPABASE_ANON_KEY` dengan nilainya. Publishable/anon key memang dipakai frontend; **jangan pernah** masukkan service_role/secret key.

> Login website tidak menyediakan pendaftaran atau reset password. Buat/ubah password admin lewat Supabase Dashboard.

## 2. Deploy
Repo ini berisi static site. Import repo ke Vercel, framework preset **Other**, build command kosong, output directory `.`. File `vercel.json` menangani direct route untuk admin studio.

## 3. Admin
Buka `https://DOMAIN-KAMU/atelier-console`, masuk dengan email admin dan password yang kamu buat. URL ini sengaja tidak ditautkan dari halaman market; jalur yang tidak ditautkan bukan pengganti autentikasi. Database dan Storage tetap memverifikasi email admin melalui RLS.

## Catatan
- Katalog hanya menampilkan produk dengan status Terbit.
- Foto maksimal 6 per produk, 5 MB per file.
- Tautan produk menerima URL HTTP/HTTPS.
- Saat mengedit dan memilih foto tambahan, foto baru ditambahkan ke foto lama.
