import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/components/custom_surfix_icon.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/my_account/my_account_screen.dart';
import 'package:mystore/screen/sign_in/components/custom_surfix_icon.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  final List<String> errors = [];
  String? email;
  TextEditingController emailController = TextEditingController();

  String? name;
  TextEditingController nameController = TextEditingController();

  String? phone;
  TextEditingController phoneController = TextEditingController();

  String? address;
  TextEditingController addressController = TextEditingController();

  String? city;
  TextEditingController cityController = TextEditingController();

  String? postalCode;
  TextEditingController postalCodeController = TextEditingController();

  String? country;
  TextEditingController countryController = TextEditingController();
  late User user;

  static const baseUrl = "https://mystore-backend.herokuapp.com";
  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
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

  void initScreen() {
    emailController = TextEditingController(text: widget.user.email);
    nameController = TextEditingController(text: widget.user.name);
    phoneController = TextEditingController(text: widget.user.phone);
    addressController =
        TextEditingController(text: widget.user.userAddress.address);
    cityController = TextEditingController(text: widget.user.userAddress.city);
    countryController =
        TextEditingController(text: widget.user.userAddress.country);
    postalCodeController =
        TextEditingController(text: widget.user.userAddress.postalCode);
  }

  Future<void> updateUser(
    String name,
    String phone,
    String address,
    String city,
    String postalCode,
    String country,
  ) async {
    var response = await http.put(Uri.parse("$baseUrl/api/users/profile"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "name": name,
          "phone": phone,
          "userAddress": ({
            "address": address,
            "city": city,
            "country": country,
            "postalCode": postalCode,
          })
        }));
    if (response.statusCode == 200) {
      user = userFromJson(response.body);
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => MyAccountScreen(user: user)));
    } else {
      _showToast("User created failed");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initScreen();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: 300,
            child: Stack(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: Image.asset(
                    "assets/images/pd3.jpg",
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment(0, 0.8),
                  child: MaterialButton(
                    minWidth: 0,
                    elevation: 0.5,
                    color: Colors.white,
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: kPrimaryColor,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  emailTextFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  nameTextFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  buildPhoneNumberFormField(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  addressFormInput(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  cityFormInput(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  countryFormInput(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  postalCodeFormInput(),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  FormError(errors: errors),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  MaterialButton(
                    child: Text(
                      "Update",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    color: kPrimaryColor,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        updateUser(
                            nameController.text,
                            phoneController.text,
                            addressController.text,
                            cityController.text,
                            postalCodeController.text,
                            countryController.text);
                      }
                    },
                    textColor: Colors.white,
                    padding: EdgeInsets.only(
                        top: getProportionateScreenWidth(14),
                        bottom: getProportionateScreenWidth(14)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TextFormField emailTextFormField() {
    return TextFormField(
      readOnly: true,
      // enabled: false,
      onSaved: (newValue) => email = newValue,
      controller: emailController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "Required Value";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your Email",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField nameTextFormField() {
    return TextFormField(
      onSaved: (newValue) => name = newValue,
      controller: nameController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kNamelNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kNamelNullError);
          return "Required Value";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Name",
        hintText: "Enter your name",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/User.svg"),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      keyboardType: TextInputType.phone,
      controller: phoneController,
      onSaved: (newValue) => phone = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPhoneNumberNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPhoneNumberNullError);
          return "Required Value";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Phone Number",
        hintText: "Enter your phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurffixIcon(svgIcon: "assets/icons/Phone.svg"),
      ),
    );
  }

  TextFormField addressFormInput() {
    return TextFormField(
      controller: addressController,
      onSaved: (newValue) => address = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kAddressNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kAddressNullError);
          return "Required Value";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Address",
        hintText: "Enter your Address",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField cityFormInput() {
    return TextFormField(
      controller: cityController,
      onSaved: (newValue) => city = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCityNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCityNullError);
          return "Required Value";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "City",
        hintText: "Enter your City",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField countryFormInput() {
    return TextFormField(
      controller: countryController,
      onSaved: (newValue) => country = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kCountryNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kCountryNullError);
          return "Required Value";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Country",
        hintText: "Enter your Country",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }

  TextFormField postalCodeFormInput() {
    return TextFormField(
      controller: postalCodeController,
      onSaved: (newValue) => postalCode = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPostalCodeNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPostalCodeNullError);
          return "Required Value";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "PostalCode",
        hintText: "Enter your PostalCode",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon:
            CustomSurfixIcon(svgIcon: "assets/icons/Location point.svg"),
      ),
    );
  }
}
