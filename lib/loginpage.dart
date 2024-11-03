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

  Future _login() async {
    var response = await http
        .post(Uri.parse("http://192.168.43.159/jsonmobile/cek_login.php"),
body: {
      "username": username.text,
      "password": password.text,
    });
if (response.statusCode==200) {
ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login berhasil'),
            backgroundColor: Colors.green,
          ),
        );
  Navigator.push(
    context, MaterialPageRoute(builder: (context)=> HomePage()));
    debugPrint('berhasil');
}else{
ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Login gagal'),
          ),
        );
debugPrint('gagal');
}
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Login Page",
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
