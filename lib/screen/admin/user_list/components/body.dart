import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mystore/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/size_config.dart';

class Body extends StatefulWidget {
  const Body({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<ManagerUser> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  late final SlidableController slidableController;

  Future<void> getUserList() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/users"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}'
        });

    if (response.statusCode == 200) {
      setState(() {
        list = managerUserFromJson(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch users from the REST API');
    }
  }

  Future<void> disableUser(String id) async {
    setState(() {
      loading = true;
    });
    final response =
        await http.put(Uri.parse("$baseUrl/api/users/disable/$id"));

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch users from the REST API');
    }
  }

  Future<void> enableUser(String id) async {
    setState(() {
      loading = true;
    });
    final response = await http.put(Uri.parse("$baseUrl/api/users/enable/$id"));

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch users from the REST API');
    }
  }

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    getUserList();
    super.initState();
  }

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        Container(
          child: loading
              ? Padding(
                  padding:
                      EdgeInsets.only(top: getProportionateScreenHeight(20)),
                  child: const Center(child: CircularProgressIndicator()),
                )
              : list.isEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("List user is empty"),
                      ],
                    )
                  : RefreshIndicator(
                      onRefresh: getUserList,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(
                            horizontal: getProportionateScreenWidth(15)),
                        itemCount: list.length,
                        itemBuilder: (context, index) => Padding(
                          padding: EdgeInsets.only(
                            top: getProportionateScreenHeight(12),
                          ),
                          child: Slidable(
                            key: Key(list[index].id.toString()),
                            controller: slidableController,
                            direction: Axis.horizontal,
                            actionPane: const SlidableScrollActionPane(),
                            actionExtentRatio: 0.25,
                            child: VerticalListItem(
                              user: list[index],
                            ),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'Edit',
                                color: Colors.blue,
                                icon: Icons.edit,
                                onTap: () {
                                  // Navigator.pushReplacement(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         builder: (context) => EditProductScreen(
                                  //               user: widget.user,
                                  //               product: list[index],
                                  //             )));
                                },
                              ),
                              (list[index].isDisable == false)
                                  ? IconSlideAction(
                                      caption: 'Disable',
                                      color: const Color(0xFFFFE6E6),
                                      icon: Icons.disabled_by_default_sharp,
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text("Confirm"),
                                                  content: const Text(
                                                      "Are you sure you want to Disable this User?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'No'),
                                                      child: const Text('No'),
                                                    ),
                                                    TextButton(
                                                        child:
                                                            const Text('Yes'),
                                                        onPressed: () => {
                                                              Navigator.pop(
                                                                  context,
                                                                  'Yes'),
                                                              disableUser(
                                                                  list[index]
                                                                      .id),
                                                              setState(() {
                                                                list[index]
                                                                        .isDisable =
                                                                    true;
                                                              }),
                                                            }),
                                                  ],
                                                ));
                                      },
                                    )
                                  : IconSlideAction(
                                      caption: 'Enable',
                                      color: Colors.greenAccent.shade100,
                                      icon: Icons.check_box,
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) =>
                                                AlertDialog(
                                                  title: const Text("Confirm"),
                                                  content: const Text(
                                                      "Are you sure you want to Enable this User?"),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.pop(
                                                              context, 'No'),
                                                      child: const Text('No'),
                                                    ),
                                                    TextButton(
                                                        child:
                                                            const Text('Yes'),
                                                        onPressed: () => {
                                                              Navigator.pop(
                                                                  context,
                                                                  'Yes'),
                                                              enableUser(
                                                                  list[index]
                                                                      .id),
                                                              setState(() {
                                                                list[index]
                                                                        .isDisable =
                                                                    false;
                                                              }),
                                                            }),
                                                  ],
                                                ));
                                      },
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
        ),
        UserTabViewByIsDisable(
          isDisable: false,
          user: widget.user,
        ),
        UserTabViewByIsDisable(
          isDisable: true,
          user: widget.user,
        ),
      ],
    );
  }
}

class VerticalListItem extends StatelessWidget {
  const VerticalListItem({Key? key, required this.user}) : super(key: key);

  final ManagerUser user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Slidable.of(context)?.renderingMode == SlidableRenderingMode.none
              ? Slidable.of(context)?.open()
              : Slidable.of(context)?.close(),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.grey.shade200,
                blurRadius: 2.0,
                spreadRadius: 1.0),
          ],
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(14.0),
        ),
        // color: Colors.red,
        child: Padding(
          padding: EdgeInsets.only(left: getProportionateScreenWidth(14)),
          child: UserItemCard(
            user: user,
          ),
        ),
      ),
    );
  }
}

