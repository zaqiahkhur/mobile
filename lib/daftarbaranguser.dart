import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'peminjaman_page.dart'; // Pastikan untuk mengimpor halaman Peminjaman
import 'tambah_data.dart';

class DaftarBarangUserPage extends StatefulWidget {
  DaftarBarangUserPage({Key? key}) : super(key: key);

  @override
  _DaftarBarangUserPageState createState() => _DaftarBarangUserPageState();
}

class _DaftarBarangUserPageState extends State<DaftarBarangUserPage> {
  List _listdata = [];
  bool _isloading = true;

  Future<void> _getdata() async {
    try {
      final response = await http.get(Uri.parse("http://192.168.43.159/jsonmobile/read.php"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response data: $data"); // Log the response data
        if (data is List) {
          setState(() {
            _listdata = data;
            _isloading = false;
          });
        } else {
          throw Exception('Data is not a list');
        }
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
      ),
      body: _isloading
          ? Center(child: CircularProgressIndicator())
          : _listdata.isEmpty
              ? Center(child: Text("No data available"))
              : ListView.builder(
                  itemCount: _listdata.length,
                  itemBuilder: (context, index) {
                    final item = _listdata[index];
                    return Card(
                      child: ListTile(
                        title: Text(item['nama_barang']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Kode Barang: ${item['Kode_barang']}"),
                            Text("Jumlah Barang: ${item['Jumlah_barang']}"),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PeminjamanPage(
                                  kodeBarang: item['Kode_barang'],
                                  namaBarang: item['nama_barang'],
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.add_shopping_cart),
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          "+",
          style: TextStyle(fontSize: 30), 
        ),
        backgroundColor: Colors.indigo[300],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TambahDataPage()),
          ).then((value) {
            if (value == true) {
              _getdata();
            }
          });
        },
      ),
    );
  }
}
