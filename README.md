# Tugas 9
1. penggunaan model dart lebih ideal karena:
- Type-safe, field seperti id, price, dan title dipastikan punya tipe data benar (int, String, bool)
- Null-safety, menghindari error runtime kyk "null is not a subtype of String" karena semua field sudah terdefinisi
- Maintainability, Jika API berubah, Anda cukup mengupdate satu file model, bukan seluruh widget.
- Autocompletion, Flutter IDE bisa memberi suggestion (news.title, news.price, dll).

Jika menggunakan Map<String,dynamic> akan tidak ada type-safty, dapat ada error runtime, lebih mudah typo misalnya "tittle" yang gk akan error sampai runtime, code berantakan, dan tidak aman terhadap null yang bisa menyebabkan crash

2.
Http
- Library umum untuk HTTP request.
- Tidak menyimpan cookie, sesi, atau CSRF token.
- Harus mengatur header manual.

CookieRequest
- Dibuat khusus untuk komunikasi dengan Django Auth.
- Menyimpan session cookie, CSRF token, autentikasi user
- Memudahkan login/logout dan request yang butuh credentials.
- Provider membagikan satu instance ke seluruh app

3.
- Agar seluruh page Flutter menggunakan session dan cookie yang sama.
- Saat user login (CookieRequest punya session cookie), semua screen dapat mengecek apakah user sedang login atau melakukan request ke endpoint yang butuh auth

Jika tidak pakai Provider, setiap widget punya cookieRequest sendiri, user akan dianggap logout di halaman lain, kalau cookies hilang, auth gagal

4.
- 10.0.2.2 di ALLOWED_HOSTS karena android emulator tidak mengenal localhost. itu adalah cara emulator mengakses komputer host, sebagai suatu interface. Kalau tidak ada, django akan menolak request dgn error 400
- CORS/cross-origin. flutter dan django itu memiliki origin berbeda. Jika tidak ada cors, request akan diblok oleh browser dgn CORS policy error
- cookie samesite/secure - untuk mengizinkan cookie sesi django dikirim ke flutter yg originnya berbeda. jika salah, user selalu dianggap logan, login tidak bertahan, request 403
- tanpa <uses-permission android:name="android.permission.INTERNET" /> flutter tidak bisa mengakses django karena request timeout/loading selamanya. Android memang butuh permission khusus

5.
 a. django menyiapkan endpoint /json. data json di display menggunakan fungsi di main/views.py show_json. ini udh dibikin di tugas 6. Query DB, return jsonResponse
 b. Json API, Flutter ngirim request final response = await request.get("http://localhost:8000/json/");
 c. Fetch, Flutter nerima JSON dalam bentuk List<dynamic>
 d. Parsing, Flutter memetakan ke model dart (newsEntry.FromJson(data))
 e. Widget, Flutter tampilkan UI seperti NewsEntryCard dan NewsDetailPage dari data dalam format models

6.
Register
- Flutter mengirim POST JSON ke /auth/register/
-Django validasi password, cek username exist, buat user baru
- Django mengirim JSON status ke Flutter, Flutter tampilkan dialog “User created successfully”.

Login
- User isi form login di Flutter.
- Flutter kirim POST ke /auth/login/ menggunakan CookieRequest.
- Django authenticate(username, password),jika benar, auth_login(request, user)
- Django buat session ID dan kirim via cookie.
- CookieRequest menyimpan cookie ini.
- Seluruh request berikutnya mengirim cookie ke user dianggap login.
- Flutter menampilkan menu yang hanya muncul saat login.

Logout
- flutter send request request.logout("http://.../auth/logout/");
- Django melakukan auth_logout(request) -> hapus session.
- CookieRequest menghapus cookie lokal
- Flutter kembali ke halaman login/menu awal

7.
1. Melakukan deploy dan men debug sampai berjalan lancar
2,3,4. Implementasi registrasi, login, logout dengan guidelines dari tutorial, setup sistem autentikasi dan login, pembuatan page, pengaitan halaman tersebut melalui urls django serta flutter routing. Penggunaan external package sangat mempermudah proses ini.
5. Model kustom mudah dibuat dengan web tool Quicktype hanya dengan pasting field format json yang ingin digunakan
6. Sempat ada sedikit editing karena field seller merupakan tipe data User yang non serializeable, tapi dapat dimodifikasi jadi string, tapi itu tidak menjadi salah satu goal jadi akhirnya dibiarkan aja. models di flutter ini disesuaikan dengan yang ada di django. Banyak ganti nama variabel
7. Halaman detail juga sudah di elaborasi di tutorial, menggunakan Navigation dan formatting data NewsEntry di NewsEntryCard dan NewsEntryDetails
 

# Tugas 8
1. Navigator.push()
- Menambahkan (push) halaman baru di atas stack halaman yang sudah ada.
- Ketika pengguna menekan tombol “back”, halaman sebelumnya akan muncul kembali.
- Contoh: saat pengguna menekan tombol “Lihat Detail Produk” → halaman detail produk dibuka dengan Navigator.push(), agar bisa kembali ke halaman daftar produk.

