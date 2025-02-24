import 'dart:convert';

import 'package:assignment_2/screen/model/products_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
//import 'package:get/get.dart';

// ignore: must_be_immutable
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductsModel> productsList = [];

  Future<List<ProductsModel>> getApi() async {
    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/posts"),
    );
    var data = jsonDecode(response.body.toString());
    if (response.statusCode == 200) {
      for (var i in data) {
        productsList.add(ProductsModel.fromJson(i));
      }
      return productsList;
    } else {
      return productsList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text("API Data"),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: getApi(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircleAvatar(child: CircularProgressIndicator()),
                  );
                } else {
                  return ListView.builder(
                    itemCount: productsList.length,
                    itemBuilder: (context, index) {
                      return ListView(
                        physics: ScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          ListTile(
                            title: Container(
                              height: 30.0,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.purple[100],
                              ),
                              child: Center(
                                child: Text(
                                  snapshot.data![index].title.toString(),
                                ),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.purple[200],
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  snapshot.data![index].body.toString(),
                                ),
                              ),
                            ),
                            leading: CircleAvatar(
                              child: Text(snapshot.data![index].id.toString()),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
