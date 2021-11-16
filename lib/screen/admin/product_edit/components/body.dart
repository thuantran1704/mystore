import 'dart:convert';
import 'dart:io';

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
import 'package:mystore/models/product.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/product_list/product_list.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart' as dio;
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user, required this.product})
      : super(key: key);
  final User user;
  final Product product;
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

  Future<void> editProduct(
    List images,
    String? name,
    String? description,
    double price,
    String? brandId,
    String? cateId,
  ) async {
    List jsonList = [];
    images.map((item) => jsonList.add(item.toJson())).toList();

    var response =
        await http.put(Uri.parse("$baseUrl/api/products/${widget.product.id}"),
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
            }));

    if (response.statusCode == 200) {
      _showToast("Product edited successfully ");
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => (ProductListScreen(user: widget.user))));
    } else {
      _showToast("Product edited failed");
    }
  }

  Future initValue() async {
    try {
      setState(() {
        nameController.text = widget.product.name;
        descriptionController.text = widget.product.description;
        priceController.text = widget.product.price.toString();
        dropdownBrandValue = widget.product.brand.brand;
        dropdownCateValue = widget.product.category.category;

        for (int i = 0; i < widget.product.images.length; i++) {
          final item = UploadImage.fromJson(widget.product.images[i].toJson());
          uploaded.add(item);
        }
      });
    } catch (e) {
      print("Failed to pick image : $e");
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
        // dropdownBrandValue = listBrand[0].id;
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
        // dropdownCateValue = listCate[0].id;
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
    initValue();
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
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
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
