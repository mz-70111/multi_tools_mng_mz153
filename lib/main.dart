import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/pages/01_homepage.dart';
import 'package:users_tasks_mz_153/pages/splash.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'controllers/maincontroller0.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(UsersTasksmz());
}

class UsersTasksmz extends StatelessWidget {
  ThemeController themeController = Get.put(ThemeController());
  MainController mainController = Get.put(MainController());
  DBController dbController = Get.put(DBController());
  UsersTasksmz({super.key});
  @override
  Widget build(BuildContext context) {
    Future(() async => await mainController.getappverion());
    return GetBuilder<ThemeController>(
      init: themeController,
      builder: (_) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Splash(),
        theme: ThemeMZ().theme(),
        getPages: [
          GetPage(name: '/', page: () => const Splash()),
          GetPage(name: '/home', page: () => HomePage())
        ],
      ),
    );
  }
}
