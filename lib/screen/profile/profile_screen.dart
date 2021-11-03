import 'package:flutter/material.dart';
import 'package:mystore/components/coustom_bottom_nav_bar.dart';
import 'package:mystore/enums.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/home/home_screen.dart';

import 'components/body.dart';

class ProfileScreen extends StatefulWidget {
  static String routeName = "/profile";

  ProfileScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // final arguments =
    //     ModalRoute.of(context)!.settings.arguments as ProfileArguments;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(
        user: widget.user,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.profile,
        currentPage: 2,
        user: widget.user,
      ),
    );
  }
}
