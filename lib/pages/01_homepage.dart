import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/pages/00_login.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/tamplate/appbar.dart';
import 'package:users_tasks_mz_153/tamplate/bottomnavbar.dart';

// ignore: must_be_immutable
class HomePage extends StatelessWidget {
  static int selectedPage = 0;
  ThemeController themeController = Get.find();
  MainController mainController = Get.find();
  static int notifitask = 0;
  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    if (LogIn.getversion != LogIn.appversion) {
      return const Scaffold(
        body: Center(
          child: Text(
            '''
      النسخة الحالية من التطبيق لم تعد معتمدة
      قم بتحديث التطبيق
      ''',
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
              child: GetBuilder<MainController>(
            init: mainController,
            builder: (_) => GestureDetector(
              onTap: () {
                mainController.cloasedp();
              },
              child: Scaffold(
                body: Home.pages[selectedPage]['page'],
                appBar: AppBarMZ(context),
                bottomNavigationBar: GetBuilder<ThemeController>(
                  init: themeController,
                  builder: (_) => SizedBox(
                    height: AppBar().preferredSize.height,
                    child: BottomNBMZ(),
                  ),
                ),
              ),
            ),
          )));
    }
  }
}
