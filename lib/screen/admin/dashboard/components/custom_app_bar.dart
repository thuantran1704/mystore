import 'package:flutter/material.dart';
import 'package:mystore/controller.dart';
import 'package:mystore/constants.dart';
import 'package:provider/provider.dart';

class CustomAppbar extends StatelessWidget {
  const CustomAppbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: context.read<Controller>().controlMenu,
          icon: Icon(
            Icons.menu,
            color: kTextColor.withOpacity(0.5),
          ),
        ),
        // const Expanded(child: SearchField()),
        const ProfileInfo()
      ],
    );
  }
}

class SearchField extends StatelessWidget {
  const SearchField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          hintText: "Search for Statistics",
          helperStyle: TextStyle(
            color: kTextColor.withOpacity(0.5),
            fontSize: 15,
          ),
          fillColor: kSecondaryColor,
          filled: true,
          border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(10)),
          prefixIcon: Icon(
            Icons.search,
            color: kTextColor.withOpacity(0.5),
          )),
    );
  }
}

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: appPadding),
          padding: const EdgeInsets.symmetric(
            horizontal: appPadding,
            vertical: appPadding / 2,
          ),
          child: Row(
            children: [
              ClipRRect(
                child: Image.asset(
                  'assets/images/photo3.jpg',
                  height: 38,
                  width: 38,
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              // if (!Responsive.isMobile(context))
              //   const Padding(
              //     padding: EdgeInsets.symmetric(horizontal: appPadding / 2),
              //     child: Text(
              //       'Hi, Arinalis',
              //       style: TextStyle(
              //         color: kTextColor,
              //         fontWeight: FontWeight.w800,
              //       ),
              //     ),
              //   )
            ],
          ),
        )
      ],
    );
  }
}
