import 'package:auto_size_text_field/auto_size_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/components/default_button.dart';
import 'package:mystore/components/form_error.dart';
import 'package:mystore/constants.dart';
import 'package:mystore/helper/keyboard.dart';
import 'package:mystore/models/reciept.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/admin/receipt_checkout/receipt_checkout.dart';
import 'package:mystore/screen/admin/receipt_list/receipt_list.dart';
import 'package:mystore/size_config.dart';

class ReceiptCartScreen extends StatefulWidget {
  const ReceiptCartScreen({Key? key, required this.user}) : super(key: key);
  final User user;

  @override
  _ReceiptCartScreenState createState() => _ReceiptCartScreenState();
}

class _ReceiptCartScreenState extends State<ReceiptCartScreen> {
  List<Cart> list = [];
  List<SuplierInfo> listSuplier = [];
  double total = 0;

  int index = 0;

  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  String dropdownSuplierValue = "";
  final List<String> errors = [];

  List<TextEditingController> myQtyController = [];
  List<TextEditingController> myPriceController = [];

  void calSum(List<Cart> list) {
    total = 0;
    for (int i = 0; i < list.length; i++) {
      total = total + (list[i].price * list[i].qty);
    }
  }

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
  }

  Future<void> getSuplierList() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/supliers"),
        headers: {"Accept": "application/json"});

    if (response.statusCode == 200) {
      setState(() {
        listSuplier = suplierInfoFromJson(response.body);
        dropdownSuplierValue = listSuplier[0].id;

        loading = false;
      });
    } else {
      throw Exception('Unable to fetch supliers from the REST API');
    }
  }

  Future<void> getReceiptCart() async {
    setState(() {
      loading = true;
    });
    final response = await http.get(Uri.parse("$baseUrl/api/users/cart/mycart"),
        headers: <String, String>{
          'Authorization': 'Bearer ${widget.user.token}',
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
      setState(() {
        list = parseCart(response.body);
        total = 0;
        for (int i = 0; i < list.length; i++) {
          TextEditingController priceController = TextEditingController();
          TextEditingController qtyController = TextEditingController();

          priceController.text = list[i].price.toString();
          qtyController.text = list[i].qty.toString();

          myPriceController.add(priceController);
          myQtyController.add(qtyController);

          total = total + (list[i].price * list[i].qty);
        }

        loading = false;
      });
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  Future<void> removeCartItem(String productId, String token) async {
    setState(() {
      loading = true;
    });
    final response = await http.delete(
        Uri.parse("$baseUrl/api/users/cart/$productId/remove"),
        headers: <String, String>{
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json; charset=UTF-8',
        });

    if (response.statusCode == 200) {
    } else {
      _showToast("Remove Failed");

      throw Exception('Unable to fetch products from the REST API');
    }
  }

  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getReceiptCart();
    getSuplierList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroudColor,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Your Receipt Cart",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ReceiptListScreen(user: widget.user)),
                  (Route<dynamic> route) => false,
                )),
      ),
      // ======================= body =======================//
      body: Container(
        child: loading
            ? Padding(
                padding: EdgeInsets.only(top: getProportionateScreenHeight(20)),
                child: const Center(child: CircularProgressIndicator()),
              )
            : list.isEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text("Your Receipt cart is empty"),
                        ],
                      ),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: getReceiptCart,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      padding: EdgeInsets.symmetric(
                          horizontal: getProportionateScreenWidth(20)),
                      itemCount: list.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Dismissible(
                          key: Key(list[index].product.toString()),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE6E6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              children: [
                                const Spacer(),
                                SvgPicture.asset("assets/icons/Trash.svg"),
                              ],
                            ),
                          ),
                          onDismissed: (direction) {
                            setState(() {
                              removeCartItem(list[index].product.toString(),
                                  widget.user.token);
                              loading = false;

                              list.removeAt(index);
                              calSum(list);
                            });
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: getProportionateScreenWidth(88),
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade400,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Image.network(//product image here
                                        list[index].image),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      list[index].name,
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      maxLines: 2,
                                    ),
                                    // const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Padding(
                                              padding: EdgeInsets.only(top: 2),
                                              child: Text.rich(
                                                TextSpan(
                                                  text: "\$",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  getProportionateScreenWidth(
                                                      60),
                                              height:
                                                  getProportionateScreenWidth(
                                                      33),
                                              child: TextFormField(
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 15),
                                                keyboardType:
                                                    TextInputType.number,
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp("[0-9.]")),
                                                  LengthLimitingTextInputFormatter(
                                                      6),
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Colors.black)),
                                                  enabledBorder:
                                                      InputBorder.none,
                                                  focusedBorder:
                                                      InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(
                                                          left: 10, bottom: 12),
                                                ),
                                                controller:
                                                    myPriceController[index],
                                                onChanged: (value) {
                                                  if (value.isNotEmpty) {
                                                    setState(() {
                                                      myPriceController[index]
                                                          .text = value;
                                                      list[index].price =
                                                          double.parse(
                                                              myPriceController[
                                                                      index]
                                                                  .text);
                                                      calSum(list);
                                                    });
                                                  } else {
                                                    setState(() {
                                                      myPriceController[index]
                                                          .text = "1";
                                                      list[index].price =
                                                          double.parse(
                                                              myPriceController[
                                                                      index]
                                                                  .text);
                                                      calSum(list);
                                                    });
                                                  }
                                                  return;
                                                },
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    addError(
                                                        error:
                                                            kProductPriceError);
                                                    return "Required";
                                                  } else if (double.parse(
                                                          value) <=
                                                      list[index].price) {
                                                    addError(
                                                        error:
                                                            kProductSalePriceError);
                                                    return "Invalid";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  iconSize: 16.0,
                                                  icon:
                                                      const Icon(Icons.remove),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (list[index].qty > 1) {
                                                        list[index].qty -= 1;
                                                        myQtyController[index]
                                                                .text =
                                                            list[index]
                                                                .qty
                                                                .toString();
                                                        calSum(list);
                                                      }
                                                    });
                                                  },
                                                ),
                                                SizedBox(
                                                  width:
                                                      getProportionateScreenWidth(
                                                          35),
                                                  height:
                                                      getProportionateScreenWidth(
                                                          33),
                                                  child: AutoSizeTextField(
                                                    minFontSize: 14,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    inputFormatters: <
                                                        TextInputFormatter>[
                                                      FilteringTextInputFormatter
                                                          .allow(
                                                              RegExp(r'[0-9]')),
                                                      LengthLimitingTextInputFormatter(
                                                          3),
                                                    ],
                                                    decoration: InputDecoration(
                                                      border: OutlineInputBorder(
                                                          borderSide: BorderSide(
                                                              color: Colors
                                                                  .green
                                                                  .shade900)),
                                                      enabledBorder:
                                                          InputBorder.none,
                                                      focusedBorder:
                                                          InputBorder.none,
                                                      contentPadding:
                                                          const EdgeInsets.only(
                                                              left: 11,
                                                              bottom: 12),
                                                    ),
                                                    controller:
                                                        myQtyController[index],
                                                    onChanged: (value) {
                                                      if (value.isNotEmpty) {
                                                        setState(() {
                                                          myQtyController[index]
                                                              .text = value;
                                                          list[index].qty =
                                                              int.parse(
                                                                  myQtyController[
                                                                          index]
                                                                      .text);
                                                          calSum(list);
                                                        });
                                                      } else {
                                                        setState(() {
                                                          myQtyController[index]
                                                              .text = "1";
                                                          list[index].qty =
                                                              int.parse(
                                                                  myQtyController[
                                                                          index]
                                                                      .text);
                                                          calSum(list);
                                                        });
                                                      }
                                                      return;
                                                    },
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 16.0,
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () {
                                                    setState(() {
                                                      list[index].qty += 1;
                                                      myQtyController[index]
                                                              .text =
                                                          list[index]
                                                              .qty
                                                              .toString();
                                                      calSum(list);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    FormError(errors: errors),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
      ),
      //================================================================//
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(12),
              horizontal: getProportionateScreenWidth(30),
            ),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -15),
                  blurRadius: 20,
                  color: const Color(0xFFDADADA).withOpacity(0.15),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                left: getProportionateScreenWidth(5)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Suplier : ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18, vertical: 2),
                                  decoration: BoxDecoration(
                                      color: Colors.white70,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: DropdownButton<String>(
                                    value: dropdownSuplierValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    iconSize: 20,
                                    elevation: 20,
                                    style: const TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 1,
                                      color: Colors.black,
                                      margin: EdgeInsets.only(
                                          right:
                                              getProportionateScreenWidth(18)),
                                    ),
                                    onChanged: (newValue) {
                                      setState(() {
                                        dropdownSuplierValue = newValue!;
                                        index = listSuplier.indexWhere(
                                            (element) =>
                                                element.id ==
                                                dropdownSuplierValue);
                                      });
                                    },
                                    items: listSuplier.map((SuplierInfo value) {
                                      return DropdownMenuItem<String>(
                                        value: value.id,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(10)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(
                          text: "Total Items:\n",
                          children: [
                            TextSpan(
                              text: "\$${total.toStringAsFixed(2)}",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: DefaultButton(
                          text: "Check Out",
                          press: () => {
                            if (list.isNotEmpty)
                              {
                                KeyboardUtil.hideKeyboard(context),
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RecieptCheckOutScreen(
                                              list: list,
                                              user: widget.user,
                                              total: total,
                                              suplier: listSuplier[index],
                                            )))
                              }
                            else
                              _showToast("Please add product first")
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // TextFormField buildPriceFormField(int index, double salePrice) {
  //   return TextFormField(
  //     obscureText: true,
  //     controller: myController[index],
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: kProductPriceError);
  //       } else if (double.parse(value) > salePrice) {
  //         removeError(error: kProductSalePriceError);
  //       }
  //       return;
  //     },
  //     validator: (value) {
  //       if (value!.isEmpty) {
  //         addError(error: kProductPriceError);
  //         return "Required";
  //       } else if (double.parse(value) <= salePrice) {
  //         addError(error: kProductSalePriceError);
  //         return "Invalid";
  //       }
  //       return null;
  //     },
  //   );
  // }
}
