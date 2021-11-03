import 'package:flutter/material.dart';
import 'package:mystore/components/coustom_bottom_nav_bar.dart';
import 'package:mystore/enums.dart';
import 'package:mystore/models/user.dart';
import 'components/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.user}) : super(key: key);
  final User user;
  static String routeName = "/home";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // final arguments =
    //     ModalRoute.of(context)!.settings.arguments as ProfileArguments;

    return Scaffold(
      body: Body(
        user: widget.user,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.home,
        currentPage: 1,
        user: widget.user,
      ),
    );
  }
}

// class ProfileArguments {
//   final User user;

//   ProfileArguments({required this.user});
// }
