import 'package:flutter/material.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/user_edit/components/body.dart';
import 'package:mystore/screen/admin/user_list/user_list.dart';

class EditUserScreen extends StatelessWidget {
  const EditUserScreen({Key? key, required this.user, required this.userEdit})
      : super(key: key);
  final User user;
  final ManagerUser userEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Edit User",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => UserListScreen(user: user)),
                  (Route<dynamic> route) => false,
                )),
      ),
      body: Body(user: user, userEdit: userEdit),
    );
  }
}
