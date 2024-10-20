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
  final TextEditingController _jumlahbarangController = TextEditingController();
  final TextEditingController _tanggalPinjamController = TextEditingController();
  final TextEditingController _tanggalKembaliController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _keperluanController = TextEditingController();
  TextEditingController _dateController = TextEditingController();

  // Untuk Dropdown No Identitas
  List<String> _listNoIdentitas = [];
  String? _selectedNoIdentitas;
  bool _isLoading = true; // Indikator loading

  @override
  void dispose() {
    _jumlahbarangController.dispose();
    _tanggalPinjamController.dispose();
    _dateController.dispose();
    _statusController.dispose();
    _keperluanController.dispose();
    super.dispose();
  }

  // Fungsi untuk mengambil data dari API
  Future<void> fetchNoIdentitas() async {
    final response = await http.get(Uri.parse('http://10.108.19.8/jsonmobile/noidentitas.php'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      
      setState(() {
        _listNoIdentitas = data.map((item) => item['no_identitas'].toString()).toList();
        _isLoading = false; // Selesai loading
      });
    } else {
      throw Exception('Failed to load No Identitas');
    }
  }

  // Fungsi untuk memilih tanggal
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

  // Fungsi untuk submit peminjaman
  Future<bool> _submitPeminjaman() async {
    try {
      final response = await http.post(
        Uri.parse("http://10.108.19.8/jsonmobile/peminjaman.php"),
        body: {
          "kode_barang": widget.kodeBarang,
          "no_identitas": _selectedNoIdentitas!,
          "Jumlah_barang": _jumlahbarangController.text,
          "tanggal_pinjam": _tanggalPinjamController.text,
          "tanggal_kembali": _dateController.text,
          "status": _statusController.text,
          "keperluan": _keperluanController.text,
        },
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Peminjaman berhasil disimpan'),
          ),
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
  void initState() {
    super.initState();
    fetchNoIdentitas(); // Panggil API untuk mendapatkan No Identitas
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Peminjaman Barang"),
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

                // Dropdown untuk No Identitas
                _isLoading 
                  ? CircularProgressIndicator() // Jika sedang loading
                  : DropdownButtonFormField<String>(
                      value: _selectedNoIdentitas,
                      hint: const Text("Pilih No Identitas"),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      items: _listNoIdentitas.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedNoIdentitas = newValue!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'No Identitas tidak boleh kosong';
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
                onTap: () {
                  _selectDate();
                },
              ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _statusController,
                  decoration: InputDecoration(
                    hintText: "Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Status tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _keperluanController,
                  decoration: InputDecoration(
                    hintText: "Keperluan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Keperluan tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitPeminjaman().then((value) {
                        final snackBar = SnackBar(
                          content: Text(
                            value ? 'Peminjaman berhasil disimpan' : 'Peminjaman gagal disimpan',
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        if (value) {
                          Navigator.of(context).pop();
                        }
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