Navigator.pushReplacement()
- Mengganti halaman saat ini dengan halaman baru (halaman lama dihapus dari stack).
- Tidak bisa kembali ke halaman sebelumnya dengan tombol “back”.
- Contoh: setelah pengguna berhasil login atau checkout, aplikasi mengganti halaman ke HomePage menggunakan Navigator.pushReplacement(), agar tidak bisa kembali ke halaman login/keranjang.

2.
- Scaffold menyediakan struktur dasar halaman: area utama (body), AppBar, dan Drawer.
- AppBar menampilkan judul halaman, ikon navigasi, atau tombol aksi seperti cart atau logout. Biasanya ada di top halaman.
- Drawer (misalnya di file left_drawer.dart) digunakan untuk navigasi antarhalaman seperti “Home”, “Produk”, “Tentang Kami”, “Logout”.
Dengan menempatkan struktur ini secara konsisten di setiap halaman, pengguna merasa berada dalam satu aplikasi yang terintegrasi. Misalnya dengan adanya topbar/appbar dalam setiap halaman.

3. 
Padding
- Memberi jarak antar elemen agar tampilan tidak saling menempel.
- Membuat form terlihat rapi dan mudah dibaca.

SingleChildScrollView
- Memungkinkan halaman bergulir ketika konten form lebih panjang dari layar.
- Penting pada tampilan form registrasi, checkout, atau input produk di Football Shop agar tidak terpotong di layar kecil.

ListView
- Cocok untuk menampilkan daftar elemen dengan panjang dinamis, seperti daftar produk atau item pesanan.
- Dapat digabung dengan ListTile untuk tampilan yang seragam.

4. Flutter menyediakan theme customization melalui ThemeData di MaterialApp. MaterialApp digunakan di main.dart (root dari seluruh aplikasi). misalnya: 
MaterialApp(
  theme: ThemeData(
    primarySwatch: Colors.green,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.green[700],
      foregroundColor: Colors.white,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: Colors.green,
      textTheme: ButtonTextTheme.primary,
    ),
  ),
  home: HomePage(),
);
# Tugas 7

yallah banyak bgt
1. Widget tree adalah struktur hierarki widget yang membentuk tampilan suatu aplikasi di flutter. Tiap elemen adalah widget dan mereka tersusun seperti pohon. Parent adalah widget pembungkus dan child adalah widget yang dibungkus oleh parent. Hubungannya seperti DOM html. Parent mengatur tata letak dan perilaku childnya.

2. MaterialApp - convenience widget that wraps a number of widgets that uses Material Design (open source design system by Google)
Scaffold - provides basic structure, foundational layout for a screen, gives pre defined slots for common UI elements
SnackBar - brief message for the user to provide feedback after an action "Kamu telah menekan tombol X"
InkWell - gives an ink splash after a click (setelah tombol dipencet, akan ada efek lingkaran di area yang dipencet)
Theme - applies consistent visual style to application 
AppBar - goes on top of the app screen within a scaffold
Text - basic widget to display a string of text
TextStyle - to style a text
Padding - adding space inside a widget between the border and the child
Column - to arrange multiple child widgets vertically
Row - to arrange multiple child widgets horizontally
SizedBox - create a box with a specific size
Center - widget that centers its child within itself
Container -  wrapper for other widgets, providing capabilities for positioning, sizing, and decoration
Card - to represent a panel of related information
MediaQuary - provides information about the device's screen and user preferences.
EdgeInset - define an immutable set of offsets in the left, top, right, and bottom
(etc.)

3. MaterialApp adalah widget utama yang menyediakan framework design Material Design milik google. Fungsinya menyediakan theme (colors, fonts, icons, etc), mengatur navigasi dan route antar halaman, mengelola localization dan title aplikasi, dan menjadi entry point bagi aplikasi berbasis Material Design.

Digunakan sebagai root karena banyak widget flutter seperti scaffold, appbar, floatingactionbutton yang bergantung pada context materialApp agar bisa menampilkan gaya dan tema Material dengan benar.

4. Stateless vs Stateful
 Immutable | Mutable
 Statis | Dinamis (bisa berubah)
 Untuk text, icon, logo (yg gak berubah) | Untuk form input, counter, animation (yang berubah)
 Lifecycle cuma build() | Lifecycle ada initState(), setState, dispose, dsb untuk mengubah state

5. BuildContext adalah objek representasi posisi widget dalam widgetTree. Penting karena memberi akses ke informasi lingkungan (theme, size, navigator, dll.). Digunakan untuk navigasi, akses theme, snackbar, dll. Setiap build() method menerima parameter BuildContext

6. Hot Reload bertujuan memperbarui tampilan UI sesuai kode dengan cepat tanpa kehilangan state dengan hampir instan. Digunakan ketika mengubah teks di Text("Hello")

Hot Restart memulai ulang aplikasi dari awal, state akan reset dan proses sedikit lebih lama. Digunakan ketika mengubah variabel global di main.dart

7. Navigasi di flutter menggunakan Navigator dan Route. Navigator.push() untuk pindah ke halaman baru dan Navigator.pop() untuk kembali ke halaman sebelumnya

misalnya 
return Scaffold(
    ...
    onPressed: () {
        Navigator.push(context, MaterialPageRoute(buildter: (context)=> SecondPage()))
    }
    ...
)