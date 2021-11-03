// ignore_for_file: prefer_const_constructors

import 'package:flutter/widgets.dart';
// import 'package:mystore/screen/cart/cart_screen.dart';
import 'package:mystore/screen/complete_profile/complete_profile_screen.dart';
import 'package:mystore/screen/product_details/details_screen.dart';
import 'package:mystore/screen/forgot_password/forgot_password_screen.dart';
import 'package:mystore/screen/home/home_screen.dart';
import 'package:mystore/screen/otp/otp_screen.dart';
import 'package:mystore/screen/profile/profile_screen.dart';
import 'package:mystore/screen/sign_in/sign_in_screen.dart';
import 'package:mystore/screen/sign_up/sign_up_screen.dart';
import 'package:mystore/screen/spash/splash_screen.dart';

final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => SplashScreen(),
  SignInScreen.routeName: (context) => SignInScreen(),
  ForgotPasswordScreen.routeName: (context) => ForgotPasswordScreen(),
  CompleteProfileScreen.routeName: (context) => CompleteProfileScreen(),
  OtpScreen.routeName: (context) => OtpScreen(),
  SignUpScreen.routeName: (context) => SignUpScreen(),
  DetailsScreen.routeName: (context) => DetailsScreen(),
  // LoginSuccessScreen.routeName: (context) => LoginSuccessScreen(),
  // HomeScreen.routeName: (context) => HomeScreen(),
  // CartScreen.routeName: (context) => CartScreen(),
  // ProfileScreen.routeName: (context) => ProfileScreen(),
};
