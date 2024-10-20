import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uasmobile/daftar_barang_page.dart';
import 'package:uasmobile/daftar_peminjam.dart';
import 'home_page.dart';

class EditpPage extends StatefulWidget {
  final Map<String, dynamic> ListData;
  EditpPage({Key? key, required this.ListData}) : super(key: key);

  @override
  State<EditpPage> createState() => _EditDataPageState();
}

class _EditDataPageState extends State<EditpPage> {
  final formKey = GlobalKey<FormState>();
  
  TextEditingController id = TextEditingController();
  TextEditingController noidentitas = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController kelas = TextEditingController();
  TextEditingController jurusan = TextEditingController();

  @override
  void initState() {
    super.initState();
    id =
        TextEditingController(text: widget.ListData['id']?.toString() ?? '');
    noidentitas = TextEditingController(
        text: widget.ListData['no_identitas']?.toString() ?? '');
    nama =
        TextEditingController(text: widget.ListData['nama']?.toString() ?? '');
    kelas =
        TextEditingController(text: widget.ListData['kelas']?.toString() ?? '');
    jurusan = TextEditingController(
        text: widget.ListData['jurusan']?.toString() ?? '');
  }

  @override
  void dispose() {
    id.dispose();
    noidentitas.dispose();
    nama.dispose();
    kelas.dispose();
    jurusan.dispose();
    super.dispose();
  }

  Future<bool> _updatep() async {
    final response = await http.post(
      Uri.parse("http://10.108.19.8/jsonmobile/editp.php"),
      body: {
        "id": id.text,
        "No_identitas": noidentitas.text,
        "Nama": nama.text,
        "Kelas": kelas.text,
        "Jurusan": jurusan,
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
                controller: noidentitas,
                decoration: InputDecoration(
                  hintText: "No identitas",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "No identitas tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: nama,
                decoration: InputDecoration(
                  hintText: "Nama",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nama tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: kelas,
                decoration: InputDecoration(
                  hintText: "Kelas",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Kelas tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: jurusan,
                decoration: InputDecoration(
                  hintText: "Jurusan",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Jurusan tidak boleh kosong";
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _updatep().then((value) {
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
                                builder: (context) => daftaruserpage()),
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
