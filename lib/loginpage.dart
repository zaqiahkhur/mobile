// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:uasmobile/home_page.dart';
import 'package:uasmobile/user_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

 Future _login() async {
  var response = await http.post(
    Uri.parse("http://10.5.20.27/jsonmobile/cek_login.php"),
    body: {
      "username": username.text,
      "password": password.text,
    },
  );

  print(response.statusCode); // Debugging print

  if (response.statusCode == 200) {
    try {
      var datauser = json.decode(response.body);
      if (datauser['success'] == true) {
        String role = datauser['role'];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil'),
            backgroundColor: Colors.green,
          ),
        );

        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Admin page
          );
        } else if (role == 'member') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePageUser()), // Member page
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Username atau password salah'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print("Response bukan JSON: ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan format data dari server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terjadi kesalahan pada server'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Peminjaman Barang",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo[300],
      ),
      body: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.only(top: 25, left: 30),
            child: Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),  
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 33),
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: TextFormField(
                controller: username,
                decoration: const InputDecoration(
                    labelText: "  Username", border: InputBorder.none),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 33),
            child: Container(
              width: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.grey[200],
              ),
              child: TextFormField(
                controller: password,
                decoration: const InputDecoration(
                    labelText: "  Password", border: InputBorder.none),
                obscureText: true,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 33),
            child: SizedBox(
              width: 350,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  _login();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(69, 130, 195, 1)),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
