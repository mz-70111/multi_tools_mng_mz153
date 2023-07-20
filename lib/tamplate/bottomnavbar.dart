// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:users_tasks_mz_153/controllers/databasecontroller0.dart';
import 'package:users_tasks_mz_153/controllers/maincontroller0.dart';
import 'package:users_tasks_mz_153/controllers/themeController.dart';
import 'package:users_tasks_mz_153/tamplate/thememz.dart';
import 'package:users_tasks_mz_153/tamplate/tweenmz.dart';

class BottomNBMZ extends StatelessWidget {
  MainController mainController = Get.find();
  DBController dbController = Get.find();
  ThemeController themeController = Get.find();
  static bool vis = true;
  static List pageslist = [
    {
      'label': 'الصفحة الرئيسية',
      'color': [
        Colors.transparent,
        Colors.indigoAccent,
        Colors.transparent,
      ],
      'icon': Icons.home,
      'rotate': 45.0 * pi / 180,
      'irotate': -45.0 * pi / 180,
      'rize': -25.0,
      'border': Colors.indigo
    },
    {
      'label': 'الأرشيف',
      'color': [
        Colors.transparent,
        Colors.transparent,
      ],
      'icon': Icons.report,
      'rotate': 0.0,
      'irotate': 0.0,
      'rize': 0.0,
      'border': Colors.transparent
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
            builder: (_) => Row(children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: pageslist
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
                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.elliptical(25, 5)),
                                        color: Colors.transparent,
                                        border: Border.all(color: e['border'])),
                                    child: Container(
                                      child: TweenMZ.rotate(
                                        duration: 500,
                                        end: e['irotate'],
                                        child0: IconButton(
                                            onPressed: () {
                                              mainController
                                                  .navbar(pageslist.indexOf(e));
                                            },
                                            icon: Icon(
                                              e['icon'],
                                              color: Colors.white,
                                            )),
                                      ),
                                      decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.elliptical(25, 5)),
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            colors: e['color'],
                                          )),
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
            ]),
          )),
    ]);
  }
}

MainController mainController = Get.find();

class MoreTools extends StatelessWidget {
  MoreTools({super.key});
  ThemeController themeController = Get.find();
  static double dropend = 1000;
  static List moretoolslist = [
    {
      'label': 'تذكير',
      'action': () {
        mainController.homemaincontent(6);
        Get.back();
      },
      'size': 20.0,
      'icon': Icons.schedule
    },
    {
      'label': 'ping',
      'action': () {},
      'size': 20.0,
      'icon': Icons.network_check
    },
    {'label': 'مقسم', 'action': () {}, 'size': 20.0, 'icon': Icons.phone}
  ];
  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainController>(
        init: mainController,
        builder: (_) {
          return Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close)),
              ),
              ...moretoolslist
                  .map((e) => TweenMZ.translatex(
                        begin: -150.0,
                        duration: (moretoolslist.indexOf(e) + 1) * 200,
                        end: 0.0,
                        child0: GestureDetector(
                          onTap: e['action'],
                          child: MouseRegion(
                            onHover: (x) {
                              mainController.changeonhoverdropMore(
                                  ctx: context, x: moretoolslist.indexOf(e));
                            },
                            onExit: (x) {
                              mainController.changeonexitdropMore(
                                  ctx: context, x: moretoolslist.indexOf(e));
                            },
                            child: GetBuilder<ThemeController>(
                              init: themeController,
                              builder: (_) => Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(e['icon']),
                                      Text(
                                        "  ${e['label']}",
                                        style: TextStyle(fontSize: e['size']),
                                      ),
                                    ],
                                  ),
                                  Divider()
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ],
          );
        });
  }
}
