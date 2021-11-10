// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/brand.dart';
import 'package:mystore/models/images.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  var loading = false;
  var loading2 = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  var dropdownBrandValue;
  var dropdownCateValue;

  final _formKey = GlobalKey<FormState>();
  final List<String> errors = [];
  TextEditingController addressController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Brand> listBrand = [];
  List<Brand> listCate = [];

  List<File> images = [];
  List<UploadImage> uploaded = [];

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        images.add(imageTemporary);
        upload(imageTemporary);
      });
    } on PlatformException catch (e) {
      print("Failed to pick image : $e");
    }
  }

  Future upload(File file) async {
    String fileName = file.path.split("/").last;
    var fileImage = await dio.MultipartFile.fromFile(file.path,
        filename: fileName,
        contentType: MediaType(
          "image",
          "png",
        ));
    dio.FormData formData =
        dio.FormData.fromMap({"file": fileImage, "type": "image/png"});
    var dioRequest = dio.Dio();
    var response = await dioRequest.post(
        "https://mystore-backend.herokuapp.com/api/upload",
        data: formData,
        options: dio.Options(headers: {
          'Authorization': 'Bearer ${widget.user.token}',
          "Content-type": "multipart/form-data"
        }));

    if (response.statusCode == 200) {
      final res = UploadImage.fromJson(response.data);

      uploaded.add(res);
    } else {}
  }

  Future<void> getBrands() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/brands"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        listBrand = brandFromJson(response.body);
        dropdownBrandValue = listBrand[0].id;
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch brands from the REST API');
    }
  }

  Future<void> getCate() async {
    setState(() {
      loading2 = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/categories"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        listCate = brandFromJson(response.body);
        dropdownCateValue = listCate[0].id;
        loading2 = false;
      });
    } else {
      throw Exception('Unable to fetch Cate from the REST API');
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({required String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  void initState() {
    getBrands();
    getCate();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (loading && loading2)
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
                        children: [
                          const Text("Product Images:"),
                          Container(
                            child: (images.isNotEmpty)
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...List.generate(
                                          images.length,
                                          (index) => SizedBox(
                                            width: 100,
                                            height: 100,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.file(
                                                images[index],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width: getProportionateScreenWidth(
                                                10)),
                                        InkWell(
                                          onTap: () {
                                            getImage();
                                          },
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          child: SvgPicture.asset(
                                            "assets/icons/Add_image.svg",
                                            height: 100,
                                            width: 100,
                                            color: Colors.lightBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      getImage();
                                    },
                                    borderRadius: BorderRadius.circular(20),
                                    child: SvgPicture.asset(
                                      "assets/icons/Add_image.svg",
                                      height: 100,
                                      width: 100,
                                      color: Colors.lightBlue,
                                    ),
                                  ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  TextFormField NameFormInput() {
    return TextFormField(
      controller: addressController,
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
      maxLines: 3,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Brand: ",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                    items: listBrand.map((Brand value) {
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
                  style: TextStyle(color: Colors.black, fontSize: 16),
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
                    items: listCate.map((Brand value) {
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
