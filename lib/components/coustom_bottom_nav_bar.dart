import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mystore/models/user.dart';
import 'package:mystore/screen/cart/cart_screen.dart';
import 'package:mystore/screen/chat_bot/chat_bot.dart';
import 'package:mystore/screen/home/home_screen.dart';
import 'package:mystore/screen/profile/profile_screen.dart';

import '../constants.dart';
import '../enums.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    Key? key,
    required this.selectedMenu,
    required this.currentPage,
    required this.user,
  }) : super(key: key);

  final MenuState selectedMenu;
  final int currentPage;
  final User user;

  @override
  Widget build(BuildContext context) {
    const Color inActiveIconColor = Color(0xFFB6B6B6);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/Shop Icon.svg",
                    color: MenuState.home == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        if (currentPage != 1)
                          {
                            // Navigator.pushNamed(context, HomeScreen.routeName,
                            //     arguments: ProfileArguments(user: user)),
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen(user: user)),
                              (Route<dynamic> route) => false,
                            )
                          }
                      }),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Chat bubble Icon.svg",
                  color: MenuState.chat == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  if (currentPage != 2) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatBotScreen(user: user)),
                        (Route<dynamic> route) => false);
                  }
                },
              ),
              IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/Cart Icon.svg",
                  color: MenuState.cart == selectedMenu
                      ? kPrimaryColor
                      : inActiveIconColor,
                ),
                onPressed: () {
                  if (currentPage != 3) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartScreen(user: user)),
                        (Route<dynamic> route) => false);
                  }
                },
              ),
              IconButton(
                  icon: SvgPicture.asset(
                    "assets/icons/User Icon.svg",
                    color: MenuState.profile == selectedMenu
                        ? kPrimaryColor
                        : inActiveIconColor,
                  ),
                  onPressed: () => {
                        if (currentPage != 4)
                          {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProfileScreen(
                                          user: user,
                                        )),
                                (Route<dynamic> route) => false)
                          }
                      }),
            ],
          )),
    );
  }
}
//   final int? currentIndex;
//   final Function(int)? onChange;
//   const CustomBottomNavBar({Key? key, this.currentIndex, this.onChange})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     final arguments =
//         ModalRoute.of(context)!.settings.arguments as ProfileArguments;
//     return Container(
//       height: kToolbarHeight,
//       decoration: BoxDecoration(color: Colors.white),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: InkWell(
//               onTap: () => {
//                 onChange!(0),
//                 // Navigator.pushNamed(context, HomeScreen.routeName,
//                 //     arguments: ProfileArguments(user: arguments.user)),
//               },
//               child: BottomNavItem(
//                 icon: Icons.home,
//                 title: "Home",
//                 isActive: currentIndex == 0,
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => onChange!(1),
//               child: BottomNavItem(
//                 icon: Icons.menu,
//                 title: "Cart",
//                 isActive: currentIndex == 1,
//               ),
//             ),
//           ),
//           Expanded(
//             child: InkWell(
//               onTap: () => {
//                 onChange!(2),
//                 // Navigator.pushNamed(context, ProfileScreen.routeName,
//                 //     arguments: ProfileArguments(user: arguments.user))
//               },
//               child: BottomNavItem(
//                 icon: Icons.verified_user,
//                 title: "User",
//                 isActive: currentIndex == 2,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BottomNavItem extends StatelessWidget {
//   final bool isActive;
//   final IconData? icon;
//   final Color? activeColor;
//   final Color? inactiveColor;
//   final String? title;
//   const BottomNavItem(
//       {Key? key,
//       this.isActive = false,
//       this.icon,
//       this.activeColor,
//       this.inactiveColor,
//       this.title})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedSwitcher(
//       transitionBuilder: (child, animation) {
//         return SlideTransition(
//           position: Tween<Offset>(
//             begin: const Offset(0.0, 1.0),
//             end: Offset.zero,
//           ).animate(animation),
//           child: child,
//         );
//       },
//       duration: Duration(milliseconds: 500),
//       reverseDuration: Duration(milliseconds: 200),
//       child: isActive
//           ? Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text(
//                     title!,
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       color: activeColor ?? Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   const SizedBox(height: 5.0),
//                   Container(
//                     width: 5.0,
//                     height: 5.0,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: activeColor ?? Theme.of(context).primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           : Icon(
//               icon,
//               color: inactiveColor ?? Colors.grey,
//             ),
//     );
//   }
// }
