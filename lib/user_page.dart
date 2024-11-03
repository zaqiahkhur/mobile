import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uasmobile/barangblmkembali.dart';
import 'package:uasmobile/barangsdkbl_page.dart';
import 'package:uasmobile/daftarbaranguser.dart';
import 'package:uasmobile/daftar_peminjam.dart';
import 'package:uasmobile/daftar_peminjaman_page.dart';

class HomePageUser extends StatefulWidget {
  @override
  _HomePageUserState createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaftarBarangUserPage()),
                );
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
              title: Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/five');
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(40),
              alignment: Alignment.centerLeft,
              child: Text(
                "Dashboard User",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 35,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
