import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:uasmobile/edit_p.dart';

class daftaruserpage extends StatefulWidget {
  daftaruserpage({Key? key}) : super(key: key);
  @override
  _daftaruserpageState createState() => _daftaruserpageState();
}

class _daftaruserpageState extends State<daftaruserpage> {
  List _listdata = [];
  bool _isloading = true;

  @override
  Future _getdata() async {
    try {
      final respone = await http
          .get(Uri.parse("http://10.5.20.27/jsonmobile/readpeminjam.php"));
      if (respone.statusCode == 200) {
        final data = jsonDecode(respone.body);
        setState(() {
          _listdata = data;
          _isloading = false;
        });
      }
    } catch (e) {}
  }

  @override
  void initState() {
    _getdata();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("user")),
        body: _isloading ? Center(child: CircularProgressIndicator(),
        ):
        ListView.builder(
  itemCount: _listdata.length,
  itemBuilder: (context, index) {
    return Card(
      child: ListTile(
        title: Text(_listdata[index]['username']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Password: ${_listdata[index]['password']}'),
            Text('Unit Kerja: ${_listdata[index]['Unit_kerja']}'),
            Text('Role: ${_listdata[index]['role']}'),
          ],
        ),
      ),
    );
  },
),
     );
  }
}
