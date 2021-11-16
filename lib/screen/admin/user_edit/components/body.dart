// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/screen/admin/user_list/user_list.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user, required this.userEdit})
      : super(key: key);
  final User user;
  final ManagerUser userEdit;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var loading = false;
  bool? remember = false;

  final baseUrl = "https://mystore-backend.herokuapp.com";

  final List<String> errors = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> editUser(bool? isAdmin) async {
    var role = "";
    (isAdmin == true)
        ? role = "614e9e9576d3aee39dee0bea"
        : role = "614e9f1d76d3aee39dee0bed";
    setState(() {
      loading = true;
    });
    var response =
        await http.put(Uri.parse("$baseUrl/api/users/${widget.userEdit.id}"),
            headers: <String, String>{
              'Authorization': 'Bearer ${widget.user.token}',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"role": role}));

    print("response.body : " + response.body.toString());

    if (response.statusCode == 200) {
      _showToast("User edited successfully ");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => (UserListScreen(user: widget.user))));
    } else {
      _showToast("User edited failed");
    }
  }

  Future initValue() async {
    try {
      setState(() {
        nameController.text = widget.userEdit.name;
        emailController.text = widget.userEdit.email;
        phoneController.text = widget.userEdit.phone;
        (widget.userEdit.role.name.toLowerCase() == "admin")
            ? remember = true
            : remember = false;
      });
    } catch (e) {
      print("FailedinitValue : $e");
    }
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }

  @override
  void initState() {
    initValue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (loading)
          ? Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(bottom: 20),
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                    left: getProportionateScreenWidth(18),
                    right: getProportionateScreenWidth(18),
                    top: getProportionateScreenHeight(18)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    nameFormInput(),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    emailFormInput(),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    phoneFormInput(),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    Padding(
                      padding: EdgeInsets.only(
                          left: getProportionateScreenWidth(12)),
                      child: Row(
                        children: [
                          const Text("Is Admin"),
                          Checkbox(
                            value: remember,
                            activeColor: kPrimaryColor,
                            onChanged: (value) {
                              setState(() {
                                remember = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight * 0.03),
                    SafeArea(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: getProportionateScreenWidth(250),
                                child: DefaultButton(
                                    text: "Update User",
                                    press: () {
                                      editUser(remember);
                                    }),
                              ),
                            ],
                          ),
                          SizedBox(height: getProportionateScreenHeight(14))
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  TextFormField nameFormInput() {
    return TextFormField(
      readOnly: true,
      controller: nameController,
      minLines: 1,
      maxLines: 2,
      decoration: const InputDecoration(
        labelText: "Name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField emailFormInput() {
    return TextFormField(
      readOnly: true,
      controller: emailController,
      decoration: const InputDecoration(
        labelText: "Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField phoneFormInput() {
    return TextFormField(
      readOnly: true,
      controller: phoneController,
      decoration: const InputDecoration(
        labelText: "Phone",
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
