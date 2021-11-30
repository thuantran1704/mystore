// ignore_for_file: curly_braces_in_flow_control_structures, import_of_legacy_library_into_null_safe
import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:mystore/components/default_button.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helper/keyboard.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/dashboard/dashboard.dart';
import 'package:mystore/screen/forgot_password/forgot_password_screen.dart';
import 'package:mystore/screen/home/home_screen.dart';
import 'package:mystore/screen/sign_in/components/custom_surfix_icon.dart';
import 'package:mystore/size_config.dart';
import 'package:http/http.dart' as http;

// ignore: use_key_in_widget_constructors
class SignForm extends StatefulWidget {
  @override
  _SignFormState createState() => _SignFormState();
}

class _SignFormState extends State<SignForm> {
  final _formKey = GlobalKey<FormState>();
  late String email;
  TextEditingController emailController = TextEditingController();
  late String password;
  TextEditingController passwordController = TextEditingController();

  bool? remember = false;
  final List<String> errors = [];
  late User user;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  Future<void> login(String email, String password) async {
    await EasyLoading.show(
      status: 'Logining...',
      maskType: EasyLoadingMaskType.black,
    );
    var response = await http.post(Uri.parse("$baseUrl/api/users/login"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body:
            jsonEncode(<String, String>{"email": email, "password": password}));

    if (response.statusCode == 200) {
      user = userFromJson(response.body);
      if (user.role.name.toLowerCase() == "admin") {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DashBoardScreen(
                      user: user,
                    )));
        await EasyLoading.dismiss();
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => HomeScreen(
                      user: user,
                    )));
        await EasyLoading.dismiss();
      }
    } else {
      await EasyLoading.dismiss();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Credentials"),
        ),
      );
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
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          buildEmailFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          buildPasswordFormField(),
          SizedBox(height: getProportionateScreenHeight(30)),
          Row(
            children: [
              Checkbox(
                value: remember,
                activeColor: kPrimaryColor,
                onChanged: (value) {
                  setState(() {
                    remember = value;
                  });
                },
              ),
              const Text("Remember me"),
              const Spacer(),
              GestureDetector(
                onTap: () => Navigator.pushNamed(
                    context, ForgotPasswordScreen.routeName),
                child: const Text(
                  "Forgot Password",
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              )
            ],
          ),
          FormError(errors: errors),
          SizedBox(height: getProportionateScreenHeight(20)),
          DefaultButton(
            text: "Continue",
            press: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                KeyboardUtil.hideKeyboard(context);
                login(emailController.text, passwordController.text);
              }
            },
          ),
        ],
      ),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      obscureText: true,
      onSaved: (newValue) => password = newValue!,
      controller: passwordController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kPassNullError);
        } else if (value.length >= 3) {
          removeError(error: kShortPassError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kPassNullError);
          return "";
        } else if (value.length < 3) {
          addError(error: kShortPassError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Password",
        hintText: "Enter your password",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(svgIcon: "assets/icons/Lock.svg"),
      ),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: emailController,
      onSaved: (newValue) => email = newValue!,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kEmailNullError);
        } else if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: kInvalidEmailError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kEmailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: kInvalidEmailError);
          return "";
        }
        return null;
      },
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter your email",
        // border: OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
        // focusedBorder: UnderlineInputBorder(
        //   borderSide: BorderSide(color: kPrimaryColor),
        // ),
        // enabledBorder: InputBorder.none,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: CustomSurfixIcon(svgIcon: "assets/icons/Mail.svg"),
      ),
    );
  }
}
