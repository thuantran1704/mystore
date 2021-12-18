// ignore_for_file: avoid_print, prefer_typing_uninitialized_variables, non_constant_identifier_names, import_of_legacy_library_into_null_safe, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helper/keyboard.dart';
import 'package:mystore/models/brand.dart';
import 'package:mystore/models/images.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/screen/admin/product_list/product_list.dart';
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
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  List<BrandCate> listBrand = [];
  List<BrandCate> listCate = [];

  List<File> images = [];
  List<UploadImage> uploaded = [];

  Future getImage() async {
    try {
      final image = await ImagePicker.pickImage(source: ImageSource.gallery);
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
          // "Content-type": "multipart/form-data"
        }));

    if (response.statusCode == 200) {
      final res = UploadImage.fromJson(response.data);
      uploaded.add(res);
    } else {
      print("Failed to Upload images to Cloud");
    }
  }

  Future<void> createProduct(
    List images,
    String? name,
    String? description,
    double price,
    String? brandId,
    String? cateId,
  ) async {
    List jsonList = [];
    images.map((item) => jsonList.add(item.toJson())).toList();

    var response = await http.post(Uri.parse("$baseUrl/api/products"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "images": jsonList,
          "name": name,
          "description": description,
          "price": price,
          "brand": brandId,
          "category": cateId,
          "countInStock": 0,
        }));

    if (response.statusCode == 201) {
      _showToast("Product created successfully ");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => (ProductListScreen(user: widget.user))));
    } else {
      _showToast("Product created failed");
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

  Future<void> getBrands() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/brands"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        listBrand = brandCateFromJson(response.body);
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
        listCate = brandCateFromJson(response.body);
        dropdownCateValue = listCate[0].id;
        loading2 = false;
      });
    } else {
      throw Exception('Unable to fetch Cate from the REST API');
    }
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
                    left: getProportionateScreenWidth(20),
                    right: getProportionateScreenWidth(15),
                    top: getProportionateScreenHeight(18)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // NameFormInput(),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(.2),
                                blurRadius: 1,
                                spreadRadius: 1,
                                offset: const Offset(3, 2),
                              ),
                            ]),
                        child: NameFormInput(),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.025),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.2),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: const Offset(3, 2),
                                ),
                              ]),
                          child: PriceFormInput()),
                      SizedBox(height: SizeConfig.screenHeight * 0.025),
                      Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.2),
                                  blurRadius: 1,
                                  spreadRadius: 1,
                                  offset: const Offset(3, 2),
                                ),
                              ]),
                          child: descriptionFormInput()),
                      SizedBox(height: SizeConfig.screenHeight * 0.025),
                      DropdownBrandCate(),
                      (errors.isNotEmpty)
                          ? SizedBox(height: SizeConfig.screenHeight * 0.01)
                          : const SizedBox(),
                      FormError(errors: errors),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Product Images:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700)),
                          Container(
                            child: (images.isNotEmpty)
                                ? SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...List.generate(
                                          images.length,
                                          (index) => Padding(
                                            padding: EdgeInsets.only(
                                                right:
                                                    getProportionateScreenWidth(
                                                        12)),
                                            child: Stack(
                                              children: [
                                                Container(
                                                  width: 120,
                                                  height: 120,
                                                  margin: EdgeInsets.only(
                                                      top:
                                                          getProportionateScreenHeight(
                                                              15),
                                                      right:
                                                          getProportionateScreenWidth(
                                                              10)),
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(.2),
                                                          blurRadius: 1,
                                                          spreadRadius: 1,
                                                          offset: const Offset(
                                                              2, 1),
                                                        ),
                                                      ]),
                                                  child: Image.file(
                                                    images[index],
                                                  ),
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: -3,
                                                  child: InkWell(
                                                    splashColor: Colors.red,
                                                    onTap: () {
                                                      setState(() {
                                                        images.removeAt(index);
                                                        uploaded
                                                            .removeAt(index);
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons.cancel_rounded,
                                                        size: 26,
                                                        color: Colors.deepOrange
                                                            .shade500),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                            width:
                                                getProportionateScreenWidth(5)),
                                        InkWell(
                                          onTap: () {
                                            getImage();
                                          },
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                : InkWell(
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
                                  width: SizeConfig.screenWidth * 0.8,
                                  child: DefaultButton(
                                    text: "Create Product",
                                    press: () {
                                      if (_formKey.currentState!.validate()) {
                                        _formKey.currentState!.save();
                                        KeyboardUtil.hideKeyboard(context);
                                        if (uploaded.isEmpty) {
                                          _showToast(
                                              "Please add at least an image for this product!");
                                        } else {
                                          createProduct(
                                            uploaded,
                                            nameController.text,
                                            descriptionController.text,
                                            double.parse(priceController.text),
                                            dropdownBrandValue.toString(),
                                            dropdownCateValue.toString(),
                                          );
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: SizeConfig.screenHeight * 0.02),
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
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
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
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
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
          removeError(error: kProductDescriptionNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kProductDescriptionNullError);
          return "required";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Description",
        hintText: "Enter product description",
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.2),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(3, 2),
                        ),
                      ]),
                  child: DropdownButton<String>(
                    value: dropdownBrandValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black45,
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
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(.2),
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(3, 2),
                        ),
                      ]),
                  child: DropdownButton<String>(
                    value: dropdownCateValue,
                    icon: const Icon(Icons.arrow_downward),
                    iconSize: 20,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 2,
                      color: Colors.black45,
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
