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

  // Fungsi untuk mengambil data peminjaman dari API
  Future<void> _fetchDataPeminjaman() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.5.20.27/jsonmobile/readpeminjaman.php"),
      );

     if (response.statusCode == 200) {
  var data = jsonDecode(response.body);
  print(data);  // Debugging untuk melihat respons dari server

  List<Map<String, dynamic>> parsedData = [];
  for (var item in data) {
    parsedData.add({
      'username': item['username'] ?? 'Tidak Diketahui',
      'kode_barang': item['kode_barang'] ?? 'Tidak Ada',
      'Kode_pinjam': item['Kode_pinjam'] ?? 'Tidak Diketahui',
      'Jumlah_barang': int.tryParse(item['Jumlah_barang'] ?? '0') ?? 0,
      'tanggal_pinjam': item['tanggal_pinjam'] ?? '-',
      'tanggal_kembali': item['tanggal_kembali'] ?? '-',
      'status': item['status'] ?? 'Tidak Diketahui',
    });
  }

  setState(() {
    _dataPeminjaman = parsedData;
  });
}
 else {
        throw Exception('Gagal mengambil data peminjaman');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // Fungsi untuk mengembalikan barang
  Future<void> _kembalikanBarang(String kodePinjam) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.5.20.27/jsonmobile/kembalikan_barang.php"),
        body: {'Kode_pinjam': kodePinjam},
      );

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        if (responseData['success']) {
          print(responseData['message']);
          _fetchDataPeminjaman(); // Refresh data setelah pengembalian
        } else {
          print('Gagal mengembalikan barang: ${responseData['message']}');
        }
      } else {
        throw Exception('Gagal menghubungi server');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Barang yang Dipinjam'),
      ),
      body: _dataPeminjaman.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _dataPeminjaman.length,
              itemBuilder: (context, index) {
                final peminjaman = _dataPeminjaman[index];

                return Card(
                  child: ListTile(
                    title: Text('Nama Peminjam: ${peminjaman['username']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kode Peminjaman: ${peminjaman['Kode_pinjam']}'),
                        Text('Kode Barang: ${peminjaman['kode_barang']}'),
                        Text('Jumlah: ${peminjaman['Jumlah_barang']}'),
                        Text('Tanggal Pinjam: ${peminjaman['tanggal_pinjam']}'),
                        Text('Tanggal Kembali: ${peminjaman['tanggal_kembali']}'),
                        Text('Status: ${peminjaman['status']}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      onPressed: peminjaman['status'] == 'belum kembali'
                          ? () {
                              _kembalikanBarang(peminjaman['Kode_pinjam']);
                            }
                          : null,
                      child: Text('Kembalikan'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
