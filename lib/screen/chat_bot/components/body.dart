// ignore_for_file: non_constant_identifier_names, import_of_legacy_library_into_null_safe, deprecated_member_use, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:mystore/models/user.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).accentColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(12),
              ),
              child: SizedBox(
                width: SizeConfig.screenWidth * 0.76,
                height: getProportionateScreenHeight(40),
                child: TextFormField(
                  controller: _textController,
                  onFieldSubmitted: _handleSubmitted,
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(20, 8, 20, 0),
                      hintText: "Send a message"),
                ),
              ),
            ),
            Container(
                margin: const EdgeInsets.symmetric(horizontal: 3.5),
                child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      size: 34,
                    ),
                    onPressed: () {
                      if (_textController.text.trim().isNotEmpty) {
                        _handleSubmitted(_textController.text.trim());
                      }
                    })),
          ],
        ),
      ),
    );
  }

  void Response(query) async {
    _textController.clear();
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/mystore-chatbot-24a69c746812.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
    ChatMessage message = ChatMessage(
      text: response.getMessage() ??
          CardDialogflow(response.getListMessage()[0]).title,
      name: "idiot assistant",
      type: false,
    );
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSubmitted(String text) {
    ChatMessage message = ChatMessage(
      text: text,
      name: widget.user.name,
      type: true,
    );
    setState(() {
      _messages.insert(0, message);
    });
    Response(text);
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
            child: ListView.builder(
          padding: EdgeInsets.only(
              left: getProportionateScreenWidth(15),
              right: getProportionateScreenWidth(15)),
          reverse: true,
          itemBuilder: (_, int index) => _messages[index],
          itemCount: _messages.length,
        )),
        const Divider(height: 2.0),
        Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: _buildTextComposer(),
        ),
      ],
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {Key? key, required this.text, required this.name, required this.type})
      : super(key: key);

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(child: Text('B')),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(name),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
            child: Text(
          name[0],
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}
