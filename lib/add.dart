// ignore_for_file: unused_field, prefer_const_constructors, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  State<Add> createState() => _AddState();
}

class _AddState extends State<Add> {
  final _formKey = GlobalKey<FormState>();

  File? _imageFile;

  // Metode _pilihGallery untuk memilih gambar dari gallery
  _pilihGallery() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1920.0,
      maxWidth: 100.0,
    );
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      setState(() {
        _imageFile = File(image.path);
        _imageBytes = imageBytes;
      });
    }
  }

// Metode _pilihKamera untuk memilih gambar dari kamera
  _pilihKamera() async {
    var image = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1920.0,
      maxWidth: 100.0,
    );
    if (image != null) {
      List<int> imageBytes = await image.readAsBytes();
      setState(() {
        _imageFile = File(image.path);
        _imageBytes = imageBytes;
      });
    }
  }

  List<int>? _imageBytes; // Tambahkan variabel ini di luar build method

  //inisialize field
  var namaBarang = TextEditingController();
  var jumlahBarang = TextEditingController();
  var keterangan = TextEditingController();

  Future _onSubmit() async {
    try {
      if (_imageFile == null) {
        // Handle kasus ketika tidak ada gambar yang dipilih
        print("Pilih gambar terlebih dahulu.");
        return;
      }

      Uint8List imageBytes = await _imageFile!.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      return await http.post(
        Uri.parse("http://192.168.1.4/uas_pbm/api/create.php"),
        body: {
          "namaBarang": namaBarang.text,
          "jumlahBarang": jumlahBarang.text,
          "keterangan": keterangan.text,
          "image": base64Image,
        },
      ).then((value) {
        // Print respons dari server
        print(value.body);

        var data = jsonDecode(value.body);
        print(data["message"]);

        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Create New Note"),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nama Barang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: namaBarang,
                decoration: InputDecoration(
                    hintText: "Tulis Nama Barang",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama Barang Harus di Isi!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Jumlah Barang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: jumlahBarang,
                decoration: InputDecoration(
                    hintText: "Tulis Jumlah Barang",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Jumlah Barang Harus di Isi!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Text(
                'Foto Barang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: InkWell(
                  onTap: () {
                    _pilihKamera();
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 10,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _imageFile == null
                            ? Icon(CupertinoIcons.photo)
                            : Image.file(_imageFile!, height: 150, width: 350),
                        SizedBox(height: 10),
                        Visibility(
                          visible: _imageFile == null,
                          child: Text(
                            'Upload foto',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Keterangan Barang',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: keterangan,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: null,
                decoration: InputDecoration(
                    hintText: 'Tulis Keterangan Barang',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    fillColor: Colors.white,
                    filled: true),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Keterangan Barang Harus di Isi!';
                  }
                  return null;
                },
              ),
              SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size.fromWidth(120),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Text(
                  "Simpan",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                ),
                onPressed: () {
                  //validate
                  if (_formKey.currentState!.validate()) {
                    //send data to database with this method
                    _onSubmit();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
