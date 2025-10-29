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