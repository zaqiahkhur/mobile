import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'peminjaman_page.dart'; // Pastikan untuk mengimpor halaman Peminjaman
import 'edit_data_page.dart';
import 'tambah_data.dart';

class DaftarBarangPage extends StatefulWidget {
  DaftarBarangPage({Key? key}) : super(key: key);

  @override
  _DaftarBarangPageState createState() => _DaftarBarangPageState();
}

class _DaftarBarangPageState extends State<DaftarBarangPage> {
  List _listdata = [];
  bool _isloading = true;

  Future<void> _getdata() async {
    try {
      final response = await http.get(Uri.parse("http://10.108.19.8/jsonmobile/read.php"));
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
                      child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EditDataPage(
                                  ListData: {
                                    "id": item['id'],
                                    "kode_barang": item['Kode_barang'],
                                    "nama_barang": item['nama_barang'],
                                    "jumlah_barang": item['Jumlah_barang'],
                                  },
                                ),
                              ),
                            );
                          },
                        child: ListTile(
                          title: Text(item['nama_barang']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Kode Barang: ${item['Kode_barang']}"),
                              Text("Jumlah Barang: ${item['Jumlah_barang']}"),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Confirm"),
                                        content: Text("Yakin anda ingin menghapus data?"),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Batal"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              _hapus(item['id']).then((value) {
                                                final snackBar = SnackBar(
                                                  content: Text(
                                                    value ? 'Data berhasil dihapus' : 'Data gagal dihapus',
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                if (value) {
                                                  setState(() {
                                                    _listdata.removeAt(index);
                                                  });
                                                }
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: Text("Hapus"),
                                          ),
                                        ],
                                       );
                                    },
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                              IconButton(
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
                            ],
                          ),
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
