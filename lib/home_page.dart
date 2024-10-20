import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uasmobile/daftar_barang_page.dart';
import 'package:uasmobile/daftar_peminjam.dart';
import 'package:uasmobile/daftar_peminjaman_page.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var height, width;
  List _listdata = [];
  bool _isloading = true;

  Future<void> _getdata() async {
    try {
      final response = await http.get(Uri.parse("http://10.108.19.8/jsonmobile/read.php"));
      if (response.statusCode == 200) {
        setState(() {
          _listdata = json.decode(response.body);
          _isloading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print(e);
      setState(() {
        _isloading = false;
      });
    }
  }

  Future<bool> _hapus(String id) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.108.19.8/jsonmobile/delete.php"),
        body: {"id": id},
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getdata();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman Barang Baknus'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text("qias"),
              accountEmail: Text(""),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage("path_to_your_image.jpg"),
              ),
              decoration: BoxDecoration(
                color: Colors.indigo[300],
              ),
            ),
            ListTile(
              title: Text('Daftar Barang'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/second');
              },
            ),
            ListTile(
              title: Text('Daftar Peminjaman'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/third');
              },
            ),
            ListTile(
              title: Text('Daftar User'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/fourth');
              },
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.indigo[300], // Background biru
        child: Column(
          children: [
            // Bagian teks terakhir update
            Container(
              padding: EdgeInsets.all(40),
              alignment: Alignment.centerLeft,
              child: Text(
                "Dashboard",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                ),
              ),
            ),
            // Expanded agar background biru lebih besar
            Expanded(
              flex: 1, // Tambahkan lebih besar dari sebelumnya
              child: Container(
                color: Colors.indigo[300], // Biru tetap di sini
              ),
            ),
            // Grid Menu untuk item dashboard
            Expanded(
              flex: 5, // Proporsi container putih dan grid item lebih kecil
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: GridView.count(
                  crossAxisCount: 2, // Jumlah kolom dalam grid
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildMenuItem(Icons.inventory, "Data Barang", DaftarBarangPage()), // Halaman Data Barang
                    _buildMenuItem(Icons.person, "Data User", daftaruserpage()), // Halaman Data User
                    _buildMenuItem(Icons.calendar_today, "Data Peminjaman", DaftarPeminjamanPage()), // Halaman Data Peminjaman
                    _buildMenuItem(Icons.check_circle, "Barang Kembali", DaftarPeminjamanPage()), // Halaman Barang Kembali
                    _buildMenuItem(Icons.block, "Barang Belum Kembali", DaftarPeminjamanPage()), // Halaman Barang Belum Kembali
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fungsi untuk membangun item grid
  Widget _buildMenuItem(IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // Posisi bayangan
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.blue), // Ikon besar di dalam kotak
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
