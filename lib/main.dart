import 'package:flutter/material.dart';
import 'package:mystore/routes.dart';
import 'package:mystore/screen/spash/splash_screen.dart';
import 'package:mystore/theme.dart';

void main() => runApp(MyApp());

// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Store',
      theme: theme(),
      // home: const SplashScreen(),
      initialRoute: SplashScreen.routeName,
      routes: routes,
    );
  }
}
