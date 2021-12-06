// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:mystore/components/no_account_text.dart';
import 'package:mystore/screen/sign_in/components/sign_form.dart';
import 'package:mystore/components/social_card.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  // bool _isLoggedIn = false;
  // Map _userObj = {};

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.04),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: getProportionateScreenWidth(28),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Sign in with your email and password  \nor continue with social media",
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                SignForm(),
                SizedBox(height: SizeConfig.screenHeight * 0.08),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SocialCard(
                      asset: "assets/icons/google-icon.svg",
                      press: () {},
                    ),
                    SocialCard(
                      asset: "assets/icons/facebook-2.svg",
                      press: () {
                        // FacebookAuth.instance.login(permissions: [
                        //   "public_profile",
                        //   "email"
                        // ]).then((value) {
                        //   FacebookAuth.instance.getUserData().then((userData) {
                        //     setState(() {
                        //       print("userData : " + userData.toString());
                        //       _isLoggedIn = true;
                        //       _userObj = userData;
                        //       print("_userObj : " + _userObj.toString());
                        //     });
                        //   });
                        // });
                      },
                    ),
                    SocialCard(
                      asset: "assets/icons/twitter.svg",
                      press: () {},
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(20)),
                const NoAccountText(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
