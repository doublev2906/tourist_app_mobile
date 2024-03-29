import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/screens/home/home_page.dart';

import '../../core/constants/dimension_constants.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static const routeName = '/main_app';

  @override
  State<MainPage> createState() => _MainAppState();
}

class _MainAppState extends State<MainPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        elevation: 12,
        child: SalomonBottomBar(
          // backgroundColor: Color(0xffF5F5F5),
          currentIndex: _currentIndex,
          onTap: (i) => setState(
            () => _currentIndex = i,
          ),
          selectedItemColor: ColorPalette.primaryColor,
          unselectedItemColor: ColorPalette.primaryColor.withOpacity(0.2),
          selectedColorOpacity: 0.2,
          margin: const EdgeInsets.symmetric(
              horizontal: kMediumPadding, vertical: kDefaultPadding),
          items: [
            SalomonBottomBarItem(
              icon: const Icon(
                FontAwesomeIcons.house,
                size: kDefaultPadding,
              ),
              title: const Text("Trang chủ"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                FontAwesomeIcons.solidHeart,
                size: kDefaultPadding,
              ),
              title: const Text("Yêu thích"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                FontAwesomeIcons.briefcase,
                size: kDefaultPadding,
              ),
              title: const Text("Hành trình"),
            ),
            SalomonBottomBarItem(
              icon: const Icon(
                FontAwesomeIcons.solidUser,
                size: kDefaultPadding,
              ),
              title: const Text("Tài khoản"),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          HomePage(),
          Container(),
          Container(),
          Container(),
        ],
      ),
    );
  }
}
