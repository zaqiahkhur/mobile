import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BarangKembaliListPage extends StatefulWidget {
  const BarangKembaliListPage({Key? key}) : super(key: key);

  @override
  _BarangKembaliListPageState createState() => _BarangKembaliListPageState();
}

class _BarangKembaliListPageState extends State<BarangKembaliListPage> {
  List barangDikembalikan = [];
  bool isLoading = true;

  // Fungsi untuk mendapatkan daftar barang yang sudah dikembalikan dari API
  Future<void> _getBarangDikembalikan() async {
    try {
      var response = await http
          .get(Uri.parse("http://10.5.20.27/jsonmobile/barangsdhkembali.php"));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['success']) {
          setState(() {
            barangDikembalikan = data['data'] ?? []; // Tambahkan pengecekan null di sini
            isLoading = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Terjadi kesalahan')),
          );
          setState(() {
            isLoading = false;
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan dalam memuat data')),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getBarangDikembalikan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barang yang Dikembalikan"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : barangDikembalikan.isEmpty
              ? const Center(child: Text("Tidak ada barang yang dikembalikan"))
              : ListView.builder(
                  itemCount: barangDikembalikan.length,
                  itemBuilder: (context, index) {
                    var barang = barangDikembalikan[index];

                    // Pengecekan null pada setiap properti barang
                    return ListTile(
                      title: Text(barang['nama_barang'] ?? 'nama barang tidak tersedia'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(barang['no_identitas'] ?? 'no identitas tidak tersedia'),
                          Text(barang['username'] ?? 'username tidak tersedia'),
                          Text(barang['tanggal_pinjam'] ?? 'tanggal pinjam tidak tersedia'),
                          Text(barang['tanggal_kembali'] ?? 'tanggal kembali tidak tersedia'),
                        ],
                      ),
                        trailing: Text(barang['status'] ?? 'Status tidak tersedia'),
                    );
                  },
                ),
    );
  }
}
