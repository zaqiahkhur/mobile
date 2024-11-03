import 'package:flutter/material.dart';
import 'package:uasmobile/daftar_peminjam.dart';
import 'package:uasmobile/daftar_peminjaman_page.dart';
import 'home_page.dart';
import 'daftar_barang_page.dart';
import 'peminjaman_page.dart';
import 'user_page.dart';
import 'loginpage.dart';
void main() {
  runApp(BorrowingApp());
}

class BorrowingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peminjaman Barang Baknus',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
      routes: {
        '/second': (context) => DaftarBarangPage(),
        '/third': (context) => DaftarPeminjamanPage(),
        '/fourth': (context) => daftaruserpage(),
      },
    );
  }
}
