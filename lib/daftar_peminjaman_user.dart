import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DaftarPeminjamanUser extends StatefulWidget {
  @override
  _DaftarPeminjamanUserState createState() => _DaftarPeminjamanUserState();
}

class _DaftarPeminjamanUserState extends State<DaftarPeminjamanUser> {
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

        // Parsing Jumlah_barang dari string ke int dengan error handling
        List<Map<String, dynamic>> parsedData = [];
        for (var item in data) {
          int jumlahBarang;
          try {
            jumlahBarang = int.parse(item['Jumlah_barang']);
          } catch (e) {
            print('Error parsing jumlah_barang: $e');
            jumlahBarang = 0;
          }

        parsedData.add({
          'username': item['username'] ?? 'Tidak Diketahui',
          'kode_barang': item['kode_barang'] ?? 'Tidak Ada',
          'Kode_pinjam': item['Kode_pinjam'] ?? 'Tidak Diketahui', // Pastikan nama kunci sesuai dengan API
          'Jumlah_barang': int.tryParse(item['Jumlah_barang'] ?? '0') ?? 0,
          'tanggal_pinjam': item['tanggal_pinjam'] ?? '-',
          'tanggal_kembali': item['tanggal_kembali'] ?? '-',
          'status': item['status'] ?? 'Tidak Diketahui',
        });

        }

        setState(() {
          _dataPeminjaman = parsedData;
        });
      } else {
        throw Exception('Gagal mengambil data peminjaman');
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
                print(peminjaman); // Debugging: lihat data peminjaman

                return Card(
                  child: ListTile(
  title: Text('Nama Peminjam: ${peminjaman['username'] ?? 'Tidak Diketahui'}'),
  subtitle: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Kode Peminjaman: ${peminjaman['Kode_pinjam'] ?? 'Tidak Diketahui'}'),
      Text('Kode Barang: ${peminjaman['kode_barang'] ?? 'Tidak Ada'}'),
      Text('Jumlah: ${peminjaman['Jumlah_barang'] ?? '0'}'),
      Text('Tanggal Pinjam: ${peminjaman['tanggal_pinjam'] ?? '-'}'),
      Text('Tanggal Kembali: ${peminjaman['tanggal_kembali'] ?? '-'}'),
      Text('Status: ${peminjaman['status'] ?? 'Tidak Diketahui'}'),
    ],
  ),
),

                );
              },
            ),
    );
  }
}
