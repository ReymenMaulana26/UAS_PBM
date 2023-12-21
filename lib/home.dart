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
  //make list variable to accommodate all data from the database
  List _get = [];

  @override
  void initState() {
    super.initState();
    //in the first time, this method will be executed
    _getData();
  }

  Future _getData() async {
    try {
      final response = await http.get(Uri.parse(
          //you have to take the IP address of your computer.
          //because using localhost will cause an error
          "http://192.168.1.4/uas_pbm/api/list.php"));

      // if the response is successful
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // entry data to the variable list _get
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
      body: Stack(
        children: [
          // Custom AppBar
          Container(
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('img/wallpaper.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: const Text('Inventaris RT 08'),
              titleTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
              centerTitle: true,
            ),
          ),

          // Body content
          Padding(
            padding: const EdgeInsets.only(top: 255.0),
            child: _get.length != 0
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
                          padding: EdgeInsets.symmetric(
                              vertical: 0, horizontal: 15.0),
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
                                          Navigator.pushNamed(
                                              context, "itemPage");
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          child: Image(
                                            image: NetworkImage(
                                                'http://192.168.1.4/uas_pbm/api/images/${_get[index]['image']}'),
                                            width: 120,
                                            height: 100,
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
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                      "Tidak Ada Data yang Tersedia",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal.shade500,
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
