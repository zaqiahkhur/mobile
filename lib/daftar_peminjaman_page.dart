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
        Uri.parse("http://192.168.43.159/jsonmobile/readpeminjaman.php"),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Parsing Jumlah_barang dari string ke int dengan error handling
        List<Map<String, dynamic>> parsedData = [];
        for (var item in data) {
          int jumlahBarang;
          try {
            jumlahBarang =
                int.parse(item['Jumlah_barang']); // Parsing dari string ke int
          } catch (e) {
            print('Error parsing jumlah_barang: $e'); // Handle error
            jumlahBarang = 0; // Default value jika parsing gagal
          }

          parsedData.add({
            'id':
            int.tryParse(item['id']) ?? 0, // Pastikan 'id' juga berupa int
            'username': item['username'],
            'kode_barang': item['kode_barang'],
            'Jumlah_barang':
             jumlahBarang, // Menggunakan jumlah barang yang sudah di-parse
            'tanggal_pinjam': item['tanggal_pinjam'],
            'tanggal_kembali': item['tanggal_kembali'],
            'status': item['status'],
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

  // Fungsi untuk mengembalikan barang
 Future<void> _kembalikanBarang(int idPeminjaman) async {
  try {
    final response = await http.post(
      Uri.parse("http://192.168.43.159/jsonmobile/kembalikan_barang.php"),
      body: {'id': idPeminjaman.toString()},
    );
    print('Response from server: ${response.body}');

    // Pastikan kode status HTTP 200
    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final data = jsonDecode(response.body);

        // Jika operasi berhasil
        if (data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Barang berhasil dikembalikan')),
          );
          _fetchDataPeminjaman(); // Memperbarui data peminjaman
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Terjadi kesalahan saat mengembalikan barang')),
          );
        }
      } else {
        // Tanggapan kosong dari server
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tanggapan server kosong')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kesalahan server: ${response.statusCode}')),
      );
    }
  } catch (e) {
    // Tangani kesalahan jaringan atau parsing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan: $e')),
    );
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
                        Text('Kode Barang: ${peminjaman['kode_barang']}'),
                        Text(
                            'Jumlah: ${peminjaman['Jumlah_barang']}'), // Sudah dalam bentuk int
                        Text('Tanggal Pinjam: ${peminjaman['tanggal_pinjam']}'),
                        Text(
                            'Tanggal Kembali: ${peminjaman['tanggal_kembali']}'),
                        Text('Status: ${peminjaman['status']}'),
                      ],
                    ),
                    trailing: peminjaman['status'] == 'belum kembali'
                        ? ElevatedButton(
                            onPressed: () {
                              _kembalikanBarang(peminjaman[
                                  'id']); // Panggil fungsi kembalikan barang
                            },
                            child: Text('Kembalikan'),
                          )
                        : Text('Sudah Kembali'),
                  ),
                );
              },
            ),
    );
  }
}
