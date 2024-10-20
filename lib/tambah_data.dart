import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_page.dart';

class TambahDataPage extends StatefulWidget {
  TambahDataPage({Key? key}) : super(key: key);

  @override
  State<TambahDataPage> createState() => _TambahDataPageState();
}

class _TambahDataPageState extends State<TambahDataPage> {
  final formkey = GlobalKey<FormState>();
  TextEditingController Kode_barang = TextEditingController();
  TextEditingController nama_barang = TextEditingController();
  TextEditingController Jumlah_barang = TextEditingController();

  Future<bool> _simpan() async {
    final response = await http.post(
      Uri.parse("http://10.108.19.8/jsonmobile/create.php"),
      body: {
        "Kode_barang": Kode_barang.text,
        "nama barang": nama_barang.text,
        "Jumlah_barang": Jumlah_barang.text,
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
        title: Text("Tambah Data"),
      ),
      body: Form(
        key: formkey,
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              TextFormField(
                controller: Kode_barang,
                decoration: InputDecoration(
                  hintText: "kode barang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "kode tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: nama_barang,
                decoration: InputDecoration(
                  hintText: "Nama barang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "nama barang tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: Jumlah_barang,
                decoration: InputDecoration(
                  hintText: "Jumlah barang",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Unit kerja tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: () {
                  if (formkey.currentState!.validate()) {
                    _simpan().then((value) {
                      final snackBar = SnackBar(
                        content: Text(
                          value ? 'Data berhasil disimpan' : 'Data gagal disimpan',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);

                      if (value) {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                          (route) => false,
                        );
                      }
                    });
                  }
                },
                child: Text("Simpan"),
                
              ),
            ],
          ),
        ),
      ),
    );
  }
}
