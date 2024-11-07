import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uasmobile/daftar_peminjaman_page.dart';

class PeminjamanPage extends StatefulWidget {
  final String kodeBarang;
  final String namaBarang;

  PeminjamanPage({Key? key, required this.kodeBarang, required this.namaBarang}) : super(key: key);

  @override
  _PeminjamanPageState createState() => _PeminjamanPageState();
}

class _PeminjamanPageState extends State<PeminjamanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _noidentitasController = TextEditingController();
  final TextEditingController _jumlahbarangController = TextEditingController();
  final TextEditingController _tanggalPinjamController = TextEditingController();
  final TextEditingController _tanggalKembaliController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _keperluanController = TextEditingController();
  final TextEditingController _kodePinjamController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  @override
  void dispose() {
    _noidentitasController.dispose();
    _jumlahbarangController.dispose();
    _tanggalPinjamController.dispose();
    _dateController.dispose();
    _statusController.dispose();
    _keperluanController.dispose();
    _kodePinjamController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _statusController.text = "belum kembali"; // Inisialisasi status
    _generateKodePinjam(); // Panggil fungsi untuk mengambil kode pinjam otomatis
  }

Future<void> _generateKodePinjam() async {
  try {
    final response = await http.get(Uri.parse("http://10.5.20.27/jsonmobile/get_last_kode_pinjam.php"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success']) {
        // Pastikan kode pinjam terbaru berhasil diambil dan ditampilkan
        String lastKodePinjam = data['kodeBarangPinjam'] ?? "PMJ000";

        // Increment kode peminjaman
        String angkaStr = lastKodePinjam.substring(3);
        int angka = int.parse(angkaStr) + 1;
        String newKodePinjam = "PMJ${angka.toString().padLeft(3, '0')}";

        setState(() {
          _kodePinjamController.text = newKodePinjam;
        });
      } else {
        print("Error: ${data['message']}");
      }
    } else {
      print("Server error: ${response.statusCode}");
    }
  } catch (e) {
    print("Error: $e");
    setState(() {
      _kodePinjamController.text = "PMJ001"; // Default kode jika gagal
    });
  }
}


  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }


  Future<bool> _checkStokBarang(int jumlahBarang) async {
    try {
      final response = await http.get(Uri.parse("http://10.5.20.27/jsonmobile/check_stok_barang.php?kode_barang=${widget.kodeBarang}"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        int stokTersedia = data['stok'] ?? 0;
        return jumlahBarang <= stokTersedia;
      } else {
        throw Exception('Failed to fetch stock data');
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  Future<bool> _submitPeminjaman() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.5.20.27/jsonmobile/peminjaman.php"),
        body: {
          "Kode_pinjam": _kodePinjamController.text, // Kirim kode_pinjam ke API
          "kode_barang": widget.kodeBarang,
          "no_identitas": _noidentitasController.text,
          "Jumlah_barang": _jumlahbarangController.text,
          "tanggal_pinjam": _tanggalPinjamController.text,
          "tanggal_kembali": _dateController.text,
          "status": _statusController.text,
          "keperluan": _keperluanController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Peminjaman berhasil disimpan')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DaftarPeminjamanPage()),
        );
        return true;
      } else {
        throw Exception('Gagal menyimpan peminjaman');
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Peminjaman / Pengembalian Barang"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text("Kode Barang: ${widget.kodeBarang}"),
                Text("Nama Barang: ${widget.namaBarang}"),
                SizedBox(height: 10),
                TextFormField(
                  controller: _kodePinjamController,
                  decoration: InputDecoration(
                    labelText: "Kode Pinjam",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  readOnly: true, // Kode pinjam hanya bisa dibaca
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _noidentitasController,
                  decoration: InputDecoration(
                    hintText: "No Identitas",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'No identitas tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _jumlahbarangController,
                  decoration: InputDecoration(
                    hintText: "Jumlah Barang",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Jumlah Barang tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    labelText: 'Tanggal Kembali',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                  readOnly: true,
                  onTap: _selectDate,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(
                    hintText: "belum kembali",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  readOnly: true,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitPeminjaman();
                    }
                  },
                  child: Text('Pinjam Barang'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
