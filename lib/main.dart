import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tourist_app_mobille/bindings/main_binding.dart';
import 'package:tourist_app_mobille/routes/app_pages.dart';
import 'package:tourist_app_mobille/storage/storage.dart';

void main() async {
  await appStorage.openBox();
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
