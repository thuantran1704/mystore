// ignore_for_file: import_of_legacy_library_into_null_safe

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mystore/components/custom_surfix_icon.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/home/home_screen.dart';
// import 'package:mystore/screen/otp/otp_screen.dart';
import 'package:mystore/screen/sign_in/components/custom_surfix_icon.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

class Body extends StatefulWidget {
  const Body({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);
  final String email;
  final String password;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  final List<String> errors = [];
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

  static const baseUrl = "https://mystore-backend.herokuapp.com";
  late User user;

  Future<void> registerUser(
    String name,
    String email,
    String password,
    String phone,
    String address,
    String city,
    String postalCode,
    String country,
  ) async {
    var response = await http.post(Uri.parse("$baseUrl/api/users"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "role": "614e9f1d76d3aee39dee0bed",
          "name": name,
          "email": email,
          "password": password,
          "phone": phone,
          "userAddress": ({
            "address": address,
            "city": city,
            "country": country,
            "postalCode": postalCode,
          })
        }));
    if (response.statusCode == 201) {
      user = userFromJson(response.body);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
    } else {
      _showToast("User created failed");
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
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.03),
                  Text("Complete Profile", style: headingStyle),
                  const Text(
                    "Complete your details or continue  \nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  Column(
                    children: [
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
                      SizedBox(height: getProportionateScreenHeight(40)),
                      DefaultButton(
                        text: "Continue",
                        press: () {
                          if (_formKey.currentState!.validate()) {
                            registerUser(
                                nameController.text,
                                widget.email,
                                widget.password,
                                phoneController.text,
                                addressController.text,
                                cityController.text,
                                postalCodeController.text,
                                countryController.text);
                            // Navigator.pushNamed(context, OtpScreen.routeName);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(30)),
                  Text(
                    "By continuing your confirm that you agree \nwith our Term and Condition",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.caption,
                  ),
                ],
              ),
            ),
          ),
        ),
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
