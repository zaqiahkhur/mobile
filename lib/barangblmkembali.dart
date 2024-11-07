import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BarangBelumKembaliListPage extends StatefulWidget {
  const BarangBelumKembaliListPage({Key? key}) : super(key: key);

  @override
  _BarangBelumKembaliListPageState createState() => _BarangBelumKembaliListPageState();
}

class _BarangBelumKembaliListPageState extends State<BarangBelumKembaliListPage> {
  List barangBelumDikembalikan = [];
  bool isLoading = true;

  // Fungsi untuk mendapatkan daftar barang yang belum dikembalikan dari API
  Future<void> _getBarangBelumDikembalikan() async {
    var response = await http
        .get(Uri.parse("http://10.5.20.27/jsonmobile/barangblmkembali.php"));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      if (data['success']) {
        setState(() {
          barangBelumDikembalikan = data['data'];
          isLoading = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
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
  }

  @override
  void initState() {
    super.initState();
    _getBarangBelumDikembalikan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barang yang Belum Dikembalikan"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: barangBelumDikembalikan.length,
              itemBuilder: (context, index) {
                var barang = barangBelumDikembalikan[index];
                return ListTile(
                  title: Text(barang['kode_barang'] ?? 'kode barang tidak tersedia'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(barang['nama_barang'] ?? 'nama barang tidak tersedia'),
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