class UserItemCard extends StatefulWidget {
  const UserItemCard({
    Key? key,
    required this.user,
  }) : super(key: key);

  final ManagerUser user;

  @override
  State<UserItemCard> createState() => _UserItemCardState();
}

class _UserItemCardState extends State<UserItemCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user.name, // product name here
                style: const TextStyle(fontSize: 16, color: Colors.black),
                maxLines: 2,
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text.rich(
                    TextSpan(
                      text: widget.user.email,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text.rich(
                    (!widget.user.isDisable)
                        ? const TextSpan(
                            text: "Being used",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.lightGreen),
                          )
                        : const TextSpan(
                            text: "Disable",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.redAccent),
                          ),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ],
    );
  }
}

class UserTabViewByIsDisable extends StatefulWidget {
  const UserTabViewByIsDisable(
      {Key? key, required this.isDisable, required this.user})
      : super(key: key);
  final bool isDisable;
  final User user;
  @override
  _UserTabViewByIsDisableState createState() => _UserTabViewByIsDisableState();
}

class _UserTabViewByIsDisableState extends State<UserTabViewByIsDisable> {
  List<ManagerUser> list = [];
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  late final SlidableController slidableController;

  Future<void> getUserList() async {
    setState(() {
      loading = true;
    });
    final response = await http.post(Uri.parse("$baseUrl/api/users/isdisable"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({"isDisable": widget.isDisable}));

    if (response.statusCode == 200) {
      setState(() {
        list = managerUserFromJson(response.body);
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch users from the REST API');
    }
  }

  Future<void> disableUser(String id) async {
    setState(() {
      loading = true;
    });
    final response =
        await http.put(Uri.parse("$baseUrl/api/users/disable/$id"));

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch users from the REST API');
    }
  }

  Future<void> enableUser(String id) async {
    setState(() {
      loading = true;
    });
    final response = await http.put(Uri.parse("$baseUrl/api/users/enable/$id"));

    if (response.statusCode == 200) {
      setState(() {
        loading = false;
      });
    } else {
      throw Exception('Unable to fetch users from the REST API');
    }
  }

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    getUserList();
    super.initState();
  }

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Padding(
              padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
              child: const Center(child: CircularProgressIndicator()),
            )
          : list.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text("List user is empty"),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: getUserList,
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                        horizontal: getProportionateScreenWidth(15)),
                    itemCount: list.length,
                    itemBuilder: (context, index) => Padding(
                      padding: EdgeInsets.only(
                        top: getProportionateScreenHeight(12),
                      ),
                      child: Slidable(
                        key: Key(list[index].id.toString()),
                        controller: slidableController,
                        direction: Axis.horizontal,
                        actionPane: const SlidableScrollActionPane(),
                        actionExtentRatio: 0.25,
                        child: VerticalListItem(
                          user: list[index],
                        ),
                        secondaryActions: <Widget>[
                          IconSlideAction(
                            caption: 'Edit',
                            color: Colors.blue,
                            icon: Icons.edit,
                            onTap: () {
                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => EditProductScreen(
                              //               user: widget.user,
                              //               product: list[index],
                              //             )));
                            },
                          ),
                          (list[index].isDisable == false)
                              ? IconSlideAction(
                                  caption: 'Disable',
                                  color: const Color(0xFFFFE6E6),
                                  icon: Icons.disabled_by_default_sharp,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text("Confirm"),
                                              content: const Text(
                                                  "Are you sure you want to Disable this User?"),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'No'),
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () => {
                                                          Navigator.pop(
                                                              context, 'Yes'),
                                                          disableUser(
                                                              list[index].id),
                                                          setState(() {
                                                            list.removeAt(
                                                                index);
                                                          }),
                                                        }),
                                              ],
                                            ));
                                  },
                                )
                              : IconSlideAction(
                                  caption: 'Enable',
                                  color: Colors.greenAccent.shade100,
                                  icon: Icons.check_box,
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text("Confirm"),
                                              content: const Text(
                                                  "Are you sure you want to Enable this User? "),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                          context, 'No'),
                                                  child: const Text('No'),
                                                ),
                                                TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () => {
                                                          Navigator.pop(
                                                              context, 'Yes'),
                                                          enableUser(
                                                              list[index].id),
                                                          setState(() {
                                                            list.removeAt(
                                                                index);
                                                          }),
                                                        }),
                                              ],
                                            ));
                                  },
                                ),
                        ],
                      ),
                    ),
                  ),
                ),
    );
  }
}
