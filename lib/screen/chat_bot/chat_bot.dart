import 'package:flutter/material.dart';
import 'package:mystore/components/coustom_bottom_nav_bar.dart';
import 'package:mystore/enums.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/chat_bot/components/body.dart';

class ChatBotScreen extends StatefulWidget {
  const ChatBotScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Chat",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Body(
        user: widget.user,
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedMenu: MenuState.chat,
        currentPage: 2,
        user: widget.user,
      ),
    );
  }
}
