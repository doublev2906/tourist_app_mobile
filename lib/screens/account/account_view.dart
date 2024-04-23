import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:tourist_app_mobille/controllers/account_controller.dart';
import 'package:tourist_app_mobille/core/constants/color_palatte.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';
import 'package:tourist_app_mobille/services/app_service.dart';
import 'package:tourist_app_mobille/storage/storage.dart';

class AccountView extends GetView<AccountController> {
  AccountView({super.key});

  final appService = Get.find<AppService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          title: const Text(
            'Tài khoản',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ColorPalette.primaryColor.withOpacity(0.2),
                    ColorPalette.primaryColor
                  ],
                )),
          ),
        ),
      ),
      body: Obx(() {
        if (appService.currentUser.value.isEmpty) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Bạn chưa đăng nhập. Vui lòng đăng nhập để sử dụng tính năng.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: ColorPalette.primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () => Get.toNamed(AppRoutes.LOGIN),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Đăng nhập'),
                ),
              )
            ],
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Align(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: ColorPalette.primaryColor,
                      child: Icon(
                        FontAwesomeIcons.userTie,
                        size: 36,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      appService.currentUser.value["name"],
                      style: const TextStyle(
                          fontSize: 16,
                          color: ColorPalette.textColorBlack,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 2),
                    Text(
                      appService.currentUser.value["email"],
                      style: const TextStyle(
                          fontSize: 13, color: ColorPalette.textColorBlack),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.userCircle(),
                      size: 24,
                      color: ColorPalette.text1Color,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Hồ sơ',
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorPalette.text1Color,
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: PhosphorIcon(
                        PhosphorIcons.caretRight(),
                        size: 20,
                        color: ColorPalette.textColorBlack,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.camera(),
                      size: 24,
                      color: ColorPalette.text1Color,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Khoảng khắc của bạn',
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorPalette.text1Color,
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: PhosphorIcon(
                        PhosphorIcons.caretRight(),
                        size: 20,
                        color: ColorPalette.textColorBlack,
                      ),
                    ))
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    PhosphorIcon(
                      PhosphorIcons.star(),
                      size: 24,
                      color: ColorPalette.text1Color,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Đánh giá của bạn',
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorPalette.text1Color,
                          fontWeight: FontWeight.w600),
                    ),
                    Expanded(
                        child: Align(
                      alignment: Alignment.centerRight,
                      child: PhosphorIcon(
                        PhosphorIcons.caretRight(),
                        size: 20,
                        color: ColorPalette.textColorBlack,
                      ),
                    ))
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              SizedBox(
                width: Get.width,
                height: 40,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side:
                          const BorderSide(color: ColorPalette.textColorBlack),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () {
                      appService.currentUser.value = {};
                      appStorage.removeData(userKey);
                      Get.toNamed(AppRoutes.LOGIN);
                    },
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(
                          fontSize: 16,
                          color: ColorPalette.textColorBlack,
                          fontWeight: FontWeight.w600),
                    )),
              )
            ],
          ),
        );
      }),
    );
  }
}
