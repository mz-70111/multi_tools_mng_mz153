// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/db/database.dart';
import 'package:users_tasks_mz_153/pages/02_home.dart';
import 'package:users_tasks_mz_153/tamplate/tamplateofclass.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

class BottomNBMZ extends StatelessWidget {
  MainController mainController = Get.find();
  DBController dbController = Get.find();
  ThemeController themeController = Get.find();
  static bool vis = true;
  static List pageslist = [
    {
      'visible': true,
      'label': 'الصفحة الرئيسية',
      'icon': Icons.home,
      'rotate': 45.0 * pi / 180,
      'irotate': -45.0 * pi / 180,
      'rize': -25.0,
      'color': ThemeMZ.mode == "light"
          ? [Colors.transparent, Colors.indigoAccent, Colors.transparent]
          : [
              Colors.transparent,
              Color.fromARGB(255, 42, 43, 80),
              Colors.transparent
            ],
      'border': Colors.white
    },
    {
      'visible': checkifUserisAdmin(
                  usertable: DB.userstable,
                  userid: DB.userstable[DB.userstable.indexWhere(
                          (element) => element['username'] == Home.logininfo)]
                      ['user_id']) ==
              true
          ? true
          : false,
      'label': 'السجل',
      'icon': Icons.report,
      'rotate': 0.0,
      'irotate': 0.0,
      'rize': 0.0,
      'color': ThemeMZ.mode == "light"
          ? [Colors.transparent, Colors.indigoAccent, Colors.transparent]
          : [
              Colors.transparent,
              Color.fromARGB(255, 42, 43, 80),
              Colors.transparent
            ],
    },
  ];
  BottomNBMZ({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
          height: AppBar().preferredSize.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: ThemeMZ().appbarbk())),
          child: GetBuilder<MainController>(
            init: mainController,
            builder: (_) {
              pageslist[1]['visible'] = checkifUserisAdmin(
                          usertable: DB.userstable,
                          userid: DB.userstable[DB.userstable.indexWhere(
                                  (element) =>
                                      element['username'] == Home.logininfo)]
                              ['user_id']) ==
                      true
                  ? true
                  : false;
              return GetBuilder<ThemeController>(
                init: themeController,
                builder: (_) {
                  pageslist[1]
                      ['color'] = [Colors.transparent, Colors.transparent];
                  return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ...pageslist
                            .where((element) => element['visible'] == true)
                            .map((e) => Stack(
                                  alignment: AlignmentDirectional.center,
                                  children: [
                                    TweenMZ.rotate(
                                      duration: 200,
                                      end: e['rotate'],
                                      child0: TweenMZ.translatey(
                                        duration: 300,
                                        end: e['rize'],
                                        child0: Container(
                                          height: 60,
                                          width: 60,
                                          child: Container(
                                            child: TweenMZ.rotate(
                                              duration: 500,
                                              end: e['irotate'],
                                              child0: IconButton(
                                                  onPressed: () {
                                                    mainController.navbar(
                                                        pageslist.indexOf(e));
                                                  },
                                                  icon: Icon(
                                                    e['icon'],
                                                    color: Colors.white,
                                                  )),
                                            ),
                                            decoration: BoxDecoration(
                                                borderRadius: const BorderRadius
                                                        .all(
                                                    Radius.elliptical(25, 5)),
                                                gradient: LinearGradient(
                                                    begin: Alignment.topLeft,
                                                    colors: e['color'])),
                                            height: 30,
                                            width: 30,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )),
                      ]);
                },
              );
            },
          )),
    ]);
  }
}

MainController mainController = Get.find();
