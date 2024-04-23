import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:tourist_app_mobille/bindings/main_binding.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';
import 'package:tourist_app_mobille/storage/storage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  await appStorage.openBox();
  await initializeDateFormatting();
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: MainBinding(),
      debugShowCheckedModeBanner: false,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      supportedLocales: const [
        Locale('vi', 'VN'),
      ],
      locale: const Locale('vi', 'VN'),
      builder: ((context, child) {
        return Stack(
          children: [
            MediaQuery(
              data: MediaQuery.of(context).copyWith(boldText: false),
              child: child!,
            )
          ],
        );
      }),
      enableLog: true,
      theme: ThemeData(fontFamily: 'Roboto', useMaterial3: false),
      initialRoute: AppRoutes.MAIN,
      getPages: AppPages.routes,
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
