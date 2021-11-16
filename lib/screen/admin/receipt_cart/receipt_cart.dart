import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:mystore/constants.dart';
import 'package:mystore/models/user.dart';
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
  var loading = false;
  final baseUrl = "https://mystore-backend.herokuapp.com";

  final List<String> errors = [];

  final _formKey = GlobalKey<FormState>();
  late String price;
  TextEditingController priceController = TextEditingController();
  late String qty;
  TextEditingController qtyController = TextEditingController();

  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        fontSize: 15,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_LONG,
        timeInSecForIosWeb: 1);
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
                    children: const [
                      Text("Your Receipt Cart is empty"),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: getReceiptCart,
                    child: ListView.builder(
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
                                      list[index].name, // product name here
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.black),
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Text.rich(
                                        //   TextSpan(
                                        //     text:
                                        //         "\$${list[index].price.toString()}",
                                        //     style: const TextStyle(
                                        //         fontWeight: FontWeight.w600),
                                        //   ),
                                        // ),
                                        buildPriceFormField(list[index].price),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(
                                                  iconSize: 18.0,
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  icon:
                                                      const Icon(Icons.remove),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (list[index].qty > 1) {
                                                        list[index].qty -= 1;
                                                      }
                                                    });
                                                  },
                                                ),
                                                Text(
                                                  "${list[index].qty}",
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                IconButton(
                                                  iconSize: 18.0,
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  icon: const Icon(Icons.add),
                                                  onPressed: () {
                                                    setState(() {
                                                      list[index].qty += 1;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
    );
  }

  TextFormField buildPriceFormField(double salePrice) {
    return TextFormField(
      obscureText: true,
      controller: priceController,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: kProductPriceError);
        } else if (double.parse(value) > salePrice) {
          removeError(error: kProductSalePriceError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: kProductPriceError);
          return "Required";
        } else if (double.parse(value) <= salePrice) {
          addError(error: kProductSalePriceError);
          return "Invalid";
        }
        return null;
      },
    );
  }
}
