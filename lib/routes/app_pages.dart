import 'package:get/get.dart';
import 'package:tourist_app_mobille/bindings/city_detail_binding.dart';
import 'package:tourist_app_mobille/bindings/home_binding.dart';
import 'package:tourist_app_mobille/bindings/login_binding.dart';
import 'package:tourist_app_mobille/bindings/main_binding.dart';
import 'package:tourist_app_mobille/bindings/main_page_binding.dart';
import 'package:tourist_app_mobille/bindings/sign_up_binding.dart';
import 'package:tourist_app_mobille/screens/app/main_page.dart';
import 'package:tourist_app_mobille/screens/category_detail/list_destinations_view.dart';
import 'package:tourist_app_mobille/screens/city_detail/city_detail_page.dart';
import 'package:tourist_app_mobille/screens/destination_detail/destination_detail_page.dart';
import 'package:tourist_app_mobille/screens/home/home_page.dart';
import 'package:tourist_app_mobille/screens/login/login_page.dart';
import 'package:tourist_app_mobille/screens/sign_up/sign_up_page.dart';

part 'app_routes.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.SIGN_UP,
      page: () => const SignUpPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.MAIN,
      page: () => const MainPage(),
      binding: MainPageBinding(),
    ),
    GetPage(
      name: AppRoutes.CITY_DETAIL,
      page: () => CityDetailPage(),
      // binding: CityDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.DESTINATION_DETAIL,
      page: () => DestinationDetailPage(),
      // binding: CityDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.LIST_DESTINATIONS,
      page: () => ListDestinationsView(),
    ),
  ];
}
