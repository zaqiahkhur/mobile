import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uasmobile/barangblmkembali.dart';
import 'package:uasmobile/barangsdkbl_page.dart';
import 'package:uasmobile/daftar_barang_page.dart';
import 'package:uasmobile/daftar_peminjam.dart';
import 'package:uasmobile/daftar_peminjaman_page.dart';
import 'package:uasmobile/loginpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var height, width;
    Map<String, dynamic> _data = {};
  List _listdata = [];
  bool _isloading = true;


  Future<void> _getdata() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.43.159/jsonmobile/ambil_jumlah.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
  _data = data['menampilkan_asset'] ?? [];
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
        Uri.parse("http://192.168.43.159/jsonmobile/delete.php"),
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

  Future<void> _logout() async {
  // Aksi lain yang diperlukan sebelum logout, seperti membersihkan variabel atau state
  
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const LoginPage()), // Kembali ke LoginPage
  );
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
                  ListTile(
       leading: IconButton(icon:
        Icon(Icons.logout),
        onPressed: () {
    _logout(); // Panggil fungsi logout
  },
        ), // Fungsi logout dipanggil di sini
        
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
  _buildMenuItem(Icons.inventory, "Data Barang", _data['asset_barang']?.toString() ?? "0", DaftarBarangPage()), 
  _buildMenuItem(Icons.person, "Data User", _data['asset_user']?.toString() ?? "0", daftaruserpage()), 
  _buildMenuItem(Icons.calendar_today, "Data Peminjaman", _data['asset_peminjaman']?.toString() ?? "0", DaftarPeminjamanPage()), 
  _buildMenuItem(Icons.check_circle, "Barang Kembali", _data['barang_sudah_kembali']?.toString() ?? "0", BarangKembaliListPage()), 
  _buildMenuItem(Icons.block, "Barang Belum Kembali", _data['barang_belum_kembali']?.toString() ?? "0", BarangBelumKembaliListPage()), 
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
Widget _buildMenuItem(IconData icon, String label, String count, Widget page) {
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
          SizedBox(height: 10),
          Text(
            count,  // Menggunakan count yang dikirim sebagai parameter
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}
}