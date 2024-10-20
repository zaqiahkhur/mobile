import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarPeminjamanPage extends StatefulWidget {
  @override
  _DaftarPeminjamanPageState createState() => _DaftarPeminjamanPageState();
}

class _DaftarPeminjamanPageState extends State<DaftarPeminjamanPage> {
  List<Map<String, dynamic>> _dataPeminjaman = [];

  @override
  void initState() {
    super.initState();
    _fetchDataPeminjaman();
  }

  Future<void> _fetchDataPeminjaman() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.108.19.8/jsonmobile/readpeminjaman.php"),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          _dataPeminjaman = data.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Gagal mengambil data peminjaman');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Peminjaman'),
      ),
      body: _dataPeminjaman.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dataPeminjaman.length,
              itemBuilder: (context, index) {
                final peminjaman = _dataPeminjaman[index];
                return ListTile(
                  title: Text('Nama Peminjam: ${peminjaman['username']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kode barang: ${peminjaman['kode_barang']}'),
                      Text('Jumlah : ${peminjaman['Jumlah_barang']}'),
                      Text('Tanggal Pinjam: ${peminjaman['tanggal_pinjam']}'),
                      Text('Tanggal Kembali: ${peminjaman['tanggal_kembali']}'),
                      Text('Status: ${peminjaman['status']}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
