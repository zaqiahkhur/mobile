import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uasmobile/daftar_barang_page.dart';
import 'home_page.dart';

class EditDataPage extends StatefulWidget {
  final Map<String, dynamic> ListData;
  EditDataPage({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditDataPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditDataPage> {
  final formKey = GlobalKey<FormState>();
  late TextEditingController idController;
  late TextEditingController kodeBarangController;
  late TextEditingController namaBarangController;
  late TextEditingController jumlahBarangController;

  @override
  void initState() {
    super.initState();
    idController =
        TextEditingController(text: widget.ListData['id']?.toString() ?? '');
    kodeBarangController = TextEditingController(
        text: widget.ListData['kode_barang']?.toString() ?? '');
    namaBarangController = TextEditingController(
        text: widget.ListData['nama_barang']?.toString() ?? '');
    jumlahBarangController = TextEditingController(
        text: widget.ListData['jumlah_barang']?.toString() ?? '');
  }

  @override
  void dispose() {
    idController.dispose();
    kodeBarangController.dispose();
    namaBarangController.dispose();
    jumlahBarangController.dispose();
    super.dispose();
  }

  Future<bool> _update() async {
    final response = await http.post(
      Uri.parse("http://10.108.19.8/jsonmobile/edit.php"),
      body: {
        "id": idController.text,
        "Kode_barang": kodeBarangController.text,
        "nama_barang": namaBarangController.text,
        "Jumlah_barang": jumlahBarangController.text,
      },
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Data"),
      ),
      body: Form(
        key: formKey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: kodeBarangController,
                decoration: InputDecoration(
                  hintText: "Kode barang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Kode barang tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: namaBarangController,
                decoration: InputDecoration(
                  hintText: "Nama Barang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama barang tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: jumlahBarangController,
                decoration: InputDecoration(
                  hintText: "Jumlah Barang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jumlah barang tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _update().then((value) {
                      final snackBar = SnackBar(
                        content: Text(
                          value
                              ? 'Data berhasil diupdate'
                              : 'Data gagal diupdate',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      if (value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DaftarBarangPage()),
                            (route) => false);
                      }
                    });
                  }
                },
                child: Text("Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
