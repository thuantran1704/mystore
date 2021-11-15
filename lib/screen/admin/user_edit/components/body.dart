// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helper/keyboard.dart';
import 'package:mystore/models/brand.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/screen/admin/user_list/user_list.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user, required this.userEdit})
      : super(key: key);
  final User user;
  final User userEdit;
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  Future<void> editUser(
    //
    bool? isAdmin,
  ) async {
    var response =
        await http.put(Uri.parse("$baseUrl/api/products/${widget.userEdit.id}"),
            headers: <String, String>{
              'Authorization': 'Bearer ${widget.user.token}',
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode({"isAdmin": isAdmin}));

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

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      NameFormInput(),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      PriceFormInput(),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      descriptionFormInput(),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      DropdownBrandCate(),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      FormError(errors: errors),
                      SizedBox(height: SizeConfig.screenHeight * 0.03),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenWidth(5)),
                            child: const Text("Product Images:",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w700)),
                          ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                ...List.generate(
                                  widget.product.images.length,
                                  (index) => SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                        widget.product.images[index].url,
                                      ),
                                    ),
                                  ),
                                ),
                                ...List.generate(
                                  images.length,
                                  (index) => SizedBox(
                                    width: 120,
                                    height: 120,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.file(
                                        images[index],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                    width: getProportionateScreenWidth(10)),
                                InkWell(
                                  onTap: () {
                                    getImage();
                                  },
                                  borderRadius: BorderRadius.circular(20),
                                  child: SvgPicture.asset(
                                    "assets/icons/Add_image.svg",
                                    height: 120,
                                    width: 120,
                                    color: Colors.lightBlue,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
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
                                    text: "Update Product",
                                    press: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        KeyboardUtil.hideKeyboard(context);
                                        editProduct(
                                          uploaded,
                                          nameController.text,
                                          descriptionController.text,
                                          double.parse(priceController.text),
                                          dropdownBrandValue.toString(),
                                          dropdownCateValue.toString(),
                                        );
                                      }
                                    },
                                  ),
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
            ),
    );
  }

  TextFormField NameFormInput() {
    return TextFormField(
      controller: nameController,
      // onSaved: (newValue) => address = newValue,
      minLines: 1,
      maxLines: 2,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kProductNameNullError);
        }
        return;
      },
      // onEditingComplete: () {
      //   print("addressController.text " + addressController.text);
      // },

      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kProductNameNullError);
          return "required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Enter product name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon:
        //     CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField PriceFormInput() {
    return TextFormField(
      controller: priceController,
      // onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kProductPriceError);
        }
        return;
      },
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.allow(RegExp("[0-9.]"))
      ],
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kProductPriceError);
          return "required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Price",
        hintText: "Enter product price",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: kPrimaryColor),
        // ),
        // enabledBorder: InputBorder.none,
        // suffixIcon:
        //     CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField descriptionFormInput() {
    return TextFormField(
      controller: descriptionController,
      // onSaved: (newValue) => description = newValue,
      minLines: 1,
      maxLines: 5,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCityNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCityNullError);
          return "required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Description",
        hintText: "Enter product description",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        // suffixIcon:
        //     CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  Row DropdownBrandCate() {
    return Row(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: getProportionateScreenWidth(5)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Brand: ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButton<String>(
                      value: dropdownBrandValue,
                      icon: const Icon(Icons.arrow_downward),
                      iconSize: 20,
                      elevation: 16,
                      style: const TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                        margin: EdgeInsets.only(
                            right: getProportionateScreenWidth(18)),
                      ),
                      onChanged: (newValue) {
                        setState(() {
                          dropdownBrandValue = newValue!;
                        });
                      },
                      items: listBrand.map((BrandCate value) {
                        return DropdownMenuItem<String>(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          width: getProportionateScreenWidth(14),
        ),
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Category: ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    value: dropdownCateValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black,
                      margin: EdgeInsets.only(
                          right: getProportionateScreenWidth(18)),
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        dropdownCateValue = newValue!;
                      });
                    },
                    items: listCate.map((BrandCate value) {
                      return DropdownMenuItem<String>(
                        value: value.id,
                        child: Text(value.name),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
