/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TambahBarang extends StatefulWidget {
  const TambahBarang({super.key});

  @override
  State<TambahBarang> createState() => _TambahBarangState();
}

class _TambahBarangState extends State<TambahBarang> {
  String namaBarang, jumlahBarang, keterangan;
  final _key = newGlobalKey<FromState>();

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  submit() async {
    final response = await http.post(BaseUrl.tambahBarang, body: {
      "namaBarang": namaBarang,
      "jumlahBarang": jumlahBarang,
      "keterangan": keterangan,
    });
    final data = jsonEncode(response.body);
    int value = data['value'];
    String pesan = data['message'];
    if (value == 1) {
      print(pesan);
      setState(() {
        Navigator.pop(context);
      });
    } else {
      print(print);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _key,
        child: ListView(
          children: <Widget>[
            TextFormField(
              onSaved: (e) => namaBarang = e,
              decoration: InputDecoration(labelText: 'Nama Barang'),
            ),
            TextFormField(
              onSaved: (e) => jumlahBarang = e,
              decoration: InputDecoration(labelText: 'Jumlah Barang'),
            ),
            TextFormField(
              onSaved: (e) => keterangan = e,
              decoration: InputDecoration(labelText: 'Keterangan'),
            ),
            MaterialButton(
              onPressed: () {
                check();
              },
              child: Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}*/

// ignore_for_file: prefer_const_constructors, unused_import, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors, prefer_final_fields, unused_field, avoid_print, unnecessary_null_comparison, prefer_is_empty, unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add.dart';
import 'edit.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  //make list variable to accomodate all data from database
  List _get = [];

  @override
  void initState() {
    super.initState();
    //in first time, this method will be executed
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the ip address of your computer.
          //because using localhost will cause an error
          "http://192.168.1.4/uas_pbm/api/list.php"));

      // if response successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // entry data to variabel list _get
        setState(() {
          _get = data;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note List'),
      ),
      //if not equal to 0 show data
      //else show text "no data available"
      body: _get.length != 0
          //we use masonry grid to make masonry card style
          ? MasonryGridView.count(
              crossAxisCount: 1,
              itemCount: _get.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        //routing into edit page
                        //we pass the id note
                        MaterialPageRoute(
                            builder: (context) => Edit(
                                  id: _get[index]['id'],
                                )));
                  },
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 15.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 3,
                                  blurRadius: 10,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, "itemPage");
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      "",
                                      width: 120,
                                      height: 150,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${_get[index]['namaBarang']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Jumlah: ${_get[index]['jumlahBarang']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            'Keterangan: ${_get[index]['keterangan']}',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Center(
              child: Text(
                "No Data Available",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              //routing into add page
              MaterialPageRoute(builder: (context) => Add()));
        },
      ),
    );
  }
}
/*
<?php

require "config.php";

// Fungsi untuk mendapatkan ekstensi dari tipe MIME
function mime_to_ext($mime) {
    $mime_to_ext_map = array(
        'image/jpeg' => 'jpg',
        'image/png' => 'png',
        // Tambahkan tipe MIME lain jika diperlukan
    );

    return $mime_to_ext_map[$mime] ?? 'unknown';
}

if ($_SERVER['REQUEST_METHOD'] == "POST") {
    $response = array();
    $namaBarang = $_POST['namaBarang'];
    $jumlahBarang = $_POST['jumlahBarang'];
    $keterangan = $_POST['keterangan'];

    if (isset($_POST['image'])) {
        $image = $_POST['image'];

        // Mengonversi base64 ke blob
        $imageBlob = base64_decode($image);

        // Mendapatkan tipe MIME dari data gambar
        $finfo = new finfo(FILEINFO_MIME_TYPE);
        $mime = $finfo->buffer($imageBlob);

        // Menentukan direktori untuk menyimpan gambar
        $uploadDir = "images/";

        // Membuat direktori jika belum ada
        if (!file_exists($uploadDir)) {
            mkdir($uploadDir, 0777, true);
        }

        // Menyimpan gambar ke direktori server
        $imageName = uniqid() . "." . mime_to_ext($mime);
        $imagePath = $uploadDir . $imageName;
        file_put_contents($imagePath, $imageBlob);
    }

    $insert = "INSERT INTO inventory VALUE(NULL,'$namaBarang','$jumlahBarang','$imageName','$keterangan')";
    if (mysqli_query($con, $insert)) {
        $response['value'] = 1;
        $response['message'] = "Berhasil ditambahkan";
        echo json_encode($response);
    } else {
        $response['value'] = 0;
        $response['message'] = "Gagal ditambahkan";
        echo json_encode($response);
    }
}
?>
*/
