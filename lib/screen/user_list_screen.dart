// ignore_for_file: use_key_in_widget_constructors

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/models/user.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";
  // final baseUrl = "http://localhost:5000";

  Future<void> _fetchData() async {
    //   final Dio dio = new Dio();
    //
    //   setState(() {
    //     loading = true;
    //   });
    //
    //   try {
    //     var response = await dio.get("$baseUrl/api/users");
    //     print("statusCode :  ${response.statusCode}");
    //     var data = response.data as List;
    //
    //     setState(() {
    //       list = data.map((e) => User.fromJson(e)).toList();
    //       loading = false;
    //     });
    //   } on DioError catch (e) {
    //     print(e);
    //   }
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/users"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        for (Map<String, dynamic> i in data) {
          list.add(User.fromJson(i));
        }
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("List User Manager"),
        elevation: 0.0,
      ),
      body: Container(
        child: loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, i) {
                  final x = list[i];
                  return Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(x.name),
                        Text(x.email),
                        Text(x.phone),
                        const SizedBox(
                          height: 5.0,
                        ),
                        const Text(
                          "Address",
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                        Text(
                            "${x.userAddress.address}, ${x.userAddress.city}, ${x.userAddress.country}."),
                        const SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          "Role : ${x.role.name}",
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
